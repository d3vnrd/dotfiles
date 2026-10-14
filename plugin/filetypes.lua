Lib.packadd {
    src = 'https://github.com/chomosuke/typst-preview.nvim',
    event = 'FileType',
    pattern = 'typst',
    callback = function(plugin)
        plugin.setup { port = 8000 }
    end,
}
