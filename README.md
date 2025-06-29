# My Nixos Config

# Install

1. Get git
2. Copy system folder files to `/etc/nixos`
3. Change to unstable and get latest home-manager

```
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update
```

4. run `sudo nixos-rebuild boot --upgrade`
5. Restart system

# TODO

- Flake it
- Better theme for SDDM
