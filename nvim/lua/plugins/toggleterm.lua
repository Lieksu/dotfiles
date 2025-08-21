return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 15, -- height of terminal
      open_mapping = [[<c-\>]], -- toggle with Ctrl-\
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true, -- start in insert mode
      insert_mappings = true, -- allow terminal insert mappings
      persist_size = true,
      direction = "horizontal", -- bottom terminal, full width
      close_on_exit = false,
      shell = vim.o.shell, -- uses fish automatically
    })
  end,
}
