#!/bin/bash

# Usage: ./setup-remote-complete.sh user@host
# Example: ./setup-remote-complete.sh root@10.0.0.232

if [ -z "$1" ]; then
    echo "Usage: $0 user@host"
    echo "Example: $0 root@10.0.0.232"
    exit 1
fi

TARGET=$1
echo "🚀 Setting up $TARGET..."

# Step 1: Install Oh My Zsh
echo "📦 Installing Oh My Zsh..."
ssh $TARGET 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# Step 2: Install Powerlevel10k
echo "🎨 Installing Powerlevel10k..."
ssh $TARGET 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'

# Step 3: Install plugins
echo "🔌 Installing zsh plugins..."
ssh $TARGET 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
ssh $TARGET 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'

# Step 4: Copy your configs
echo "📋 Copying your .zshrc and .p10k.zsh..."
scp ~/.zshrc $TARGET:~/.zshrc
scp ~/.p10k.zsh $TARGET:~/.p10k.zsh 2>/dev/null || echo "⚠️  No .p10k.zsh found (will be created on first run)"

# Step 5: Change default shell
echo "🐚 Setting zsh as default shell..."
ssh $TARGET 'sudo chsh -s $(which zsh) $(whoami)' 2>/dev/null || ssh $TARGET 'chsh -s $(which zsh)'

echo ""
echo "✅ Setup complete for $TARGET!"
echo ""
echo "To activate:"
echo "  ssh $TARGET"
echo "  exec zsh"
echo ""
echo "If prompt looks weird, run: p10k configure"
