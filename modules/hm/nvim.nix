{
  pkgs,
  lib,
  config,
  ...
}:
let

  lspServers = [
    {
      pkg = pkgs.markdown-oxide;
      nvim_name = "markdown_oxide";
    }
    {
      pkg = pkgs.bash-language-server;
      nvim_name = "bashls";
    }
    {
      pkg = pkgs.buf;
      nvim_name = "buf_ls";
    }
    {
      pkg = pkgs.gopls;
      nvim_name = "gopls";
    }
    {
      pkg = pkgs.just-lsp;
      nvim_name = "just";
    }
    {
      pkg = pkgs.lua-language-server;
      nvim_name = "lua_ls";
    }
    {
      pkg = pkgs.neocmakelsp;
      nvim_name = "neocmake";
    }
    {
      pkg = pkgs.nil;
      nvim_name = "nil_ls";
    }
    {
      pkg = pkgs.ruff;
      nvim_name = "ruff";
    }
    {
      pkg = pkgs.svelte-language-server;
      nvim_name = "svelte";
    }
    {
      pkg = pkgs.tailwindcss-language-server;
      nvim_name = "tailwindcss";
    }
    {
      pkg = pkgs.taplo;
      nvim_name = "taplo";
    }
    {
      pkg = pkgs.templ;
      nvim_name = "templ";
    }
    {
      pkg = pkgs.tinymist;
      nvim_name = "tinymist";
    }
    {
      pkg = pkgs.ty;
      nvim_name = "ty";
    }
    {
      pkg = pkgs.typescript-language-server;
      nvim_name = "ts_ls";
    }
    {
      pkg = pkgs.wgsl-analyzer;
      nvim_name = "wgsl_analyzer";
    }
    {
      pkg = pkgs.yaml-language-server;
      nvim_name = "yamlls";
    }
    {
      pkg = pkgs.rust-analyzer;
      nvim_name = "rust_analyzer";
    }
  ];

  # list of lsp servers to enable in nvim but not installed here
  extraLsp = builtins.map (s: { nvim_name = s; }) [
    "nushell"
    "clangd"
  ];

  formatters = with pkgs; [
    rumdl
    prettierd
    stylua
    typstyle
    dockerfmt
    sleek
    nixfmt
  ];

in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    sideloadInitLua = true;
    initLua = ''
      vim.g.lsp_servers = { ${
        lib.concatMapStringsSep ", " (s: ''"${s.nvim_name}"'') (lspServers ++ extraLsp)
      } }
    '';
    extraPackages =
      with pkgs;
      [
        # runtime deps
        viu
        chafa
        tree-sitter
        gnutar
        curl
        wget
        python3
        python3Packages.pynvim
        ruby
        gcc
      ]
      ++ formatters
      ++ (builtins.map (lsp: lsp.pkg) lspServers);
  };

  home.activation.lazyRestore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${config.programs.neovim.finalPackage}/bin/nvim --headless -c "Lazy! restore" -c ':qa'
  '';
}
