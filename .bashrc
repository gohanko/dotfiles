# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Functions
setup_machine() {
    sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:mkittler/Fedora_34/home:mkittler.repo
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    sudo dnf update -y
    flatpak update -y

    # Install our packages
    sudo dnf install -y gnome-tweaks syncthing syncthingtray zsh util-linux-user yaru-theme
    flatpak install -y flathub com.visualstudio.code com.github.johnfactotum.Foliate org.keepassxc.KeepassXC org.qbittorrent.qBittorrent org.telegram.desktop com.discordapp.Discord

    # Remove uneeded packages
    sudo dnf remove -y gnome-weather gnome-help gnome-photos gnome-tour gnome-contacts gnome-calendar gnome-abrt
    sudo dnf autoremove -y

    # Setting gnome shell styles
    gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
    gsettings set org.gnome.desktop.interface icon-theme Yaru
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat

    # Setting background picture
    gsettings set org.gnome.desktop.screensaver picture-options zoom
    gsettings set org.gnome.desktop.screensaver picture-uri file:///usr/share/backgrounds/fedora-workstation/aurora-over-iceland.png
    gsettings set org.gnome.desktop.screensaver primary-color '#000000000000'
    gsettings set org.gnome.desktop.screensaver secondary-color '#000000000000'
    
    # Setting keyboard shortcuts
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

    # Keybind 0
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>t'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Open Terminal'

    # Setting gnome-terminals settings
    GNOME_TERMINAL_PROFILE=`gsettings get org.gnome.Terminal.ProfilesList default | awk -F \' '{print $2}'`
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ visible-name 'Default'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ use-theme-colors false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ foreground-color 'rgb(208,207,204)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ background-color 'rgb(23,20,33)'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$GNOME_TERMINAL_PROFILE/ use-system-font false

    # Setting system settings
    rfkill block bluetooth
    hostnamectl set-hostname lightblue

    # Installing and configuring ZSH
    sudo chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
    
    # power10k zsh theme
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    # Copying config files
    git clone https://github.com/gohanko/app-configs
    sudo cp ./app-configs/firefox/policies.json /usr/lib64/firefox/distribution/policies.json
    cp ./app-configs/vscode/settings.json $HOME/.var/app/com.visualstudio.code/config/Code/User/settings.json # VSCode for flatpak.
    rm -rf ./app-configs/

    echo "Please restart the machine for changes to take effect."
}