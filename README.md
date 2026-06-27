# NixOS Config

My personal NixOS configuration.

## Fonts

This repo uses a mix of free and paid fonts:

### Free fonts (included)
- **Bengali** (`fonts/Bengali/`) — various Bengali fonts (Noto Sans Bengali, Anek Bangla, etc.)

### Paid fonts (private submodule)
- **TX-02** (`fonts/NixOS-Paid-Fonts/TX-02/`) — paid font, stored in a private repo
- **SF Pro Display** (`fonts/NixOS-Paid-Fonts/SF_Pro_Display/`) — proprietary Apple font

## Usage

On a new machine, clone with submodules:

```bash
git clone --recurse-submodules https://github.com/rumman02/NixOS-Config.git
```

If you already cloned without submodules:

```bash
git submodule update --init --recursive
```

**Note:** You need access to the private `NixOS-Paid-Fonts` repo. Authenticate via SSH key or `gh auth login` before running the submodule update.

Then build with your usual `nixos-rebuild` or `home-manager` command.
