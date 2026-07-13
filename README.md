# dotfiles

我的 macOS 个人配置文件备份。

## 包含

- **nvim/init.lua** — Neovim 配置（lazy.nvim + LSP + blink.cmp + telescope）
- **zshrc** — Zsh 配置（fzf、zsh-autosuggestions、zsh-syntax-highlighting）

## 使用方法

```bash
# 克隆仓库
git clone https://github.com/JasperStonnne/dotfiles.git ~/dotfiles

# 恢复 Neovim 配置
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua

# 恢复 Zsh 配置
ln -sf ~/dotfiles/zshrc ~/.zshrc
```
