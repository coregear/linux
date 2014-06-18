sudo apt-get install git-core

#dircolors
cd

git clone git://github.com/seebi/dircolors-solarized.git

cd dircolors-solarized
cp dircolors.256dark ~/.dircolors

vi ~/.bashrc, add:
eval `dircolors ~/.dircolors`
export TERM=xterm-256color

source ~.bashrc

#terminal-colors
cd 
git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git

cd gnome-terminal-colors-solarized/

./set_dark.sh


# vim solarized

mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle

cd ~/.vim/autoload
curl -LSso ~/.vim/autoload/pathogen.vim     https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle
git clone git://github.com/altercation/vim-colors-solarized.git

# .vimrc
syntax on
execute pathogen#infect()
set background=dark
colorscheme solarized
