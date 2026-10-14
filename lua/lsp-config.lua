local autocmd = vim.api.nvim_create_autocmd

-- Recommended diagnostic configs
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'none', source = 'if_many' },
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

autocmd('LspAttach', {
    desc = 'Enable set features on LSP attached',
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local augroup = Lib.augroup

        local bind = function(keys, func, desc, mode)
            Lib.bind(keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc }, mode)
        end

        -- custom keymaps for errors navigation
        bind('[e', function()
            vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
        end, 'Previous error')
        bind(']e', function()
            vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
        end, 'Next error')

        -- 'if' supported features
        if client then
            if client:supports_method('textDocument/documentHighlight', args.buf) then
                local highlight_augroup = augroup 'lsp-highlight'

                autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    desc = 'Highlight word references under cursor',
                    group = highlight_augroup,
                    buffer = args.buf,
                    callback = vim.lsp.buf.document_highlight,
                })

                autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    desc = 'Clear highlighted references on cursor move',
                    group = highlight_augroup,
                    buffer = args.buf,
                    callback = vim.lsp.buf.clear_references,
                })

                autocmd('LspDetach', {
                    desc = 'Clear highlighted references and autocmds on LSP detach',
                    group = augroup 'lsp-detach',
                    callback = function(_args)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds { group = 'user/lsp-highlight', buffer = _args.buf }
                    end,
                })
            end

            if client:supports_method('textDocument/inlayHint', args.buf) then
                vim.api.nvim_create_user_command('ToggleInlayHints', function()
                    local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = args.buf }
                    vim.lsp.inlay_hint.enable(not enabled)

                    vim.notify(string.format('%s inlay-hints', enabled and 'Disable' or 'Enable'), vim.log.levels.INFO)
                end, { desc = 'Toggle inlay hints using cmd :ToggleInlayHints', nargs = 0 })
            end
        end
    end,
})

autocmd({ 'BufReadPre', 'BufNewFile' }, {
    desc = 'On events enable LSP servers',
    once = true,
    callback = function()
        local servers = vim.iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
            :map(function(file)
                return vim.fn.fnamemodify(file, ':t:r')
            end)
            :totable()

        vim.lsp.enable(servers)
    end,
})
