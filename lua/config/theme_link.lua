-- The spec module must stay a symlink: lazy's reloader stats it through the link, so `omarchy theme set` triggers a repaint.
local link = vim.fn.stdpath("config") .. "/lua/plugins/theme.lua"
local omarchy_theme = vim.env.HOME .. "/.local/state/omarchy/current/theme/neovim.lua"
local fallback_theme = vim.fn.stdpath("config") .. "/lua/themes/fallback.lua"

local target = vim.uv.fs_stat(omarchy_theme) and omarchy_theme or fallback_theme

if vim.uv.fs_readlink(link) == target then
  return
end

if vim.uv.fs_lstat(link) then
  local unlinked, unlink_error = vim.uv.fs_unlink(link)
  if not unlinked then
    vim.notify("theme_link: cannot remove " .. link .. ": " .. tostring(unlink_error), vim.log.levels.ERROR)
    return
  end
end

local linked, symlink_error = vim.uv.fs_symlink(target, link)
if not linked then
  vim.notify("theme_link: cannot link " .. link .. " to " .. target .. ": " .. tostring(symlink_error), vim.log.levels.ERROR)
end
