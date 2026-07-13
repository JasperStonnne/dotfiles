# dotfiles

我的 macOS 个人配置文件备份。

## 包含

- **nvim/init.lua** — Neovim 配置（lazy.nvim + LSP + blink.cmp + telescope）
- **zshrc** — Zsh 配置（fzf、zsh-autosuggestions、zsh-syntax-highlighting）
- **ghostty/config.ghostty** — Ghostty 终端配置（深紫主题 + JetBrainsMono）
- **Brewfile** — Homebrew 安装清单，换电脑一条命令恢复

## 使用方法

```bash
# 克隆仓库
git clone https://github.com/JasperStonnne/dotfiles.git ~/dotfiles

# 恢复 Neovim 配置
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua

# 恢复 Ghostty 配置
mkdir -p ~/.config/ghostty
ln -sf ~/dotfiles/ghostty/config.ghostty ~/.config/ghostty/config.ghostty

# 恢复 Zsh 配置
ln -sf ~/dotfiles/zshrc ~/.zshrc

# 一键安装所有 Homebrew 包
cd ~/dotfiles && brew bundle
```
