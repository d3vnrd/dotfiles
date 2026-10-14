local base = ...

---@class NvLib
---@field packadd fun(p: PackSpec)
local lib = {}

---@param desc string
lib.augroup = function(desc)
    return vim.api.nvim_create_augroup('user/' .. desc, { clear = true })
end

---@param keys string
---@param func string|function
---@param opts? string|vim.keymap.set.Opts
---@param mode? string|string[]
lib.bind = function(keys, func, opts, mode)
    if type(opts) == 'string' then
        opts = { desc = opts }
    end

    vim.keymap.set(mode or 'n', keys, func, opts)
end

lib.packadd = require(base .. '.packadd')

return lib
