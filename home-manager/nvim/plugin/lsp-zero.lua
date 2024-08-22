local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

local lspconfig = require('lspconfig')
lspconfig.html.setup({})
lspconfig.cssls.setup({})
lspconfig.lua_ls.setup({})
lspconfig.nixd.setup({})
lspconfig.gdscript.setup({})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
  mapping = cmp.mapping.preset.insert({
		['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
		["<C-l>"] = cmp.mapping.confirm({select = true}),
		["<C-Space>"] = cmp.mapping.complete(),
  }),
})
