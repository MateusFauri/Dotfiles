#!/bin/bash
echo -e "Iniciando Instalação... \n"
sudo pacman -Syu --noconfirm

# Configurando audio (pode dar problema pipewire com pulse ....)
sudo pacman -S --noconfirm pipewire pipewire-pulse
sleep 3

# Necessarios
sudo pacman -S --noconfirm  libreoffice-still kitty wofi swaybg mesa vulkan-radeon amd-ucode nerd-fonts firefox gufw ffmpeg gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav gstreamer fwupd xclip dunst swayidle brightnessctl

# utilitarios
sudo pacman -S --noconfirm discord code neofetch flameshot dolphin pavucontrol playerctl pamixer steam flatpak packagekit-qt5 ncdu calcurse deepin-calculator dnsutils net-tools
  

# nerdfontes
read -n1 -rep 'Would you like to install nerd-fonts? (y,n)' NFS
if [[ $NFS == "Y" || $NFS == "y" ]]; then
    sudo pacman -S nerd-fonts  #como fazer ele aceitar todos os pacotes automaticamente??

    # Astronvim
    sudo pacman -S --noconfirm neovim npm nodejs
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    mv ~/.local/state/nvim ~/.local/state/nvim.bak
    mv ~/.cache/nvim ~/.cache/nvim.bak
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
fi

# Start the bluetooth service
echo -e "Starting the Bluetooth Service...\n"

# Bluetooth
sudo pacman -S --noconfirm blueman sbc libldac hidapi
sudo systemctl enable --now bluetooth.service

# Docker 
sudo pacman -S --noconfirm docker docker-compose

# Yay
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "yay was located, moving on.\n"
    yay -Suy --noconfirm
else 
    echo -e "yay was not locate, instaling yay.... \n"
    pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    
    sudo pacman -Syu --noconfirm
    yay -Y --gendb

    # proton
    yay -S --noconfirm proton-ge-custom-bin
    
    # If need for set wallpaper in hypr!!
    #yay -S --noconfirm waypaper-git
fi

# Change the network manager
read -n1 -rep 'Would you like change the network manager to connman? (y,n)' NET
if [[ $NET == "Y" || $NET == "y" ]]; then
    sudo systemctl stop NetworkManager.service && sudo systemctl disable NetworkManager.service

    sudo pacman -S --noconfirm connman
    sudo systemctl enable connman.service && sudo systemctl start --now connman.service
    if [ -f "$ISYAY" ]; then 
        yay -Suy --noconfirm
        yay -S --noconfirm cmst
    if
fi

# Zsh
read -n1 -rep 'Would you like to set Zsh for editor? (y,n)' ZSH
if [[ $ZSH == "Y" || $ZSH == "y" ]]; then
    sudo pacman -S --noconfirm  zsh
    chsh -s $(which zsh)
    export EDITOR=/usr/bin/vim
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
fi

# Anaconda
read -n1 -rep 'Would you like to install Anaconda? (y,n)' ANC
if [[ $ANC == "Y" || $ANC == "y" ]]; then
    wget https://repo.anaconda.com/archive/Anaconda3-2023.07-2-Linux-x86_64.sh
    chmod +x Anaconda-latest-Linux-x86_64.sh
    ./Anaconda3-2023.07-2-Linux-x86_64.sh 
    conda config --set auto_activate_base false
    rm Anaconda-latest-Linux-x86_64.sh
fi

# Fazer um ajuste em que pega os dotfiles do github e coloque nas pastas devidas, verificando a criação de cada uma.
read -n1 -rep "Would you like to configure from MateusFauri/Dotfiles on github? (y,n)" CONF
if [[ $CONF == "Y" || $CONF == "y" ]]; then
    git clone https://github.com/MateusFauri/Dotfiles.git
    mv Dotfiles/* ~/.config/
    rm -rf Dotfiles
    cd ~/.config
    rm LICENSE README.md arch_config.sh
    cd ..
fi

echo -e "Fim da instalação!! \n"
