Lib.packadd {
    src = 'https://github.com/Saghen/blink.cmp',
    version = vim.version.range '1.*', -- v2 is under active development
    callback = function(blink)
        -- Snippets engine
        Lib.packadd {
            src = 'https://github.com/L3MON4D3/LuaSnip',
            name = 'luasnip',
            version = vim.version.range '2.*',
            callback = function(luasnip)
                luasnip.setup {}

                -- Pre-made snippets pack
                Lib.packadd {
                    src = 'https://github.com/rafamadriz/friendly-snippets',
                    callback = function()
                        require('luasnip.loaders.from_vscode').lazy_load()
                    end,
                }
            end,
        }

        blink.setup {
            appearance = { nerd_font_variant = vim.g.nerd_font_variant or 'normal' },

            -- Disable command line completion
            cmdline = { enabled = false },

            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 1000 },
            },

            -- 'default' (recommended) for mappings similar to built-in completions
            keymap = { preset = 'default' },

            sources = { default = { 'lsp', 'path', 'snippets' } },
            snippets = { preset = 'luasnip' },

            -- By default, use the Lua implementation
            --  See `:help blink-cmp-config-fuzzy` for more information
            fuzzy = { implementation = 'lua' },

            -- Shows a signature help window while typing arguments for a function
            signature = { enabled = true },
        }
    end,
}
