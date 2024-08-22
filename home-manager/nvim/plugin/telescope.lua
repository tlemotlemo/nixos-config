local telBuilt = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telBuilt.find_files, {})
vim.keymap.set('n', '<leader>fg', telBuilt.live_grep, {})
vim.keymap.set('n', '<leader>fb', telBuilt.buffers, {})
vim.keymap.set('n', '<leader>fh', telBuilt.help_tags, {})

