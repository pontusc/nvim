-- Plugin to jump quickly between files
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    ---@diagnostic disable-next-line: missing-parameter
    harpoon:setup()
    local function map(lhs, rhs, opts)
      vim.keymap.set('n', lhs, rhs, opts or {})
    end
    map('<leader>af', function()
      harpoon:list():add()
    end, { desc = 'Add file to harpoon list' })
    map('<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[S]how harpoon [F]iles' })
    map('<leader>1', function()
      harpoon:list():select(1)
    end, { desc = '[G]o to harpoon [1]' })
    map('<leader>2', function()
      harpoon:list():select(2)
    end)
    map('<leader>3', function()
      harpoon:list():select(3)
    end)
    map('<leader>4', function()
      harpoon:list():select(4)
    end)
  end,
}
