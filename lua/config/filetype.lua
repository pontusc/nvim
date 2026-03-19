vim.filetype.add({
  pattern = {
    -- Ansible playbooks
    [".*playbook.*%.ya?ml"] = "ansible",

    -- Common Ansible file patterns
    [".*ansible.*%.ya?ml"] = "ansible",

    ["*.alloy"] = "alloy",

    -- Dockerfile detection
    ["[Dd]ockerfile.*"] = "dockerfile",

    -- Hyprland
    [".*/hypr/.*%.conf"] = "hyprlang",

    [".*Caddyfile.*"] = "caddy",

    -- GitHub Actions workflows
    [".*/%.github/workflows/.*%.ya?ml"] = "ghaction",
  },

  extension = {
    caddy = "caddy",
  },
})
