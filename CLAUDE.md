# Agent guidance: KasmOS KDE desktop

Read README.md, tweak-theme, dockerfile-kasm-kde-tweaks, src/install-theme and
Makefile first. This repo owns appearance and saved KDE configuration.
workspaces-core-images builds the final workspace; app-builder supplies selected
Debian apps. Read their CLAUDE.md files when crossing those boundaries.

## Source map

- `src/install-theme`: installs Materia KDE/GTK themes, geeqie and Plasma addons;
  copies wallpaper to `/usr/share/backgrounds/bg_default.png`, links Materia's
  wallpaper, and installs the KasmOS drawer icon and splash logo.
- `kde-config/.config`: Plasma/KWin/KDE/GTK defaults, autostart and app settings.
- `kde-config/.config/dconf/user`: binary dconf database containing Elementary
  application preferences and GNOME/GTK settings.
- `kde-config/.local/share/plasma/plasmoids/P-Connor.PlasmaDrawer`: drawer QML UI,
  configuration, JavaScript helpers and widget metadata.
- `kde-config/.local/share/kactivitymanagerd/resources`: favorites SQLite database
  and sidecars. `make save-favorites` stages these and kactivitymanagerd-statsrc.
- `tweak-theme`, `dockerfile-kasm-kde-tweaks` and
  `src/inside-docker/kde-tweaks-startup`: interactive editing harness.

## What the final image consumes

Core-images develop installs KDE via `src/ubuntu/install/kde/install_kde.sh`.
Its `dockerfile-kasm-core-kasmos` copies this repo's src to `/tmp/theme-src` and
runs install-theme. It copies `.config` and only `.local/share/plasma` from
kde-config into `/home/kasm-default-profile`, not the entire .local tree or the
favorites database. The harness mounts all of .local; a tweak that works there
may therefore be absent from the final image.

Core-images currently points its submodule at
`https://github.com/kasmtech/KasmOS-KDE-Desktop`, branch develop, rather than the
internal GitLab repository. The gitlink pins the actual consumed revision.
Verify the intended commit is available from that remote before updating the
pin. Do not assume automatic mirroring or that a theme commit rebuilds KasmOS.

## Interactive workflow

With Docker and a matching KasmOS image, run from this repository root:

```sh
./tweak-theme kasmweb/kasmos:develop
```

Open `https://localhost:7901` with `kasm_user` / `password`. The harness builds
`kasmweb/kde-tweaks:local`, installs theme assets, removes template .config, and
mounts host kde-config/.config and .local into /home/kasm-user. GUI changes
modify this checkout. Use a known matching image tag for reproductions.
The current --pristine option is unreliable: it is also passed as BASE_IMAGE
without argument shifting.

Review git status and `git diff -- kde-config`; stage only intended defaults,
not incidental session state, local paths or personal data. make save-favorites
stages binary database files, so inspect its staged set and remember the image
COPY boundary. Avoid make clean: it discards changes and uses a nonstandard
`git co` alias.

## Troubleshooting and validation

- Missing wallpaper/icon/splash: check installer destination paths and installed
  Materia/Papirus assets in the target base.
- Drawer behavior/layout: inspect its QML/config and Plasma settings in .config;
  inspect desktop logs for widget errors.
- Defaults absent in old workspaces: compare fresh and persisted profiles.
- Tweaks disappear in the image: check gitlink and COPY paths first.
- Missing app/wrong launcher: check core-images baseapps rewrites and app-builder
  package pins; this repository does not compile applications.
- Blank desktop/screen lock: inspect core-images START_DE=kde5,
  startplasma-x11/VirtualGL startup and desktop_environment_policy.sh.

For shell changes:

```sh
bash -n tweak-theme
bash -n src/install-theme
bash -n src/inside-docker/kde-tweaks-startup
```

Use the harness for visual checks, then rebuild core-images with the intended
submodule revision and test a fresh profile: panel, drawer, favorites, wallpaper,
splash, GTK/Qt appearance and app launching. There is no .gitlab-ci.yml or
automated visual test suite in this checkout. Report unperformed checks.
