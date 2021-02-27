# magikarp.vim

My base vimrc and some custom configurations I've collected over the years.


This .vimrc contains a bash script to autoinstall the dependencies, one of them is this repository itself.
it stores most of the configurations on a separate folder called ````.vim_magikarp```` in your home path so you can try it without fear of losing your configurations (just backup your main .vimrc file first)

## Requirements

- Vim8.0+, NeoVim
- MacVim or VimR (optional)
- Curl
- Bash
- [Monaco Nerd Font](https://github.com/Karmenzind/monaco-nerd-fonts)



## Manual steps for installation


````shell
$ cd ~
$ mv ~/.vimrc ~/.vimrc_backup
$ mkdir .vim_magikarp
$ curl -o ~/.vim_magikarp/.vimrc https://raw.githubusercontent.com/magikarp-salesman/magikarp.vim/master/.vimrc
$ ln -s ~/.vim_magikarp/.vimrc ~/.vimrc
$ bash .vimrc
$ vim
````

## Automatic installation

````shell
$ curl -o ~/.vim_magikarp/.vimrc --create-dirs https://raw.githubusercontent.com/magikarp-salesman/magikarp.vim/master/.vimrc && ln -sf ~/.vim_magikarp/.vimrc ~/.vimrc && bash .vimrc
````

Keep in mind that this repo might be constantly changing as I go by updating my dotfiles and way of work.
