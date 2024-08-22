{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "user";
  home.homeDirectory = "/home/user";
  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    blesh
    syncthing
    syncthingtray
    libsForQt5.plasma-browser-integration
    lmms
    winetricks
    wineWowPackages.waylandFull
    wget
    github-desktop
    surge-XT
    yoshimi
    helm
    sticky
    paprefs
    pavucontrol
    yabridge
    yabridgectl
    lsp-plugins
    distrho
    ranger
    fzf
    neofetch
    schismtracker
    tenacity
    dmenu
    milkytracker
    xfe
    galculator
    xpad
    drumkv1
    samplv1
    neovide
    (polybarFull.override {
      pulseSupport = true;
    })
    jetbrains-mono
    graphicsmagick
    flameshot
    # end of packages
  ];

  fonts.fontconfig.enable = true;

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    defaultEditor = true;

    extraLuaConfig = builtins.readFile ./nvim/options.lua;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }

      which-key-nvim

      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/plugin/telescope.lua;
      }
      telescope-fzf-native-nvim

      # {
      #   plugin = harpoon;
      #   type = "lua";
      #   config = builtins.readFile ./nvim/plugin/harpoon.lua;
      # }
      {
        plugin = undotree;
        type = "lua";
        config = builtins.readFile ./nvim/plugin/undotree.lua;
      }

      nvim-cmp
      nvim-lspconfig
      cmp-nvim-lsp

      {
        plugin = lsp-zero-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/plugin/lsp-zero.lua;
      }

      luasnip
      cmp_luasnip
      friendly-snippets

      lualine-nvim

      {
        plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json
          p.tree-sitter-gdscript
          p.tree-sitter-godot_resource
          p.tree-sitter-gdshader
        ]);
        type = "lua";
        config = "require(\"autoclose\").setup{ indent = {enable = false },}";
      }

      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = builtins.readFile ./nvim/plugin/nvim-tree.lua;
      }

      nvim-web-devicons

      comment-nvim
      vim-nix
      {
        plugin = autoclose-nvim;
        type = "lua";
        config = "require(\"autoclose\").setup()";
      }
      # end of neovim packages
    ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/user/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
