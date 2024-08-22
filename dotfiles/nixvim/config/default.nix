{self, ...}: {
  # Import all your configuration modules here
  imports = [./bufferline.nix];

  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    tabstop = 2;
  };

  colorschemes.kanagawa = {
    enable = true;
    settings.theme = "wave";
  };

  globals.mapleader = " ";
  keymaps = [
    {
      action = "<cmd>Telescope live_grep<CR>";
      key = "<leader>g";
    }
  ];

  plugins = {
    lualine.enable = true;
    telescope.enable = true;
    nvim-tree.enable = true;
    treesitter.enable = true;
    luasnip.enable = true;
  };

  plugins.lsp = {
    enable = true;
    servers = {
      html.enable = true;
    };
  };

  plugins.cmp = {
    enable = true;
    settings = {
      mapping = {
        __raw = ''
          cmp.mapping.preset.insert({
          	['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
          	['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
          	["<C-l>"] = cmp.mapping.confirm({select = true}),
          	["<C-Space>"] = cmp.mapping.complete(),
          	  })
        '';
      };
      sources = [
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "buffer";}
      ];
    };
  };
}
