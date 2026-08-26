vim.pack.add({
    'https://github.com/echasnovski/mini.pick',
    'https://github.com/echasnovski/mini.extra',
    'https://github.com/echasnovski/mini.bufremove',
    'https://github.com/magicduck/grug-far.nvim',
}, { confirm = false })

require('mini.extra').setup()
require('mini.pick').setup {
    window = {
        config = {
            width = vim.api.nvim_win_get_width(0),
            height = 10,
            border = { '', '─', '', '', '', '', '', '' },
        },
    },
}
require('grug-far').setup()

require('nvport').setkeys {
    { 'n', '<leader>ff', '<cmd>Pick files<cr>', { desc = 'Pick a file' } },
    { 'n', '<leader><leader>', '<cmd>Pick buffers<cr>', { desc = 'Navigate between buffers' } },
    { 'n', '<leader>fc', '<cmd>Pick commands<cr>', { desc = 'Search for available commands' } },
    { 'n', '<leader>fG', '<cmd>Pick grep<cr>', { desc = 'Grep for words' } },
    { 'n', '<leader>fg', '<cmd>Pick grep_live<cr>', { desc = 'Live grep for words' } },
    { 'n', '<leader>fh', '<cmd>Pick help<cr>', { desc = 'Search in help pages' } },
    { 'n', '<leader>fs', '<cmd>GrugFar<cr>', { desc = 'Search and replace' } },
}
