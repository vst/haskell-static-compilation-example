# Repository for Example Haskell Application

Trying to reproduce issues with static compilation.

## Building

Nix build:

```sh
nix-build
```

Statically compiled build:

```sh
nix-build --arg doStatic true
```
