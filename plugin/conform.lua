Lib.packadd {
    src = 'https://github.com/stevearc/conform.nvim',
    name = 'conform',
    event = 'BufWritePre',
    callback = function(plugin)
        plugin.setup {
            notify_on_error = false,
            notify_no_formatters = false,

            default_format_opts = {
                -- Use external formatters if configured below, otherwise use LSP formatting.
                --  Set to `false` to disable LSP formatting entirely.
                lsp_format = 'fallback',
            },

            format_on_save = function(bufnr)
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                end

                if not vim.g.autoformat then
                    return nil
                end

                return { timeout_ms = 500 }
            end,

            -- TODO: adjust this list to reflect how i would use
            formatters_by_ft = {
                lua = { 'stylua' },
                nix = { 'alejandra' },
                python = { 'ruff' },
                markdown = { 'dprint' },
                html = { 'dprint' },
                css = { 'dprint' },
                javascript = { 'dprint' },
                typescript = { 'dprint' },
                yaml = { 'dprint' },
                typst = { 'typstyle' },
                sh = { 'shfmt' },
                -- For filetypes without a formatter:
                ['_'] = { 'trim_whitespace', 'trim_newlines' },
            },
        }

        -- Start auto-formatting by default (disable with user ToggleFormat command)
        vim.g.autoformat = true

        Lib.bind('<leader>fm', function()
            plugin.format { async = true }
        end, 'Format current buffer')
    end,
}
