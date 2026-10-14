Lib.packadd {
    src = 'https://github.com/nvim-mini/mini.pick',
    callback = function(pick)
        pick.setup {
            window = {
                config = {
                    width = vim.api.nvim_win_get_width(0),
                    height = 10,
                    border = { '', '─', '', '', '', '', '', '' },
                },
            },
        }

        Lib.bind('<leader>fb', pick.builtin.buffers, 'Find opened buffers')
        Lib.bind('<leader>ff', pick.builtin.files, 'Find files')
        Lib.bind('<leader>fg', pick.builtin.grep_live, 'Live grep for words')
        Lib.bind('<leader>fh', pick.builtin.help, 'Find help pages')

        -- Extra dependencies
        Lib.packadd {
            src = 'https://github.com/nvim-mini/mini.extra',
            callback = function(extra)
                extra.setup {}

                Lib.bind('<leader>fc', extra.pickers.commands, 'Find available commands')
                Lib.bind('<leader>fe', extra.pickers.explorer, 'Explore current directory and open file')
                Lib.bind('<leader><leader>', extra.pickers.resume, 'Resume previous picker')
            end,
        }
    end,
}
