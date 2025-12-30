#!/bin/bash

# Usage: ./setup-remote-complete.sh user@host
# Example: ./setup-remote-complete.sh root@10.0.0.232

if [ -z "$1" ]; then
    echo "Usage: $0 user@host"
    echo "Example: $0 root@10.0.0.232"
    exit 1
fi

TARGET=$1
USER=$(echo $TARGET | cut -d@ -f1)
HOST=$(echo $TARGET | cut -d@ -f2)

echo "🚀 Setting up $TARGET..."

# Check if Oh My Zsh already exists
echo "📦 Installing Oh My Zsh..."
ssh $TARGET 'if [ ! -d ~/.oh-my-zsh ]; then sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; else echo "Oh My Zsh already installed"; fi'

# Install Powerlevel10k
echo "🎨 Installing Powerlevel10k..."
ssh $TARGET 'if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k; else echo "Powerlevel10k already installed"; fi'

# Install plugins
echo "🔌 Installing zsh plugins..."
ssh $TARGET 'if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; else echo "zsh-autosuggestions already installed"; fi'

ssh $TARGET 'if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; else echo "zsh-syntax-highlighting already installed"; fi'

# Copy configs with FULL PATHS
echo "📋 Copying your .zshrc and .p10k.zsh..."
scp ~/.zshrc $TARGET:/root/.zshrc
[ -f ~/.p10k.zsh ] && scp ~/.p10k.zsh $TARGET:/root/.p10k.zsh || echo "⚠️  No .p10k.zsh found (will be created on first run)"

# Change default shell
echo "🐚 Setting zsh as default shell..."
ssh $TARGET 'chsh -s $(which zsh) 2>/dev/null || sudo chsh -s $(which zsh) $(whoami) 2>/dev/null || echo "Could not change shell automatically"'

echo ""
echo "✅ Setup complete for $TARGET!"
echo ""
echo "To activate:"
echo "  ssh $TARGET"
echo "  exec zsh"
echo ""
echo "If prompt looks weird, run: p10k configure"
