-- TODO: add support for dependencies for async installation

---@class PackSpec : vim.pack.Spec
---@field event? vim.api.keyset.events|vim.api.keyset.events[]
---@field pattern? string|string[]
---@field callback? fun(mod: table|boolean)
---@field confirm? boolean

---@param p PackSpec
return function(p)
    vim.pack.add({ { src = p.src, name = p.name, version = p.version } }, {
        confirm = p.confirm or false, -- skip confirmation by default
        load = function(data)
            local setup = function()
                vim.cmd.packadd(data.spec.name)

                if not p.callback then
                    return
                end

                local requirable, mod = pcall(require, data.spec.name)
                local ok, err = pcall(p.callback, requirable and mod or {})
                if not ok then
                    vim.notify(err, vim.log.levels.ERROR)
                end
            end

            if p.event then
                vim.api.nvim_create_autocmd(p.event, {
                    pattern = p.pattern,
                    once = true,
                    callback = setup,
                })
            else
                setup()
            end
        end,
    })
end
