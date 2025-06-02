{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    nodejs_24
    hyprland
    axel
    bc
    coreutils
    cliphist
    cmake
    curl
    rofi-wayland
    rsync
    wget
    ripgrep
    jq
    meson
    typescript
    nodePackages.tsun 
    gjs
    xdg-user-dirs
    brightnessctl
    ddcutil
    pavucontrol
    wireplumber
    libdbusmenu-gtk3
    kitty
    playerctl
    swww
    gobject-introspection
    glib # glib2 and glib2-devel
    gvfs
    glibc
    gtk3
    gtk-layer-shell
    libpulseaudio # libpulse
    gnome-bluetooth # gnome-bluetooth-3.0
    gammastep
    libsoup_3 # libsoup3
    libnotify
    networkmanager
    power-profiles-daemon
    upower
    adw-gtk3 # adw-gtk-theme-git
    adwaita-qt
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct # qt4ct
    libsForQt5.qt5.qtwayland #qt5-wayland
    fontconfig
    nerd-fonts.jetbrains-mono # ttf-jetbrains-mono-nerd
    material-design-icons # ttf-material-symbols-variable-git
    material-symbols # =^
    nerd-fonts.space-mono # ttf-space-mono-nerd
    rubik # ttf-rubik-vf
    bibata-cursors # bibata-cursor-theme
    bibata-cursors-translucent # bibata-cursor-translucent
    fish
    foot
    starship
    polkit_gnome
    gnome-keyring
    gnome-control-center
    blueberry
    webp-pixbuf-loader
    gtksourceview # gtksourceview3
    yad
    ydotool
    xdg-user-dirs-gtk
    tinyxml-2 # tinyxml2
    gtkmm3
    gtksourceviewmm4 # gtksourceviewmm
    cairomm
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    gradience
    pywalfox-native # python-pywalfox
    matugen
    swappy
    wf-recorder
    grim
    tesseract
    slurp
    dart-sass
    hypridle
    hyprutils
    hyprlock
    wlogout
    wl-clipboard
    hyprpicker
    ghostty
    noto-fonts-cjk-sans # ttf-noto-sans-cjk-vf
    noto-fonts-emoji-blob-bin # noto-fonts-emoji
    cava
    metar
    gowall
    go
    overskride
    mpv
    github-desktop # github-desktop-bin
    kdePackages.sddm
    ags_1

    (python313.withPackages (ps: with ps; [
      pywayland
      psutil
      setuptools-scm
      wheel
      pywal
      build
      pillow
      libsass
    ]))

    inputs.apple-fonts.packages.${pkgs.system}.sf-pro
    inputs.apple-fonts.packages.${pkgs.system}.sf-compact
    inputs.apple-fonts.packages.${pkgs.system}.sf-mono
    inputs.apple-fonts.packages.${pkgs.system}.sf-arabic
    inputs.apple-fonts.packages.${pkgs.system}.sf-armenian
    inputs.apple-fonts.packages.${pkgs.system}.sf-georgian
    inputs.apple-fonts.packages.${pkgs.system}.sf-hebrew
    inputs.apple-fonts.packages.${pkgs.system}.ny

    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    inputs.apple-fonts.packages.${pkgs.system}.sf-compact-nerd
    inputs.apple-fonts.packages.${pkgs.system}.sf-mono-nerd
    inputs.apple-fonts.packages.${pkgs.system}.sf-arabic-nerd
    inputs.apple-fonts.packages.${pkgs.system}.sf-armenian-nerd
    inputs.apple-fonts.packages.${pkgs.system}.sf-georgian-nerd
    inputs.apple-fonts.packages.${pkgs.system}.sf-hebrew-nerd
    inputs.apple-fonts.packages.${pkgs.system}.ny-nerd
  ];

  environment.sessionVariables = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib # C standard library and other compiler-related libs
      pkgs.libz             # zlib library
      pkgs.glibc
      pkgs.glib
    ];
  };
}
