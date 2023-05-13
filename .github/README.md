# dotfiles
My dotfiles for a Fedora 38 workstation.

# Usage

`git clone --bare https://github.com/gohanko/dotfiles.git $HOME/.dotfiles`

`alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

`rm .bashrc && dotfiles checkout && exit`

`dotfiles remote set-url origin git@github.com:gohanko/dotfiles.git`
