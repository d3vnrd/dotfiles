local auto = vim.api.nvim_create_autocmd
local key = vim.keymap.set

auto('FileType', {
    once = true,
    pattern = 'typst',
    callback = function()
        vim.pack.add { 'https://github.com/chomosuke/typst-preview.nvim' }

        require('typst-preview').setup {
            port = 8000,
            dependencies_bin = {
                ['tinymist'] = vimrc.denpendencies_path.tinymist or nil,
                ['websocat'] = vimrc.denpendencies_path.websocat or nil,
            },
        }

        key('n', '<leader>dp', ':TypstPreview<CR>', { buffer = 0, desc = 'Typst Preview' })

        vim.wo.wrap = true
        vim.wo.spell = true
        vim.bo.wrapmargin = 0
        -- vim.opt_local.formatoptions:append 't'
    end,
})

auto('FileType', {
    once = true,
    pattern = 'markdown',
    callback = function()
        vim.pack.add {
            'https://github.com/obsidian-nvim/obsidian.nvim',
            'https://github.com/jmbuhr/otter.nvim',
        }

        require('otter').setup {}
        require('obsidian').setup {
            legacy_commands = false,
            workspaces = {
                {
                    name = 'notes',
                    path = '~/notes/content/',
                },
            },
            picker = { name = 'mini.pick' },
            frontmatter = { enabled = false },
            ui = {
                enabled = false,
                ignore_conceal_warn = true,
            },
            footer = { enabled = false },
        }

        key('n', '<leader>fo', ':Obsidian ', { buffer = 0, desc = 'Obsidian command' })

        vim.wo.wrap = true
        vim.wo.spell = true
    end,
})
