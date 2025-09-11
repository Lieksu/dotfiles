return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.snippets = {
        expand = function(snippet, _)
          return LazyVim.cmp.expand(snippet)
        end,
      }
      opts.keymap = { preset = "default" }
      opts.appearance = {
        nerd_font_variant = "mono",
      }
      opts.completion = { documentation = { auto_show = false } }
      opts.sources = {
        compat = {},
        default = { "lsp", "path", "snippets" },
      }
      opts.fuzzy = { implementation = "prefer_rust_with_warning" }
      opts.cmdline = {
        enabled = false,
      }
      return opts
    end,
  },
}
