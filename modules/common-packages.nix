{
  pkgs,
  ...
}:
with pkgs;
[
  neovim
  xfce.thunar
  tmux
  stow
  parallel
  unzip
  zip
  dust
  go
  just
  watchexec
  lazygit
  ninja
  starship
  pipx
  bat
  btop
  cmake
  gzip
  diffutils
  github-cli
  git-lfs
  nodejs_22
  lazydocker
  rustup
  pkg-config
  sccache
  distrobox
  visidata
  geeqie
  glow
  units
  killall
  libreoffice
  okteta
  podman-compose
  docker-compose
  devenv
  mutagen
  pandoc
  nixfmt-rfc-style

  clang-tools
  clang

  hotspot
  sleek

  tokei
  dysk # show disk usage, nicer default format than df
]
