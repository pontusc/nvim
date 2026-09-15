-- ghaction is a custom filetype with no ftplugin of its own, so inherit yaml's
-- buffer options (comments, commentstring, expandtab, formatoptions, sw, sts)
vim.cmd("runtime! ftplugin/yaml.vim")
