{
  pkgs,
  ...

}:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    sideloadInitLua = true;
    extraPackages = with pkgs; [
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

      # LSP servers
      bash-language-server
      buf
      gopls
      just-lsp
      lua-language-server
      neocmakelsp
      nil
      ruff
      svelte-language-server
      tailwindcss-language-server
      taplo
      templ
      tinymist
      ty
      typescript-language-server
      wgsl-analyzer
      yaml-language-server

      # Formatters
      mdformat
      prettierd
      stylua
      typstyle
    ];
  };
}
