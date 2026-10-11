-- `:help lua-guide-autocommands`
-- NOTE: Ordered alphabetically by group name.
local auto = vim.api.nvim_create_autocmd

---@param desc string
local augroup = function(desc)
    return vim.api.nvim_create_augroup('user/' .. desc, { clear = true })
end

local M = {}

auto('FileType', {
    group = augroup 'big_file',
    desc = 'Disable features in big files',
    pattern = 'bigfile', -- custom filetype added in options.lua
    callback = function(args)
        vim.schedule(function()
            -- keep basic syntax highlight only
            vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or ''
        end)
    end,
})

-- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/autocmds.lua#L29
auto('FileType', {
    group = augroup 'close_with_q',
    desc = 'Close with <q>',
    pattern = {
        'git',
        'help',
        'man',
        'qf',
        'scratch',
        'grug-far',
    },
    callback = function(args)
        if args.match ~= 'help' or not vim.bo[args.buf].modifiable then
            vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
        end
    end,
})

auto('BufHidden', {
    group = augroup 'delete_no_name',
    desc = 'Delete [No Name] buffers',
    callback = function(args)
        if args.file == '' and vim.bo[args.buf].buftype == '' and not vim.bo[args.buf].modified then
            vim.schedule(function()
                pcall(vim.api.nvim_buf_delete, args.buf, {})
            end)
        end
    end,
})

auto('TextYankPost', {
    group = augroup 'highlight-yank',
    desc = 'Highlight when yanking (copying) text',
    callback = function()
        vim.hl.on_yank()
    end,
})

auto('BufReadPost', {
    group = augroup 'last_location',
    desc = 'Go to the last location when opening a buffer',
    callback = function(args)
        local buf = args.buf

        -- TODO: figuring out vim.b, vim.g, etc use to assign and access vars
        if vim.b[buf].restored_last_loc or vim.bo[buf].filetype == 'gitcommit' then
            return
        end
        vim.b[buf].restored_last_loc = true

        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local line_count = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

return M
