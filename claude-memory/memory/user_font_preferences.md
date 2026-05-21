---
name: Font preferences and current Linux setup
description: User chose Smile Nerd Font Mono everywhere for visual consistency, accepting wider spacing as a tradeoff. All managed via dotfiles repo.
type: user
originSessionId: df985589-04c7-4659-bc8a-18fec5ad530b
---
User decided on **Smile Nerd Font Mono** as the primary font across the entire Linux desktop (terminal, GTK UI, document, fontconfig generic families). LXGW WenKai (proportional) and LXGW WenKai Mono kept as further fallbacks for any glyph Smile lacks.

**Important context on the tradeoff**: The user initially flagged that Smile feels wide (FiraCode-based ASCII × 2 for CJK = sparse columns) and briefly switched to Ubuntu Mono + LXGW. After seeing the Smile-everywhere demo, they preferred visual consistency over narrow spacing and made it their actual config. So when they say "字间距大" in a future conversation about Smile, treat it as a known/accepted tradeoff rather than a problem to solve — unless they explicitly reopen the question.

**System touchpoints (all in their dotfiles repo at `~/dev/personal/dotfiles`, github.com/JasperStonnne/dotfiles)**:
- `fontconfig/.config/fontconfig/conf.d/10-lxgw-cjk-fallback.conf` — generic family chain (Smile primary + LXGW fallback)
- `fontconfig/.config/fontconfig/conf.d/20-windows-mac-aliases.conf` — redirects hardcoded Windows/macOS Chinese font names (Microsoft YaHei, PingFang SC, Consolas, SimSun, etc.) directly to Smile + LXGW. Two-level alias chains don't cascade in fontconfig, so these must name the concrete fonts, not the generic families.
- `scripts/install-fonts.sh` — downloads Smile and LXGW from GitHub releases.
- `gnome/gnome.dconf` — captures Ptyxis + GTK interface font settings via `dconf dump /org/gnome/`.
- `scripts/bootstrap.sh --with-gnome --with-apt --with-fonts` — full one-shot replay on a new machine.

**Apps known to be on this machine**:
- QQ at `/opt/QQ/` and WeChat at `/opt/wechat/` — both Electron (Chromium), not Qt, so they pick up fontconfig automatically. The 20-windows-mac-aliases.conf is what makes their CSS-hardcoded Windows font names resolve to Smile.
- Chrome — follows fontconfig.
- Ptyxis — primary terminal.

**Things not currently a problem but worth knowing for future**:
- If they install VSCode/Firefox/JetBrains/Obsidian later, those have their own font settings that fontconfig can't override. Will need to set the font inside each app's preferences.
- For Qt apps: `libqgtk3.so` is available; setting `QT_QPA_PLATFORMTHEME=gtk3` would inherit GTK fonts. Not currently set — wasn't needed since QQ/WeChat are Electron.
- A `/tmp/smile-rollback.sh` was prepared during exploration to revert to Ubuntu Mono + LXGW; user did not choose that path. The script may not survive reboots.
