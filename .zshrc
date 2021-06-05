## Aliases
# Open .zshrc to be edited in VS Code
alias change="code ~/.zshrc"
# Re-run source command on .zshrc to update current terminal session with new settings
alias update="source ~/.zshrc"

## colorls
alias l='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long' # detailed list view
source $(dirname $(gem which colorls))/tab_complete.sh

## NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
  # Set Spaceship ZSH as a prompt
  autoload -U promptinit; promptinit
  prompt spaceship

# Automatically switch node versions when a directory has a `.nvmrc` file
autoload -U add-zsh-hook
# Zsh hook function
load-nvmrc() {
    local node_version="$(nvm version)" # Current node version
    local nvmrc_path="$(nvm_find_nvmrc)" # Path to the .nvmrc file

    # Check if there exists a .nvmrc file
    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    # Check if the node version in .nvmrc is installed on the computer
    if [ "$nvmrc_node_version" = "N/A" ]; then
        # Install the node version in .nvmrc on the computer and switch to that node version
        nvm install
    # Check if the current node version matches the version in .nvmrc
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
        # Switch node versions
        nvm use
    fi
    # If there isn't an .nvmrc make sure to set the current node version to the default node version
    elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}
# Add the above function when the present working directory (pwd) changes
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Allow the use of the z plugin to easily navigate directories
. /usr/local/etc/profile.d/z.sh

function ssl-check() {
    f=~/.localhost_ssl;
    ssl_crt=$f/server.crt
    ssl_key=$f/server.key
    b=$(tput bold)
    c=$(tput sgr0)

    local_ip=$(ipconfig getifaddr $(route get default | grep interface | awk '{print $2}'))
    # local_ip=999.999.999 # (uncomment for testing)

    domains=(
        "localhost"
        "$local_ip"
    )

    if [[ ! -f $ssl_crt ]]; then
        echo -e "\n🛑  ${b}Couldn't find a Slate SSL certificate:${c}"
        make_key=true
    elif [[ ! $(openssl x509 -noout -text -in $ssl_crt | grep $local_ip) ]]; then
        echo -e "\n🛑  ${b}Your IP Address has changed:${c}"
        make_key=true
    else
        echo -e "\n✅  ${b}Your IP address is still the same.${c}"
    fi

    if [[ $make_key == true ]]; then
        echo -e "Generating a new Slate SSL certificate...\n"
        count=$(( ${#domains[@]} - 1))
        mkcert ${domains[@]}

        # Create Slate's default certificate directory, if it doesn't exist
        test ! -d $f && mkdir $f

        # It appears mkcert bases its filenames off the number of domains passed after the first one.
        # This script predicts that filename, so it can copy it to Slate's default location.
        if [[ $count = 0 ]]; then
            mv ./localhost.pem $ssl_crt
            mv ./localhost-key.pem $ssl_key
        else
            mv ./localhost+$count.pem $ssl_crt
            mv ./localhost+$count-key.pem $ssl_key
        fi
    fi
}

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export GITHUB_TOKEN=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
