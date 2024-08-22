{
  config,
  pkgs,
  inputs,
  unstable-pkgs,
  ...
}: let
  nixvim = import (pkgs.fetchgit {
    url = "https://github.com/nix-community/nixvim";
  });
in {
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.opentabletdriver.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true; # required
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.jack = {
    # support ALSA only programs via ALSA JACK PCM plugin
    alsa.enable = false;
    # support ALSA only programs via loopback device (supports programs like Steam)
    loopback = {
      enable = true;
      # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
      #dmixConfig = ''
      #  period_size 2048
      #'';
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Add NTFS support
  boot.supportedFilesystems = ["ntfs"];

  # enable a few services to automount hard drives
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # make Via work with NixOS
  services.udev.packages = [pkgs.via];

  # some things needed to make plymouth work right
  boot.initrd.systemd.enable = true;
  boot.kernelParams = ["quiet"];

  # bash stuff
  programs.bash.blesh.enable = true;
  services.atuin.enable = true;

  # enable plymouth for bootscreen
  boot.plymouth = {
    enable = true;
    theme = "cuts";
    themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["cuts"];})];
  };

  # enable FLAKES
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # LD fix-- let me install external packages! (tip courtesy of No Boilerplate)
  programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; {
  # Libraries for unpackaged programs go here!
  # }

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enables X11 and Xfce without its window manager
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager.defaultSession = "xfce";
  };

  # Enable the KDE 6 Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Instead enable uhh Dwm for the ricing
  # services.xserver.windowManager.dwm.enable = true;

  # services.xserver.windowManager.dwm.package = pkgs.dwm.override {
  #   patches = [
  #     (pkgs.fetchpatch {
  #       url = "https://dwm.suckless.org/patches/uselessgap/dwm-uselessgap-20211119-58414bee958f2.diff";
  #       hash = "sha256-cWDTOtKZXCSFpZuDfKeXb8jA9UMZ28mowlRvMA8G+us=";
  #     })
  #     (pkgs.fetchpatch {
  #       url = "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff";
  #       hash = "sha256-mrHh4o9KBZDp2ReSeKodWkCz5ahCLuE6Al3NR2r2OJg=";
  #     })
  #     (pkgs.fetchpatch {
  #       url = "https://dwm.suckless.org/patches/alwayscenter/dwm-alwayscenter-20200625-f04cac6.diff";
  #       hash = "sha256-xQEwrNphaLOkhX3ER09sRPB3EEvxC73oNWMVkqo4iSY=";
  #     })
  #   ];
  # };

  # This enables i3wm along with any packages for it
  environment.pathsToLink = ["/libexec"];
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;
    extraPackages = with pkgs; [
      rofi
      i3status
      i3lock
      i3blocks-gaps
      i3-auto-layout
      yabar
      # end of i3 pkgs
    ];
  };
  programs.xss-lock.enable = true; # enables xss-lock for 13wm

  # Enable the QTile tiling window manager
  # services.xserver.windowManager.qtile = {
  #   enable = true;
  #   configFile = /home/user/.config/qtile/config.py;
  #   extraPackages = python3Packages:
  #     with python3Packages; [
  #       qtile-extras
  #       # end of qtile packages
  #     ];
  # };

  # enable Hyprland, the wayland tiling wm
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };

  # enable Ragnar, an X11 tiling wm
  # services.xserver.windowManager.ragnarwm = {
  #   enable = true;
  # };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Install picom.
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = ["networkmanager" "wheel" "jackaudio"];
    packages = with pkgs; [
      firefox
      kate
      vim
      #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "user";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["user"];
  services.input-remapper.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;

  fonts.packages = with pkgs; [
    vollkorn
    inter
    monocraft
    national-park-typeface
    hyperscrypt-font
    gentium
    shrikhand
    fraunces
    orbitron
    the-neue-black
    comic-mono
    comic-relief
    julia-mono
    dotcolon-fonts
    spleen
    recursive
    courier-prime
    creep
    manrope
    tt2020
    monaspace
    font-awesome
    roboto
    open-sans
    sudo-font
    noto-fonts
    profont
    # end of font packages
  ];

  environment.systemPackages = with pkgs; [
    #  wget
    xclip
    git
    discord
    webcord
    krita
    inkscape-with-extensions
    (blender.override {
      cudaSupport = true;
    })
    (prismlauncher.override {
      jdks = [
        temurin-bin-21
        temurin-bin-8
        temurin-bin-17
      ];
    })
    obsidian
    clinfo
    qzdl
    atuin
    gnumake
    variety
    libgcc
    davinci-resolve
    libsForQt5.kcharselect
    partition-manager
    jellyfin-ffmpeg
    yt-dlp
    cachix
    ardour
    openrazer-daemon
    polychromatic
    input-remapper
    spotify-player
    spotify
    geonkick
    airwindows-lv2
    st
    dwmbar
    p7zip
    gparted
    emojipick
    dwmbar
    xcolor
    font-manager
    exfat
    aseprite
    zulu17
    htop-vim
    thiefmd
    pkgs.xfce.xfce4-settings
    appimage-run
    lbry
    shutter
    pkgs.xorg.xev
    colorz
    xmcp
    rofimoji
    epick
    xsel
    mpv
    pkgs.libsForQt5.kdenlive
    movit # gpu rendering for kdenlive
    glaxnimate # required for kdenlive
    pkgs.cudaPackages.cudatoolkit
    hackneyed # cursor
    skeu
    onestepback
    themechanger
    gimp
    fontforge-gtk
    birdfont
    lorien
    # rofi-wayland-unwrapped
    kitty
    nwg-look
    swaynotificationcenter
    xdg-desktop-portal-hyprland
    polkit-kde-agent
    # hyprpaper
    copyq
    # dolphin
    # wl-clipboard
    qownnotes
    nvidia-vaapi-driver
    lm_sensors
    rofi-power-menu
    openrgb-plugin-effects
    openal
    jan
    zulu
    eza
    bat
    fzf
    powerline
    lxappearance
    alejandra
    temurin-bin
    jdk
    alchemy
    sxiv
    wpgtk
    themix-gui
    nightfox-gtk-theme
    khal
    wayst
    gtk-engine-murrine
    feh
    xsettingsd
    tldr
    shattered-pixel-dungeon
    rat-king-adventure
    piper
    libratbag
    solaar
    pzip
    obs-studio
    calf
    helvum
    easyeffects
    raysession
    qpwgraph
    olive-editor
    libreoffice-still-unwrapped
    samplebrain
    via
    viewnior
    ripgrep
    gccgo
    tree-sitter
    vscode-langservers-extracted
    lua-language-server
    nixd
    qutebrowser
    blockbench
    vieb
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))
    dunst
    libnotify
    xwallpaper
    rofi-wayland
    vesktop
    networkmanagerapplet
    pcmanfm
    home-manager
    unstable-pkgs.godot_4
    # end of packages
  ];

  programs.steam.enable = true;
  _module.args.unstable-pkgs = import <nixos-unstable> {};

  # enable nixvim?
  # imports = [nixvim];

  # programs.nixvim = {
  #   enable = true;
  # };

  # enable dconf for wpgtk
  programs.dconf.enable = true;

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
