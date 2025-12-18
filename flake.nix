{
  description = "Dotfiles flake";

  outputs = { self, nixpkgs, ... }: {
    packages.x86_64-linux.default = {};
  };
}
