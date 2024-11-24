#!/bin/bash

USER="$(whoami)"

prompt_to_continue () {
    local TITLE=$1
    read -p "$TITLE?: <enter> or type <skip|no|n>: " response

    case $response in
        skip|n|no)
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

echo "Running setup script as user: $USER"

# Install homebrew
if prompt_to_continue "🍺 Install homebrew"; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to current PATH
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Add Homebrew to fish's PATH (via config.fish) if it's not already present
    if ! grep -q "brew shellenv" ~/.config/fish/config.fish 2>/dev/null; then
        echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.config/fish/config.fish
    fi
else
    echo "Skipping..."
fi

# Install handy brew CLI tools
if prompt_to_continue "🍺 Installing brew CLI tools"; then
    brew install --force \
        fish \
        starship \
        jq \
        nvm \
        go \
        gh \
        eza \
        font-fira-code-nerd-font \
        font-fira-mono-nerd-font
else
    echo "Skipping..."
fi

if prompt_to_continue "🚀 Install starship theme for fish?"; then
    brew install --force starship

    # Add Homebrew to fish's PATH (via config.fish) if it's not already present
    if ! grep -q "starship init" ~/.config/fish/config.fish 2>/dev/null; then
        echo; echo '# Set up ' >> ~/.config/fish/config.fish
        echo; echo 'starship init fish | source' >> ~/.config/fish/config.fish
    fi
else
    echo "Skipping..."
fi

# Install handy brew GUI tools
if prompt_to_continue "🍺 Install brew GUI apps"; then
    PARAMS=( visual-studio-code )
    
    # Check if iterm2 is already installed
    if [ -d "/Applications/iTerm.app" ]; then
        echo "iTerm2 is already installed... Skipping!"
    else
        # If it's not, add it to the brew install params
        PARAMS=( "${PARAMS[@]}" )
    fi

    brew install --cask ${PARAMS[@]}
else
    echo "Skipping..."
fi

# -----------------------------------------------------------
# |                      SUDO SECTION                       |
# -----------------------------------------------------------

if prompt_to_continue "🔒 Enable sudo and change shell to fish"; then
sudo bash <<END_SUDO
    # Enable sudo to set up config
    sudo su

    # Add fish to /etc/shells and set it as default
    read -p "🐟 Setting fish as default shell... <enter>"
    echo "$(which fish)" | tee -a /etc/shells
    chsh -s "$(which fish)" $USER
END_SUDO
else
    echo "Skipping..."
fi

# -----------------------------------------------------------
# |                  ENDING SUDO SECTION                    |
# -----------------------------------------------------------

# Install omf
if prompt_to_continue "🐟 Install oh-my-fish"; then
    OMF_PATH=$(fish -c 'set -q OMF_PATH; and echo $OMF_PATH || echo ""')

    if [ ! -z "$OMF_PATH" ]; then
        echo "Existing omf installation found at $OMF_PATH"
    else
        curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish --init-command 'set argv --noninteractive'
    fi
else
    echo "Skipping..."
fi

# Install nvm wrapper for fish shell
if prompt_to_continue "🐟 Install nvm wrapper for fish shell"; then
    fish -c "omf install nvm"
else
    echo "Skipping..."
fi

# Set up vscode config and extensions
if prompt_to_continue "💻 Import (overwrite) vscode extensions from config"; then
    mkdir -p ~/.vscode/extensions
    cp -R ./vsconfig/extensions/* ~/.vscode/extensions
    echo "VS Code extensions set up in \"~/.vscode/extensions\""
else
    echo "Skipping..."
fi

if prompt_to_continue "💻 Import (overwrite) vscode user keybindings from config"; then
    mkdir -p $HOME/Library/Application\ Support/Code/User/
    cp -R ./vsconfig/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
    echo "VS Code keybindings set up in \"$HOME/Library/Application\ Support/Code/User/keybindings.json\""
else
    echo "Skipping..."
fi

if prompt_to_continue "💻 Import (overwrite) vscode user settings from config"; then
    mkdir -p $HOME/Library/Application\ Support/Code/User/
    cp -R ./vsconfig/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
    echo "VS Code settings set up in \"$HOME/Library/Application\ Support/Code/User/settings.json\""
else
    echo "Skipping..."
fi

# Manual steps
echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃ Don't forget to do the following!                                             ┃"
echo "┃  Install node/nvm (fisher: https://github.com/jorgebucaran/nvm.fish)         ┃"
echo "┃  Install golang                                                              ┃"
echo "┃  Manually set up iterm2 with config from './iterm2.settings.itermexport'     ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

# Change to fish shell
echo "🐟 Changing to fish shell..."
fish
