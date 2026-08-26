require('nvport').setup {
    theme = 'vague',

    parsers = {
        'bash',
        'lua',
        'luadoc',
        'printf',
        'vim',
        'vimdoc',
        'nix',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'json',
        'typst',
        'svelte',
    },

    servers = {
        'lua_ls',
        'tinymist',
        'nil_ls',
        'bashls',
        'cssls',
        'markdown_oxide',
        'basedpyright',
        'dprint',
        'ts_ls',
        'svelte',
    },

    fmt_sources = {
        lua = { 'stylua' },
        nix = { 'alejandra' },
        python = { 'ruff' },
        markdown = { 'dprint' },
        html = { 'dprint' },
        css = { 'dprint' },
        javascript = { 'dprint' },
        typescript = { 'dprint' },
        yaml = { 'dprint' },
        typst = { 'typstyle', lsp_format = 'fallback' },
        sh = { 'shfmt', lsp_format = 'fallback' },
        svelte = { 'prettier' },
    },

    denpendencies_path = {
        tinymist = '/etc/profiles/per-user/tlmp59/bin/tinymist',
        websocat = '/etc/profiles/per-user/tlmp59/bin/websocat',
    },
}
