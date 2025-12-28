-- require("mason").setup()
-- require("mason-lspconfig").setup {
-- 	ensure_installed = { "lua_ls", "harper_ls" },
-- }

local function config_and_enable()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	-- capabilities.textDocument.completion.completionItem.snippetSupport = true

	vim.lsp.config('rust-analyzer', {
		cmd = { "rust-analyzer" },
		root_markers = { 'Cargo.toml' },
		filetypes = { 'rust' },
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				assist = {
					importMergeBehavior = "module",
					importGranularity = "module",
				},
				cargo = {
					loadOutDirsFromCheck = true,
				},
				procMacro = {
					enable = true,
				},
			},
		},
	})
	vim.lsp.enable({'rust-analyzer'})
end

vim.lsp.enable("tinymist")
vim.lsp.enable("lua_ls")
vim.lsp.enable("nixd")
vim.lsp.config("typos-lsp", {
	cmd = { "typos-lsp" },
    init_options = {
  --       -- Custom config. Used together with a config file found in 
		-- -- the workspace or its parents,
  --       -- taking precedence for settings declared in both.
  --       -- Equivalent to the typos `--config` cli argument.
  --       config = '~/code/typos-lsp/crates/typos-lsp/tests/typos.toml',
		-- How typos are rendered in the editor, can be one of an Error,
		-- Warning, Info or Hint. 
		-- Defaults to Info.
        diagnosticSeverity = "Info"
    }
})
vim.lsp.enable("typos-lsp")

config_and_enable()

M = {}

function M.setup_rustc_dev()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	local workspace = vim.fs.root(0, 'x.py')
	if workspace == nil then 
		print("ERROR: could not find rust compiler/std workspace")
		return 
	end

	-- stop all lsps (and thus rust-analyzer)
	vim.lsp.stop_client(vim.lsp.get_clients())
	vim.lsp.start({
		name = 'rust-analyzer',
		cmd = {"rust-analyzer"},
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				check = {
					invocationStrategy = "once",
					overrideCommand = {
						"python3",
						"x.py",
						"check",
						"--json-output"
					},
				},
				linkedProjects = {
					"Cargo.toml",
					"compiler/rustc_codegen_cranelift/Cargo.toml",
					"compiler/rustc_codegen_gcc/Cargo.toml",
					"library/Cargo.toml",
					"src/bootstrap/Cargo.toml",
					"src/tools/rust-analyzer/Cargo.toml"
				},
				rustfmt = {
					overrideCommand = {
						workspace .. "/build/host/rustfmt/bin/rustfmt",
						"--edition=2024"
					}
				},
				procMacro = {
					server = workspace .. "/build/host/stage0/libexec/rust-analyzer-proc-macro-srv",
					enable = true,
				},
				cargo = {
					buildScripts = {
						enable = true,
						invocationStrategy = "once",
						overrideCommand = {
							"python3",
							"x.py",
							"check",
							"--json-output"
						}
					},
					sysrootSrc = "./library",
					extraEnv = {
						RUSTC_BOOTSTRAP = "1",
					},
				},
				server = {
					extraEnv = {
						RUSTC_TOOLCHAIN = "nightly",
					}
				}
			},
		},
	})
	print("done")
	-- local settings = vim.lsp.get_clients({ name = "rust_analyzer" })
	-- print(vim.inspect(settings))
end

return M
