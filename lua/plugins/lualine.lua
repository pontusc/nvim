return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Fixed-width tab indicator pinned to the far right (replaces the clock):
    -- always renders 4 slots " 1 | 2 | 3 | 4 " so its position never shifts.
    -- The whole element is filled with lualine's mode accent (matching the
    -- NORMAL block and following the mode colour). The current tab is an
    -- inverted cut-out, open-but-inactive tabs use the normal block fg, and
    -- unopened slots / separators are dimmed. Colours are derived from the
    -- active theme at render time, so it follows both mode and theme changes.

    -- vim.fn.mode() (first char) -> lualine section-highlight suffix
    local mode_map = {
      n = "normal",
      i = "insert",
      v = "visual",
      V = "visual",
      ["\22"] = "visual", -- <C-v>
      s = "visual",
      S = "visual",
      ["\19"] = "visual", -- <C-s>
      R = "replace",
      c = "command",
      t = "terminal",
      ["!"] = "command",
    }

    local function hex(c)
      return c and string.format("#%06x", c) or nil
    end

    -- Mix two 0xRRGGBB colours; alpha weights toward fg.
    local function blend(fg, bg, alpha)
      if not (fg and bg) then
        return fg or bg
      end
      local function part(c, shift)
        return math.floor(c / shift) % 0x100
      end
      local function mix(a, b)
        return math.floor(a * alpha + b * (1 - alpha) + 0.5)
      end
      return mix(part(fg, 0x10000), part(bg, 0x10000)) * 0x10000 + mix(part(fg, 0x100), part(bg, 0x100)) * 0x100 + mix(part(fg, 1), part(bg, 1))
    end

    -- Accent colours for the current mode, from lualine's own section group.
    local function accent()
      local m = mode_map[vim.fn.mode():sub(1, 1)] or "normal"
      local a = vim.api.nvim_get_hl(0, { name = "lualine_a_" .. m, link = false })
      if not (a.fg and a.bg) then
        a = vim.api.nvim_get_hl(0, { name = "lualine_a_normal", link = false })
      end
      if not (a.fg and a.bg) then
        a = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
      end
      return a
    end

    local function tabs()
      local a = accent()
      local dim = blend(a.fg, a.bg, 0.5)
      vim.api.nvim_set_hl(0, "LualineTabActive", { fg = a.bg, bg = a.fg, bold = true })
      vim.api.nvim_set_hl(0, "LualineTabInactive", { fg = a.fg, bg = a.bg })
      vim.api.nvim_set_hl(0, "LualineTabUnused", { fg = dim, bg = a.bg })
      vim.api.nvim_set_hl(0, "LualineTabSep", { fg = dim, bg = a.bg })

      local current = vim.fn.tabpagenr()
      local total = vim.fn.tabpagenr("$")
      local slots = {}
      for i = 1, 4 do
        local group
        if i == current then
          group = "LualineTabActive"
        elseif i <= total then
          group = "LualineTabInactive"
        else
          group = "LualineTabUnused"
        end
        slots[i] = string.format("%%#%s# %d ", group, i)
      end
      return table.concat(slots, "%#LualineTabSep#|")
    end

    -- Replace the far-right section (the clock) with the tab indicator,
    -- filled with the mode accent so it matches the NORMAL block.
    opts.sections.lualine_z = {
      {
        tabs,
        padding = 0,
        color = function()
          local a = accent()
          return { fg = hex(a.fg), bg = hex(a.bg) }
        end,
      },
    }
  end,
}
