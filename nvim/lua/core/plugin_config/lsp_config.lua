require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'sumneko_lua' }
})

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})


  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()


require('lspconfig').sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

--[[
--require('lspconfig').phpactor.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
]]

require('lspconfig').intelephense.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require('lspconfig').bashls.setup {
  vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
}),
  on_attach = on_attach,
  capabilities = capabilities,
}

require'lspconfig'.html.setup {
	capabilities = capabilities,
  on_attach = on_attach,
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true
		},
		provideFormatter = true
	},
	settings = {},
	single_file_support = true
}
