vim.api.nvim_create_autocmd('InsertEnter', {
    once = true,
    callback = function()
        vim.pack.add({
            'https://github.com/saghen/blink.cmp',
            'https://github.com/echasnovski/mini.snippets',
            'https://github.com/rafamadriz/friendly-snippets',
        }, { confirm = false })

        local snippet = require 'mini.snippets'
        snippet.setup {
            snippets = { snippet.gen_loader.from_lang() },
        }

        require('blink.cmp').setup {
            snippets = { preset = 'mini_snippets' },
            cmdline = { enabled = false },
            signature = { enabled = true },
            completion = {
                menu = { auto_show = true },
                ghost_text = { enabled = false },
            },
            sources = {
                -- default = { 'lsp', 'path', 'snippets', 'buffer' },
                default = function()
                    -- Disable some sources in comments and strings.
                    -- source: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/blink.lua
                    local sources = { 'lsp', 'buffer' }
                    local ok, node = pcall(vim.treesitter.get_node)

                    if ok and node then
                        if not vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                            table.insert(sources, 'path')
                        end
                        if node:type() ~= 'string' then
                            table.insert(sources, 'snippets')
                        end
                    end

                    return sources
                end,
                providers = {},
                per_filetype = {},
            },
            fuzzy = { implementation = 'lua' },
        }
    end,
})
