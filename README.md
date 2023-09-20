# Dotfiles Repository

This repository contains my dotfiles for my linux setup. It is managed using [Chezmoi](https://www.chezmoi.io/).

## Manual Setup

The following steps will install chezmoi and apply the dotfiles. Just used to keep updated my dotfiles between different machines, but it needs some other files like wallpapers, icons, fonts and themes that are not included in this repository.

### Install Chezmoi

```bash
curl -sfL https://git.io/chezmoi | sh # or install from package manager
```

### Clone Repository

```bash
chezmoi init https://github.com/fracergu/dotfiles.git
```

### Apply Dotfiles

```bash
chezmoi apply
```

## Automated install

The automated install script will install chezmoi and apply the dotfiles. It will also install some other packages that I use and download some other files like wallpapers, icons, fonts and themes from my own cdn. Ideal for a fresh OS install.

```bash
sh <(curl -fsSL https://raw.githubusercontent.com/fracergu/dotfiles/main/dotconfig.sh)
```
