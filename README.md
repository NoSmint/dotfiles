# Dotfiles

Hey there! 👋 This repo is home to my personal dotfiles, crafted for different Linux setups. They're a mix of what works best for me, but hey, if you find something you like, feel free to grab it, tweak it, test it out, or share it further. Happy customizing!

**NoSmint**

## What are dotfiles?

User-specific application configuration is traditionally stored in so called `dotfiles` (files whose filename starts with a dot). It is common practice to track dotfiles with a version control system such as `Git` to keep track of changes and synchronize dotfiles across various hosts. There are various approaches to managing dotfiles (e.g. directly tracking dotfiles in the home directory v.s. storing them in a subdirectory and symlinking/copying/generating files with a shell script or a dedicated tool or - like I did - using a `bare git repository`).

## Overview

The dotfiles in this repository are managed using a bare Git repository, a method popularized by various developers and described in detail by [Drew DeVault](https://drewdevault.com/2019/12/30/dotfiles.html) and in the [Atlassian dotfiles tutorial](https://www.atlassian.com/git/tutorials/dotfiles). This approach allows for easy replication on new machines and straightforward version control.

## Managed Programs

**This repository contains the following dotfiles and configs:**

- `qterminal`
- `midnight commander`
- `btop`
- `neofetch`
- `Obsidian`
- `lf`

## Installation

> [!CAUTION]
> If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Installing dotfiles onto a new system

You can clone the repository wherever you want. The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone --bare https://github.com/NoSmint/dotfiles.git $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    mkdir -p .config-backup
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc
```
