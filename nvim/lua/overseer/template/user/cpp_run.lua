return {
  name = "clang++ run",
  builder = function()
    return {
      name = "clang++ run",
      cmd = { vim.fn.expand("%:p:r") },
      components = {
        { "dependencies", task_names = { "clang++ build" } },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
