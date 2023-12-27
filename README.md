# Kasm Desktop KDE

## Overview

This project allows to tweak KDE and save the tweaks in git.

It uses a KDE image, based on KDE core image.
In-container `~/.config` is saved in git as `./kde-config/.config/`, and
`~/.local` is saved as `./kde-config/.local/`.

The tweaks in `./kde-config/` are then used by Workspaces Core Images.

In-container `~/.config` is completely ignored. `./tweak-theme` maps host
`./kde-config/.config/` to be used as in-container `~/.config`.

## How to tweak KDE and save tweaks

Run container based on a KDE core image:
```sh
BASE_IMAGE=kasmweb/image-cache-private:x86_64-core-kde-bookworm-feature_KASM-5251-kde-base-multi-monitor-kasmvnc-1075773254 ./tweak-theme
```
1. Login with kasm_user/password to https://localhost:6901/.
2. Make necessary KDE tweaks.
3. Use `git diff kde-config` to view your changes.
4. Commit relevant changes.
5. Rinse and repeat.

### KDE menu favourites
Add and remove favourite apps using GUI. Drag & drop to add, right-click click
"Remove from Favorites" to remove.

To save favourite changes in git, use `make save-favourites`, then commit files
staged by it.
