Lib.packadd {
    src = 'https://github.com/nvim-mini/mini.statusline',
    event = 'UIEnter',
    callback = function(p)
        p.setup {}
    end,
}
