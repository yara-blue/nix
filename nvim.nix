{ pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.unstable.neovim-unwrapped;

    viAlias = false;
    vimAlias = false;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.stable.vimPlugins; [ # cause treesitter ...

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
      vim-jjdescription
      mini-base16

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
      crates-nvim

      # Text tools
      vim-easy-align

      # Other
      leap-nvim
      pkgs.unstable.vimPlugins.neomutt-vim
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
