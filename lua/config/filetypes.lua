vim.filetype.add({
  pattern = {
    -- Ansible playbooks
    [".*playbook.*%.ya?ml"] = "yml.ansible",
    [".*play.*%.ya?ml"] = "yml.ansible",

    -- Common Ansible file patterns
    [".*ansible.*%.ya?ml"] = "yml.ansible",

    -- Dockerfile detection
    [".*[Dd]ockerfile.*"] = "dockerfile",
  },

  filename = {},
})
