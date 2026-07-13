{
  pkgs,
  lib,
  config,
  ...
}:
let

  lspServers = with pkgs; [
    {
      package = markdown-oxide;
      nvim_name = "markdown_oxide";
    }
    {
      package = bash-language-server;
      nvim_name = "bashls";
    }
    {
      package = buf;
      nvim_name = "buf_ls";
    }
    {
      package = gopls;
      nvim_name = "gopls";
    }
    {
      package = just-lsp;
      nvim_name = "just";
    }
    {
      package = lua-language-server;
      nvim_name = "lua_ls";
    }
    {
      package = neocmakelsp;
      nvim_name = "neocmake";
    }
    {
      package = nil;
      nvim_name = "nil_ls";
    }
    {
      package = ruff;
      nvim_name = "ruff";
    }
    {
      package = svelte-language-server;
      nvim_name = "svelte";
    }
    {
      package = tailwindcss-language-server;
      nvim_name = "tailwindcss";
    }
    {
      package = taplo;
      nvim_name = "taplo";
    }
    {
      package = templ;
      nvim_name = "templ";
    }
    {
      package = tinymist;
      nvim_name = "tinymist";
    }
    {
      package = ty;
      nvim_name = "ty";
    }
    {
      package = typescript-language-server;
      nvim_name = "ts_ls";
    }
    {
      package = wgsl-analyzer;
      nvim_name = "wgsl_analyzer";
    }
    {
      package = yaml-language-server;
      nvim_name = "yamlls";
    }
    {
      package = rust-analyzer;
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
      ++ (builtins.map (lsp: lsp.package) lspServers);
  };

  home.activation.lazyRestore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${config.programs.neovim.finalPackage}/bin/nvim --headless -c "Lazy! restore" -c ':qa'
  '';
}
