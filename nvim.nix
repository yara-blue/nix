{ pkgs, ... }:

# TODO patch some of the neovim plugins to provide their needed executables?
# (like ripgrep ast-grep etc)
# let
# 	telescope_ast_grep = pkgs.vimPlugins.telescope-sg.override {
# 		postInstall = ''
#
# 		''
#
# 	};
# in

{
  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = false;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [

      # Dependencies
      plenary-nvim
      popup-nvim

      # Themes
      tokyonight-nvim
      solarized-nvim
      gruvbox-material

      # Looks
      vim-highlightedyank
      gitsigns-nvim
      lualine-nvim
      lualine-lsp-progress
      nvim-web-devicons
      vim-startify

      # Tools
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      telescope-sg # ast graph seach/regex
      harpoon2
      which-key-nvim
      lsp_lines-nvim
      fidget-nvim
      nvim-lint

      # Text tools
      vim-easy-align

      # Other
      leap-nvim
      neomutt-vim
      nvim-lspconfig
      typst-preview-nvim

      # Nouns, Verbs, textobjects
      comment-nvim
      nvim-surround
      vim-repeat
      vim-textobj-user # TODO do we still need this?
      # vim-textobj-ident

      # Tree sitter
      nvim-treesitter
      nvim-treesitter-context
      nvim-treesitter-textobjects
      (nvim-treesitter.withPlugins (
        p: with p; [
          bash
          c
          cpp
          python
          rust
          lua
          zig
          toml
          ini
          json
          json5
          jq
          regex
          query
          make
          ninja
          dot
          nix
          html
          css
          typescript
          javascript
          markdown
          markdown-inline
          git-config
          git-rebase
          gitcommit
          gitignore
          comment
          udev
          passwd
          typst
          latex
        ]
      ))

      # Completions
      luasnip
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp_luasnip
    ];
  };

}
