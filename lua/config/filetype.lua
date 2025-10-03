vim.filetype.add({
  pattern = {
    -- Ansible playbooks
    [".*playbook.*%.ya?ml"] = "ansible",
    [".*play.*%.ya?ml"] = "ansible",

    -- Common Ansible file patterns
    [".*ansible.*%.ya?ml"] = "ansible",

    -- Dockerfile detection
    [".*[Dd]ockerfile.*"] = "dockerfile",

    -- Hpyrland
    [".*/hypr/.*%.conf"] = "hyprlang",
  },

  filename = {},
})
