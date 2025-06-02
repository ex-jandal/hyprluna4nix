{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    package = pkgs.fish;
  };

  home.file = {
    ".config/fish" = {
      source = "./dot-files/config/fish";
      force = true;
      mutable = true;
    };
  };
}
