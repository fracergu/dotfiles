#!/bin/bash

user_can_sudo() {
    sudo -n true 2>/dev/null
    return $?
}


# Determinar el gestor de paquetes
if command -v pacman &> /dev/null; then
    PM="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    CHECK_CMD="pacman -Q"
elif command -v dnf &> /dev/null; then
    PM="dnf"
    INSTALL_CMD="sudo dnf install -y"
    CHECK_CMD="dnf list installed"
elif command -v apt &> /dev/null; then
    PM="apt"
    INSTALL_CMD="sudo apt-get install -y"
    CHECK_CMD="dpkg -l"
else
    echo "No se pudo encontrar un gestor de paquetes compatible."
    exit 1
fi

# Verificar e instalar paquetes si es necesario
packages=("git" "kitty" "neovim" "chezmoi" "zsh" "curl" "feh")
for package in "${packages[@]}"; do
    if ! $CHECK_CMD $package &> /dev/null; then
        $INSTALL_CMD $package
    fi
done

# Establecer zsh como consola por defecto si no lo es
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    if user_can_sudo; then
        sudo -k chsh -s "/usr/bin/zsh" "$USER"
    else
        chsh -s "/usr/bin/zsh" "$USER"
    fi
fi


# Instalar oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"
# Definir la ubicación ZSH_CUSTOM
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Descargar powerlevel 10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Descargar plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# Instalar bun
curl -fsSL https://bun.sh/install | bash

# Instalar nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash


# Descargar iconos
curl -sL cdn.fracergu.dev/icons/papirus-icon-theme.tar.gz -o /tmp/papirus-icon-theme.tar.gz
mkdir -p ~/.icons && tar -xf /tmp/papirus-icon-theme.tar.gz -C ~/.icons

# Descartar temas
curl -sL cdn.fracergu.dev/themes/adwaita-dark.tar.gz -o /tmp/adwaita-dark.tar.gz
mkdir -p ~/.themes && tar -xf /tmp/adwaita-dark.tar.gz -C ~/.themes


# Inicializar chezmoi
chezmoi init https://github.com/fracergu/dotfiles.git

# Importar dotfiles
echo "Importando dotfiles.."
chezmoi apply

# Actualizar fuentes
fc-cache

# Cargar configuración de GNOME
dconf load / < ~/.config/dconf-settings.ini

# Reiniciar
reboot