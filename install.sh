#!/usr/bin/bash

set -ex

function install_apt_stuff {
    # install some base tools
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y \
        curl \
        tmux \
        build-essential \
        cmake \
        pkg-config \
        flatpak \
        fontconfig-config
}
(
    set -e
    install_apt_stuff
)
# install llvm
(
    set -e
    sudo apt-get install -y \
        clang-format \
        clang-tidy \
        clang-tools \
        clang \
        clangd \
        libc++-dev \
        libc++1 \
        libc++abi-dev \
        libc++abi1 \
        libclang-dev \
        libclang1 \
        liblldb-dev \
        libomp-dev \
        libomp5 \
        lld \
        lldb \
        llvm-dev \
        llvm-runtime \
        llvm \
        python3-clang
)

# install brew
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

# install stuff via brew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew install fzf
$(brew --prefix)/opt/fzf/install --all
brew install lazygit kind ctlptl tilt docker openssl ninja python vifm

function install_python_stuff {
    # install python stuff
    pip3 install visidata poetry
}
(
    set -e
    install_python_stuff
)

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

. "$HOME/.cargo/env"

# install rust-analyzer
mkdir -p ~/.local/bin
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

# install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y


function install_nvim {
    # install nvim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/bin/nvim
    # clone nvim config
    if [ -d $HOME/.config/nvim ];
    then
        rm -rf $HOME/.config/nvim
    fi
    git clone https://github.com/snorrwe/nvim-config $HOME/.config/nvim
    nvim --headless -c 'autocmd User PackerSync quitall'
}
( install_nvim )

cargo install -f sccache --no-default-features
export RUSTC_WRAPPER=$HOME/.cargo/bin/sccache
# install rust fluff
cargo install -f ripgrep zoxide fd-find

function install_alacritty {
    # alacritty debian dependencies
    sudo apt-get install -y libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
    # alacritty
    git clone https://github.com/alacritty/alacritty
    cd alacritty
    cargo build --release
    tic -xe alacritty,alacritty-direct extra/alacritty.info
    # desktop stuff
    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    cd -
    rm -rf alacritty
}

(
    set -e
    install_alacritty
)

function install_font {
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts && curl -fLo "CaskaydiaCove Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascaidaCode/Regular/complete/Caskaydia%20Cove%20Regular%20Nerd%20Font%20Complete.otf
}

(
    set -e
    install_font
)
