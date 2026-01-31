-- test using :luafile %

local util = require("util")

M = {}


function jj_changes_for_last_n(n) 
	local n = n or 1

	local template = [['stringify(self.change_id())']]
	local lines = vim.fn.system("jj log -r 'ancestors(@, "..n..") | @' --template " .. template)

	local res = {}
	for change in vim.gsplit(lines, "\n") do
		if n == 0 then break else n = n - 1 end
		if string.len(change) == 0 then -- string because of trailing \n
			break
		end
		-- chop off: `@  ` and `◆  `
		local without_header = vim.split(change, "  ")[2]
		res[without_header] = true
	end
	
	return res
end

-- lines in the current file that where modified in the 
-- last n commits
--
-- returns a table of lines with keys: path, linenumber, line
function jj_diff(n) 
	local res = {}
	local allowed_changes = jj_changes_for_last_n(n)

	local template = [['stringify(self.commit().change_id()) ++ "\t" ++ self.line_number() ++ "\t" ++ self.content()']]
	local files = vim.fn.system("jj diff --name-only -r \'ancestors(@, "..n..")\'")
	for file in vim.gsplit(files, "\n") do
		if string.len(file) == 0 then -- trailing \n
			break
		end
		local lines = vim.fn.system("jj file annotate -T ".. template .. " " .. file)
		for line in vim.gsplit(lines, "\n", { trimempty=true }) do 
			if string.len(file) == 0 then -- last one is nil due to ending \n
				break
			end

			local annotations = vim.split(line, "\t")
			local change = annotations[1]
			if allowed_changes[change] then 
				local unindented = annotations[3]:gsub("^%s*(.-)%s*$", "%1")
				res[#res+1] = {
					["path"] = file, 
					["lnum"] = tonumber(annotations[2]), 
					["content"] = unindented
				}
			end
		end
	end

	return res
end

function shorten_path(path, max_len)
	local res = ""
	local components_left = vim.split(path, "/")
	local max_len = math.max(max_len, 
		math.min(0, #components_left - 1) * 2 -- slashes and one char per path
		+ string.len(components_left[#components_left]) -- full file name
	)

	while #components_left > 0 do
		local last = table.remove(components_left, #components_left)

		local chars_available = math.max(1, max_len - string.len(res))
		local chars_to_take = math.min(chars_available, string.len(last))
		local component = string.sub(last, 0, chars_available)

		if res == "" then
			res = component
		else 
			res = component .. "/" .. res
		end
	end

	return res
end

-- Search for string added in last "..n.." changes"
function M.change_diff_scope(n)
	local diff = jj_diff(n)
	local conf = require('telescope.config').values;

	-- pretty good telescope custom picker guide
	-- https://www.jonashietala.se/blog/2024/05/08/browse_posts_with_telescopenvim/
	require('telescope.pickers').new(opts, {
		prompt_title = "Search for string added in last "..n.." changes",
		finder = require('telescope.finders').new_table({
			results = diff,
			entry_maker = function(entry) 
				return {
					display = shorten_path(entry.path, 20) .. ":  " .. entry.content,
					ordinal = entry.content,
					-- Needed by the preview: vim_buffer_vimgrep
					lnum = entry.lnum,    
					filename = vim.fs.basename(entry.path),
					path = entry.path,
				}
			end,
		}),
		sorter = conf.generic_sorter({}),
		previewer = conf.grep_previewer({}),
	}):find()
end

M.change_diff_scope(3)
-- print(vim.inspect(jj_diff(2)))
-- print(vim.inspect(jj_changes_for_last_n(2)))
-- print(shorten_path("/hello/long/path/file.rs", 10))
-- print(shorten_path("tests/ui/suggestions/suggest-private-field.rs", 10))
