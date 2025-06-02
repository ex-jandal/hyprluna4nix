{ pkgs, inputs, config, lib, ...}:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ./sddm-themes/tokyo-night-sddm.nix { };
in 
{
  environment.systemPackages = [ tokyo-night-sddm ];

  imports = [
    ./requiered-packages.nix
    ./xdg.nix
  ];

  services.displayManager.sddm = {
    enable = true;
    # Thank you r/SeeYaNater from reddit
    theme = "tokyo-night-sddm";
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "adwaita-dark";
  };

  qt5 = {
    enable = true;
    platformTheme = "qt5ct";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  # xdg.configFile = {
  #   "Kventum/"
  # };

  # i18n.inputMethod.enableGtk3 = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.package.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.package.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  hardware.graphics = {
    package = pkgs.mesa;
    enable32Bit = true;
    package32 = pkgs.pkgsi686Linux.mesa;
  };

  fonts.fontDir.enable = true;

  programs.npm.enable = true;
}
