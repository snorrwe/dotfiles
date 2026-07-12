local M = {}

M.same_as = function(idx)
    local ls = require("luasnip")
    local f = ls.function_node
    return f(function(args)
        return args[1]
    end, { idx })
end

M.concat = function(...)
    local result = {}
    for _, tbl in ipairs({ ... }) do
        for k, v in pairs(tbl) do
            if type(k) ~= "number" then
                result[k] = v
            else
                table.insert(result, v)
            end
        end
    end
    return result
end

return M
