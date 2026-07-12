local ls = require("luasnip")
local util = require("snippets.utils")

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

local js = {
    s(
        "logvar",
        fmt([[console.log("{}:", {})]], {
            i(1),
            util.same_as(1),
        })
    ),
}

local svelte = util.concat(js, {
    s(
        "predbg",
        fmt(
            [[<pre>
===={}====
    {{JSON.stringify({}, null, 4)}}
</pre>]],
            { i(1), util.same_as(1) }
        )
    ),
})

ls.add_snippets("javascript", js)
ls.add_snippets("typescript", js)
ls.add_snippets("svelte", svelte)
