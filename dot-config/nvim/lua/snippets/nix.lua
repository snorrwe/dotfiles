local ls = require("luasnip")

local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("nix", {
	s(
		"flake",
		fmt(
			[[
{{
  description = "devshell";

  inputs = {{
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  }};

  outputs = {{ nixpkgs, flake-utils, ... }}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [];
        pkgs = import nixpkgs {{
          inherit system overlays;
        }};
      in
      with pkgs;
      {{
        devShells.default = mkShell {{
          buildInputs = [
          ];
        }};
      }}
    );
}}
]],
			{}
		)
	),
})
