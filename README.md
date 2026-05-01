# dotfiles

Personal Linux configuration backup.

## Tracked now

- `bash/.bashrc`
- `xinput/.xinputrc`
- `gtk/.gtkrc-2.0`
- `gtk/.config/gtk-3.0`
- `gtk/.config/gtk-4.0`
- `autostart/.config/autostart`
- `applications/.local/share/applications`
- `fcitx5/.config/fcitx5`
- `fcitx5-data/.local/share/fcitx5/themes`
- `fcitx5-data/.local/share/fcitx5/rime`
- `fontconfig/.config/fontconfig`
- `gnome/gnome.dconf`
- `packages/apt-manual.txt`
- `packages/snap.txt`

## Restore

Clone the repo, then run:

```bash
cd ~/dotfiles
./scripts/bootstrap.sh
```

By default this only syncs files into `$HOME`.

This restore includes shell, GTK, autostart, local application handlers, and
Fcitx5 config/theme/user data.

To also restore GNOME settings:

```bash
./scripts/bootstrap.sh --with-gnome
```

To also install saved APT packages:

```bash
./scripts/bootstrap.sh --with-apt
```

To also download font binaries (Smile Nerd Font Mono + LXGW WenKai):

```bash
./scripts/bootstrap.sh --with-fonts
```

Full one-shot for a fresh machine:

```bash
./scripts/bootstrap.sh --with-gnome --with-apt --with-fonts
```

## Refresh backup

After changing local config, refresh the repo copy:

```bash
./scripts/refresh.sh
```

## Notes

- Do not commit secrets, SSH keys, browser profiles, or shell history.
- Review `.bashrc` before pushing if you later add tokens or private paths.
- `gnome/gnome.dconf` is exported text. `~/.config/dconf/user` is not tracked.
- `fcitx5-data/.local/share/fcitx5/rime` is intentionally trimmed to user data,
  not the full upstream Rime repo.
- Font binaries (Smile, LXGW WenKai) are not committed to git; they are
  downloaded by `scripts/install-fonts.sh` from upstream GitHub releases.
  The fontconfig rules in `fontconfig/.config/fontconfig/conf.d/` reference
  these family names and assume `--with-fonts` was run on a fresh machine.
