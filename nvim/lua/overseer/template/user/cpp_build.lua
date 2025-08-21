return {
  name = "clang++ build",
  builder = function()
    return {
      cmd = { "clang++" },
      args = {
        vim.fn.expand("%:p"),
        "-o",
        vim.fn.expand("%:t:r"),
      },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
