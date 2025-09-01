local function open_and_close()
  local overseer = require("overseer")

  -- Open the task window.
  overseer.open({ enter = false })

  -- Close it after 10 seconds (if not inside the window).
  vim.defer_fn(function()
    if vim.bo.filetype ~= "OverseerList" then
      overseer.close()
    end
  end, 10 * 1000)
end

return {
  "stevearc/overseer.nvim",
  opts = {
    templates = { "builtin", "user.cpp_build", "user.cpp_run", "user.python_run" },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    -- Keep a reference to the original selector (could be dressing.nvim, telescope-ui-select, fzf-lua, etc.)
    local original_select = vim.ui.select

    -- Try to load fzf-lua, but don't require it.
    local has_fzf, fzf_lua = pcall(require, "fzf-lua")

    -- Wrap vim.ui.select so ONLY Overseer template pickers are customized.
    vim.ui.select = function(items, sel_opts, on_choice)
      -- Detect Overseer template lists: items are tables with a .name and either .builder/.desc/.condition
      local is_overseer_templates = type(items) == "table"
        and #items > 0
        and type(items[1]) == "table"
        and items[1].name ~= nil
        and (items[1].builder ~= nil or items[1].desc ~= nil or items[1].condition ~= nil)

      if not is_overseer_templates then
        -- Not Overseer: delegate to the original selector unchanged
        return original_select(items, sel_opts, on_choice)
      end

      -- Build label list (ONLY the task name)
      local labels, index_by_label = {}, {}
      for i, item in ipairs(items) do
        local label = item.name or tostring(item)
        labels[i] = label
        -- If names are duplicated, last wins; practically fine for Overseer templates
        index_by_label[label] = i
      end

      if has_fzf and fzf_lua and fzf_lua.fzf_exec then
        -- Use fzf-lua when available
        return fzf_lua.fzf_exec(labels, {
          prompt = (sel_opts and sel_opts.prompt) or "Select task> ",
          actions = {
            ["default"] = function(selected)
              if not selected or not selected[1] then
                return on_choice(nil, nil)
              end
              local idx = index_by_label[selected[1]]
              on_choice(items[idx], idx)
            end,
          },
        })
      else
        -- Fallback to original selector, forcing it to display only the name
        local new_opts = vim.tbl_extend("force", sel_opts or {}, {
          format_item = function(item)
            return (type(item) == "table" and item.name) and item.name or tostring(item)
          end,
        })
        return original_select(items, new_opts, on_choice)
      end
    end
  end,
  keys = {
    {
      "<leader>ot",
      "<cmd>OverseerToggle<cr>",
      desc = "Toggle task window",
    },
    {
      "<leader>o<",
      function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
          open_and_close()
        end
      end,
      desc = "Restart last task",
    },
    {
      "<leader>or",
      function()
        require("overseer").run_template({}, function(task)
          if task then
            open_and_close()
          end
        end)
      end,
      desc = "Run task",
    },
  },
}
