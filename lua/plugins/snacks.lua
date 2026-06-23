-- Inline image auth: gh token fetched once per session (closure-local, not _G);
-- url -> downloaded local path, stable for the session.
local gh_token
local gh_image_cache = {}

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          -- Shows gitignored fileds
          -- ignored = true,
          -- Show "hidden" (dotfiles) in filesearch
          hidden = true,
        },
        grep = {
          -- Search hidden (dot) files/dirs like .github/
          hidden = true,
          -- Uncomment to also search gitignored files
          -- ignored = true,
        },
      },
    },
    scroll = {
      enabled = false, -- Disable scrolling animations
    },
    -- Inline image rendering via the Kitty graphics protocol (kitty/ghostty host,
    -- through tmux with allow-passthrough). Renders images in markdown buffers —
    -- including guh.nvim PR bodies/comments. Needs ImageMagick (`magick`).
    image = {
      enabled = true,
      -- snacks fetches remote images with anonymous curl, which 404s on PRIVATE-repo
      -- GitHub attachments (the `<img src=...>` in guh.nvim PR bodies). Download ONLY
      -- those ourselves with the gh token and return a local file; everything else
      -- returns nil so the token never leaves to a non-GitHub host.
      resolve = function(_, src)
        -- Full-shape, control-char-free match (snacks url-decodes src before this hook).
        if not src:match("^https://github%.com/user%-attachments/[%w%-/.]+$") then
          return nil
        end
        -- Stable per-url path so snacks' src-keyed dedup/caching holds.
        if gh_image_cache[src] and vim.fn.filereadable(gh_image_cache[src]) == 1 then
          return gh_image_cache[src]
        end
        -- Fetch + sanity-check the token once. pcall: vim.fn.system throws if gh is absent.
        if not gh_token then
          local ok, tok = pcall(vim.fn.system, { "gh", "auth", "token" })
          if not ok or vim.v.shell_error ~= 0 then
            return nil
          end
          tok = vim.trim(tok)
          if not tok:match("^%w[%w_]+$") then -- reject empty/malformed
            return nil
          end
          gh_token = tok
        end
        -- -f: non-2xx -> nonzero exit (no error body cached as png).
        -- --max-time: never freeze the UI on a hung connection.
        -- --config stdin: token never appears in argv/ps. pcall: curl may be absent.
        -- tempname(): lands in a 0700 dir, so the private image isn't world-readable.
        local out = vim.fn.tempname() .. ".png"
        local ok, res = pcall(function()
          return vim
            .system({ "curl", "-fsSL", "--max-time", "15", "--config", "-", "-o", out, src }, {
              stdin = 'header = "Authorization: Bearer ' .. gh_token .. '"\n',
            })
            :wait()
        end)
        if ok and res.code == 0 and vim.fn.filereadable(out) == 1 then
          gh_image_cache[src] = out
          return out
        end
        return nil
      end,
    },
  },
}
