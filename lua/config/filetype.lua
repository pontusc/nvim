vim.filetype.add({
  pattern = {
    -- Ansible playbooks
    [".*playbook.*%.ya?ml"] = "ansible",
    [".*play.*%.ya?ml"] = "ansible",

    -- Common Ansible file patterns
    [".*ansible.*%.ya?ml"] = "ansible",

    ["*.alloy"] = "alloy",

    -- Dockerfile detection
    ["[Dd]ockerfile.*"] = "dockerfile",

    -- Hyprland
    [".*/hypr/.*%.conf"] = "hyprlang",
  },

  filename = {
    ["Caddyfile"] = "caddy",
  },

  extension = {
    caddy = "caddy",
  },
})
