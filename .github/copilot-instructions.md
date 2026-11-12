# Dotfiles Repository Instructions

## Source of truth

This repository is the single source of truth for the user's configuration files. The files in this checkout are linked from their normal macOS configuration locations, including the Neovim configuration at `nvim/init.lua`. Make configuration changes in this repository, not by editing the linked files at their target locations.

Before changing a configuration, inspect the relevant symlink or resolved path when necessary to confirm that it points to this repository. Do not replace, delete, or overwrite symlinks unless the user explicitly asks for symlink management.

## Repository layout

- `nvim/`: Neovim configuration.
- `vimrc/`: Vim configuration.
- `terminal MAC/`: macOS terminal configuration, including WezTerm, Starship, and the zsh startup file.
- `terminal WIN/`: Windows terminal configuration.
- `ps/`: PowerShell profile configuration.
- `vial/`: Vial keyboard backup files.

Keep platform-specific settings in the matching platform directory. Preserve existing file names and paths unless a migration is explicitly requested.

## Editing rules

- Prefer small, focused changes that preserve the user's existing configuration and style.
- Treat files in this repository as user-owned configuration; do not regenerate or replace them wholesale.
- Do not add machine-specific secrets, tokens, credentials, or generated state.
- Before changing behavior, inspect nearby configuration and any relevant existing mappings or settings.
- After editing, run the narrowest applicable validation available, such as a Neovim startup or config check for `nvim/init.lua`.
- Report validation failures clearly and do not silently modify unrelated configuration.
