
echo "Updating system"

sudo apt update
sudo apt upgrade -y

mkdir -p ~/source/

sudo apt-get install -y gnome-tweaks
sudo apt-get install -y git
sudo apt-get install -y chrome-gnome-shell
sudo apt-get install -y g++
sudo apt-get install -y clang
sudo apt-get install -y clang-format
sudo apt-get install -y clang-tidy


git config --global user.email  "milan.r.radosavljevic@outlook.com"
git config --global user.name "Milan Radosavljevic" 

	    	
# TODO: Add installation of gnome tweaks extension for firefox
# TODO: Install extensions

# https://extensions.gnome.org/extension/19/user-themes/
# https://extensions.gnome.org/extension/906/sound-output-device-chooser/
# https://extensions.gnome.org/extension/1460/vitals/
# TBD

######################################################################################

echo "Installing fonts"

cd ~
mkdir -p .fonts

git clone https://github.com/adobe-fonts/source-code-pro.git /tmp/fonts
mv /tmp/fonts/TTF/* ~/.fonts
rm -rf /tmp/fonts

wget https://github.com/blobject/agave/releases/download/v37/Agave-Regular.ttf -P ~/.fonts

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ~/.fonts

gsettings set org.gnome.desktop.interface font-name 'Ubuntu Regular 10'
gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu Regular 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono Regular 10'

######################################################################################
 
echo "Setting up theme & icons"

mkdir -p ~/.icons
mkdir -p ~/.themes
mkdir -p ~/.local/share/backgrounds

# Download Theme
mkdir -p /tmp/themes

wget https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic.tar.xz -P /tmp/themes/Nordic.tar.xz
tar -xf /tmp/themes/Nordic.tar.xz -C ~/.themes

sudo cp $HOME/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/schemas/org.gnome.shell.extensions.user-theme.gschema.xml /usr/share/glib-2.0/schemas
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

# Set Theme
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"
gsettings set org.gnome.shell.extensions.user-theme name "Nordic"

# Download Icons
mkdir -p /tmp/icons

git clone https://github.com/vinceliuice/Fluent-icon-theme.git /tmp/icons
/tmp/icons/install.sh

# Set Icons
gsettings set org.gnome.desktop.interface icon-theme "Fluent-dark"

######################################################################################
# Setup dock on GNOME

gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 30
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' 
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

######################################################################################
# Tilix setup


sudo apt install -y tilix
sudo update-alternatives --config x-terminal-emulator

mkdir -p /tmp/tilix
wget https://github.com/komshija/dot/releases/download/v0.0.1/tilix.dconf -P /tmp/tilix/
dconf load /com/gexperts/Tilix/ < /tmp/tilix/tilix.dconf

######################################################################################
# Kitty setup

sudo apt install -y kitty
sudo update-alternatives --config x-terminal-emulator


######################################################################################
# Zsh setup

sudo apt install -y zsh
sudo chsh -s $(which zsh)
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

#Install plugins 
sed -i '/^plugins=(/c\plugins=(git zsh-syntax-highlighting zsh-autosuggestions)' ~/.zshrc

# Download theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

#Install theme
sed -i '/^ZSH_THEME="*"/c\ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc

# Add aliases

# Example
#sed -i -e '$aTEXT_HERE' .zshrc

sed -i -e '$aalias c="clear"' .zshrc
sed -i -e '$aalias src="cd ~/source"' .zshrc
sed -i -e '$aalias env="source ./bin/activate"' .zshrc

source ~/.zshrc

######################################################################################
# Tmux setup

sudo apt-get install -y tmux
wget https://github.com/komshija/dot/releases/download/v0.0.1/tmux.conf -P ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Run manually one by one
tmux
sh -c "~/.tmux/plugins/tpm/scripts/update_plugin.sh"
tmux kill-server
