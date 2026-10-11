local o = vim.o
local g = vim.g

-- 'vim.opt' is very similar to `vim.o` but offers an interface for
-- conveniently interacting with tables.
--  See `:help lua-options` and `:help lua-guide-options`
local opt = vim.opt

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
g.mapleader = ' '
g.maplocalleader = ' '

-- Set to true if a Nerd Font is installed and selected in the terminal
g.have_nerd_font = NvOpts.have_nerd_font

--- Setting options ---
--  See `:help vim.o`
--  For more options, see `:help option-list`

-- Make line relative number default
o.number = true
o.relativenumber = true

-- Enable mouse mode in normal mode
o.mouse = 'n'

-- Change cursor to solid block and show which line it is on
o.cursorline = true
o.guicursor = ''

o.colorcolumn = '80'
o.showmode = false -- don't show mode already in status line
o.signcolumn = 'yes' -- keep signcolumn on by default
o.showtabline = 0
o.winborder = 'none' -- set default float border to none
o.wrap = false

-- Configure how new splits should be opened
o.splitright = true
o.splitbelow = true

-- Minimal number of screen lines to keep above-below cursor, and left-right the screen
o.scrolloff = 8
o.sidescrolloff = 8

-- Preview substitutions live, as typing!
o.inccommand = 'split'

-- Setting tabstop and indentation
o.tabstop = 4
o.shiftwidth = 0 -- 0 means "= tabstop"
o.softtabstop = -1 -- -1 means "= shiftwidth"
o.expandtab = true
o.breakindent = true

-- Limit number of items shows in popup menu and its transparency
o.pumheight = 10
o.pumblend = 10

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
o.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function()
    o.clipboard = 'unnamedplus'
end)

-- Disable swapfile and rely on undofile for backup
o.swapfile = false
o.undofile = true

-- Case-insensitive searching
--  UNLESS \C or one or more capital letters in the search term
o.ignorecase = true
o.smartcase = true

-- Decrease update time and mapped sequence wait time
o.updatetime = 250
o.timeoutlen = 300

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
o.confirm = true

-- Disable some builtin providers by neovim
for _, provider in ipairs {
    'python3_provider',
    'ruby_provider',
    'perl_provider',
    'node_provider',
} do
    g['loaded_' .. provider] = 0
end

for _, provider in ipairs {
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    'spellfile_plugin', -- auto download missing spell files
} do
    g['loaded_' .. provider] = 1
end

-- Identify big file and set custom `bigfile` type
vim.filetype.add {
    pattern = {
        ['.*'] = {
            function(path, buf)
                if not path or not buf or vim.bo[buf].buftype ~= '' or vim.bo[buf].filetype == 'bigfile' then
                    return nil
                end

                local big_size = 500 * 1024 -- 500kb
                local stat = vim.uv.fs_stat(path)

                if stat and stat.size > big_size then
                    return 'bigfile'
                end
            end,
        },
    },
}

-- Recommended diagnostic configs
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- can switch between these as you prefer
    virtual_text = true, -- text shows up at the end of the line
    virtual_lines = false, -- text shows up underneath the line, with virtual lines

    -- auto open the float, to easily read the errors when jumping with <[d> and <]d>
    jump = {
        on_jump = function(_, bufnr)
            vim.diagnostic.open_float {
                bufnr = bufnr,
                scope = 'cursor',
                focus = false,
            }
        end,
    },
}
