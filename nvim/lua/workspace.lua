local M = {}

function M.open()
  -- Neo-tree left
  vim.cmd("silent! Neotree left reveal")
  vim.cmd("vertical resize 30")

  -- Right editor area
  vim.cmd("wincmd l")
  vim.cmd("vsplit")
  vim.cmd("wincmd h")
end

return M
