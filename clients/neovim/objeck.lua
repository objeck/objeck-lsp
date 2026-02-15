-- Objeck LSP configuration for Neovim 0.11+
--
-- Installation:
--   1. Copy this file to ~/.config/nvim/lsp/objeck.lua
--   2. Add to your init.lua:
--        vim.lsp.enable('objeck')
--
-- Prerequisites:
--   - Objeck installed with OBJECK_LIB_PATH set
--   - OBJECK_STDIO=binary environment variable set
--   - obr and objeck_lsp.obe available on PATH or configured below

-- File type detection for .obs files
vim.filetype.add({
  extension = {
    obs = 'objeck',
  },
})

-- LSP server configuration
return {
  cmd = {
    'obr',
    '<objeck_server_path>/objeck_lsp.obe',
    '<objeck_server_path>/objk_apis.json',
    'stdio',
  },
  filetypes = { 'objeck' },
  root_markers = { 'build.json' },
  settings = {},
}
