# dotfiles
My dotfiles for a Fedora 35 workstation.

# Usage
`git clone --bare https://github.com/gohanko/dotfiles.git $HOME/.dotfiles && alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' && rm .bashrc && dotfiles checkout && exit`
