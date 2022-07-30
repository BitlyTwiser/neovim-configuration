local util = require 'lspconfig/util'
local function setup_lsp_server()
    require'lspconfig'.solc.setup{}
    require'lspconfig'.solidity_ls.setup{}
    require'lspconfig'.solargraph.setup{}
end

setup_lsp_server()
