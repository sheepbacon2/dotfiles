# Wes's dotfiles

Arch Linux + i3 configuration shared across desktop and laptop. Requires Git and
Python 3. `shared/` contains common files; `profiles/desktop/` and
`profiles/laptop/` contain machine-specific files. Profile files take precedence.
The old top-level alacritty, forest, i3, nvim, picom and config files are historical
copies; the installer only uses shared/ and profiles/.

## Install on the laptop

```sh
git clone https://github.com/sheepbacon2/dotfiles.git ~/dotfiles
cd ~/dotfiles
./dotfiles install laptop           # preview only
./dotfiles install laptop --apply   # back up existing files, then symlink
```

If ~/dotfiles already exists, inspect it before cloning or installing; do not
replace an existing checkout blindly. On the desktop use `desktop` instead.
Keep the repository at its installed location: the links point into it.

Before reloading i3 on the laptop, run `xrandr --query` and edit
`~/.config/i3/outputs.conf` to use its actual display name (the initial default is
eDP-1). Both workspace groups initially use that panel. Configure an external
monitor by changing `$sm`. Review startup.conf, hardware.conf, .xinitrc, dunst,
rofi DPI and picom in the laptop profile. The laptop starts with 1x X11 scaling
and 96 DPI in rofi; tune these for its display.

Existing files are backed up under ~/dotfiles-backups/TIMESTAMP, preserving their
relative paths. Unmanaged files are left in place. No session restart or package
installation is automatic. The desktop wallpaper, workspace layout snapshots,
and ~/my-environment.sh remain local; keep those on the desktop as needed.

## Daily workflow

Edit the usual files, such as ~/.bashrc or ~/.config/i3/keybinds.conf. They are
symlinks into this repository, so Git sees the edits immediately. Editors that
replace a symlink with a regular file need to be configured to follow symlinks;
otherwise edit the repository source directly.

```sh
dotfiles status
dotfiles diff
dotfiles save "Adjust terminal colors"  # review confirmation, commit, push
```

Open a new shell after installation to put `dotfiles` on PATH, or invoke
`~/dotfiles/dotfiles` directly. Configure your Git identity on each machine:

```sh
git config --global user.name "Your name"
git config --global user.email "Your GitHub email or noreply address"
```

On the other computer:

```sh
dotfiles update
```

This requires a clean checkout, pulls with --ff-only, and installs links for new
files with backups. Existing linked files change as soon as Git updates them.
Open a new shell and reload i3 with Mod+Shift+c when ready. Nothing polls GitHub
or updates on a timer. GitHub authentication must be configured separately;
credentials are never stored here. If a push fails, the local commit remains;
retry with `dotfiles push`.

Pull before editing on each computer when possible. If both computers made
commits, fast-forward stops safely. Commit your work, then use `git fetch origin`
and `git merge origin/main`, resolve any conflicts, and push. The helper never
force-pushes, resets, or stashes your edits. Review untracked files separately:
`git diff` does not display their contents. `save` stages the managed directories,
helper, README and .gitignore, plus commits any changes you already staged.

## Keeping laptop differences

Shared edits affect both computers. Profile edits affect only that profile.
To give the laptop its own version of a shared file, copy it from shared/ into
profiles/laptop/ at the same relative path, edit it, then run install laptop
--apply again. Each profile is a complete file override, not a line-by-line merge.
For aliases and secrets that should never be committed, use ~/.bashrc.local;
~/my-environment.sh is also sourced only if present. Do not copy credentials,
SSH keys, shell histories, application databases, or entire ~/.config trees here.

To merge previous laptop preferences, compare the backed-up file against the
installed one (`diff -u BACKUP_PATH ~/.bashrc`, for example), and move the desired
settings into either the shared file or laptop profile. Backups are local only.

Removing a tracked source file does not automatically remove its installed
symlink; remove that obsolete symlink manually. Switching profiles on the same
machine likewise requires reviewing profile-exclusive files.

## Dependencies and optional features

Install the programs you use with your normal Arch package workflow. Configured
features reference i3, i3blocks, Alacritty, Neovim, tmux, rofi, dunst, picom,
PipeWire/pactl, lm-sensors, jq, xdotool, xclip, feh, dex, nm-applet, xss-lock,
i3lock, xsettingsd, and JetBrainsMono Nerd Font. Desktop startup additionally
references personal applications such as Steam and Lutris. These are not
installed by this repository. The NVIDIA monitor toggle is desktop-only.
Neovim indentation guides activate if `ibl` is installed; plugins are not
automatically downloaded. Existing third-party script notices are retained.

## Restore a backup

Inspect the timestamp directory first. For each file you want to restore, remove
its installed symlink and copy the backup to the same relative location under
HOME. Do not recursively copy over live symlinks, which could modify repository
files. The pre-migration repository is also saved locally under
~/dotfiles-backups/20261112-103054/repository-before-migration, and its uncommitted
changes are preserved in the named pre-migration Git stash.

## Personal scripts

Scripts from `~/.local/bin` are saved in `shared/.local/bin`; NVIDIA monitor
scripts and their layouts are in `profiles/desktop/.local/bin`. Executable
permissions are preserved. The installer links these files on the selected
profile; importing them does not replace existing local files. Until installed,
copy edits from those local files back into the repository before saving.

The third-party `ahk_x11.AppImage`, Python runtime symlink, `.idea` metadata,
and obsolete `mousepos.sh` link are excluded. Scripts retain their current
behavior and personal paths; review those paths before using another machine.
`i3-session` requires its existing virtual environment and i3-resurrect setup.
