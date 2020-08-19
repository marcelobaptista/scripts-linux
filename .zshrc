export ZSH="/etc/oh-my-zsh"
ZSH_THEME="gianu"
DISABLE_AUTO_UPDATE="true"
#ENABLE_CORRECTION="true"
plugins=(git colorize command-not-found colored-man-pages common-aliases history-substring-search)
source /etc/oh-my-zsh/oh-my-zsh.sh
source /etc/oh-my-zsh/custom/plugins/zsh-syntax-highlighting.zsh
alias cls="clear"
alias copia="rsync -avh --progress"
alias start="sudo systemctl start"
alias restart="sudo systemctl restart"
alias stop="sudo systemctl stop"
alias enable="sudo systemctl enable"
alias disable="sudo systemctl disable"
alias status="systemctl status"
