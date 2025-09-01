return {
  name = "python3 run",
  builder = function()
    return {
      cmd = { "python3" },
      args = {
        vim.fn.expand("%:p"),
      },
    }
  end,
  condition = {
    filetype = { "python" },
  },
}
