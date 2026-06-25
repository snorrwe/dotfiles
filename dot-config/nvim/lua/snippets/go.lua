local ls = require("luasnip")
local util = require("snippets.utils")

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("go", {
    s(
        "iferr",
        fmt(
            [[if {} != nil {{
    return {}
}}
]],
            {
                i(1),
                util.same_as(1),
            }
        )
    ),
})
