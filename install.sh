#!/usr/bin/bash

set -ex

function install_apt_stuff {
    # install some base tools
    sudo apt-get update -y
    sudo apt-get install -y \
        curl \
        tmux \
        build-essential \
        cmake \
        python-is-python3 \
        pkg-config \
        fontconfig-config
}
(
    set -ex
    install_apt_stuff
)

# install llvm
bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# install brew
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null

# install stuff via brew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew install fzf
$(brew --prefix)/opt/fzf/install --all
brew tap homebrew/cask-fonts
brew install lazygit kind ctlptl tilt docker openssl font-caskaydia-nerd-font ninja python vifm

function install_python_stuff {
    # install python stuff
    pip3 install visidata poetry
}
(
    set -ex
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
    git clone https://github.com/snorrwe/nvim-config $HOME/.config/nvim
    nvim --headless +PackerSync +q
}
(
    set -ex
    install_nvim
)

cargo install sccache --no-default-features
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
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    # desktop stuff
    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    cd -
    rm -rf alacritty
}

(
    set -ex
    install_alacritty
)
