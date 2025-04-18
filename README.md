[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) [monogram font](https://datagoblin.itch.io/monogram) in `.local/share/fonts/`
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) [godot logo](https://godotengine.org/press/) in `.config/fiecueal/`

Setup is done this way: https://www.atlassian.com/git/tutorials/dotfiles

script:
```sh
cd $HOME
sudo apt install git -y
git clone --bare https://github.com/fiecueal/.dotfiles
alias config="git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git/"
config checkout
if [ $? -ne 0 ]; then
  mkdir -p .config/fiecueal/backup
  config checkout 2>&1 | egrep "\s+\." | awk '{print $1}' | xargs -I{} mv {} .config/fiecueal/backup
  config checkout
fi
$HOME/.config/fiecueal/init.sh
```

explanation for myself because I don't use bash enough to remember:
- `$?` exit status of previous command (0 is success)
- `2>&1` redirects stderr to stdout
- `egrep` grep but special characters (?, +, etc.) are not fixed strings
- `awk '{print $1}'` outputs the first word in every line without any whitespace
- `xargs` runs the command for every arg from stdin (input is split by whitespace)
- `I{}` replaces instances of {} in the command with entries from the input (e.g. mv {} becomes mv .bashrc)
