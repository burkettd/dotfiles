-- NOTE: You shouldn't need to modify this file.
--
-- Instead go to:
-- * user.lsp.keymaps to modify keybindings
-- * user.lsp.servers to modify the list language servers
-- * user.lsp.settings.* to add language specific settings

-- Import lsp_installer, and exit if we can't.
local installer_status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not installer_status_ok then
  return
end

-- Import lspconfig, and exit if we can't
local config_status_ok, lspconfig = pcall(require, "lspconfig")
if not config_status_ok then
  return
end


-- Import our list of servers
local lsp_servers = require("user.lsp.servers")


-- Select the servers that should be installed by lsp_installer
local lsp_servers_to_install = {}
for _, server in ipairs(lsp_servers) do
  if server.install then
    table.insert(lsp_servers_to_install, server.name)
  end
end


-- Call lsp_installer so it can install our language servers for us
lsp_installer.setup({
  ensure_installed = lsp_servers_to_install,
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})


local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
   header = "",
    prefix = "",
  },
}

vim.diagnostic.config(config)


-- Run this function every time a lanuage server starts
local on_attach = function(client, bufnr)
  -- Set keymaps inside of the buffer lsp is active for
  require("user.lsp.keymaps")(client, bufnr)

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]] ,
      false
    )
  end
end

local lsp_options = {
  on_attach = on_attach,
}

for _, server in ipairs(lsp_servers) do
  local extra_options_exist, extra_options = pcall(require, "user.lsp.settings." .. server.name)

  local server_options = lsp_options

  if extra_options_exist then
    server_options = vim.tbl_deep_extend("force", extra_options, lsp_options)
  end

  lspconfig[server.name].setup(server_options)
end
