{
  pkgs,
  ...
}:
with pkgs;
[
  xfce.thunar
  tmux
  stow
  parallel
  unzip
  zip
  dust # nicer du alternative
  go
  just
  watchexec
  lazygit
  ninja
  starship # for my shell prompt
  pipx
  bat # colorful, syntax highlighted cat alternative
  btop
  cmake
  gzip
  diffutils
  github-cli
  git-lfs
  nodejs_22
  lazydocker

  rustup
  cargo-binstall
  cargo-nextest
  cargo-watch
  cargo-clean-recursive
  # topgrade deps to manage cargo-installed packages
  cargo-update
  cargo-cache

  pkg-config
  sccache
  distrobox
  visidata
  geeqie
  glow # tui markdown reader/renderer
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

  hotspot # perf GUI
  flamegraph
  sleek # SQL formatter

  tokei # count LOC
  dysk # show disk usage, nicer default format than df

  hyperfine # cli benchmarking tool
  sshfs
  fzf
  python3
  yazi
]
