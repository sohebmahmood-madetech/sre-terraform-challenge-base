-- Baseline Neovim config for the SRE Terraform Challenge devcontainer.
-- Copied to ~/.config/nvim/init.lua on container creation ONLY if you don't
-- already have a config — bring your own dotfiles and this stays out of the way.
-- No plugin manager: Terraform support uses the built-in LSP client with
-- terraform-ls, which is preinstalled in the container.

vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.termguicolors = true

vim.g.mapleader = " "

-- terraform-ls for .tf / .tfvars buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "terraform", "terraform-vars", "hcl" },
  callback = function(ev)
    vim.lsp.start({
      name = "terraform-ls",
      cmd = { "terraform-ls", "serve" },
      root_dir = vim.fs.root(ev.buf, { ".terraform", ".git" }) or vim.fn.getcwd(),
    })
  end,
})

-- Format Terraform files on save via the language server
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})

-- Handy LSP mappings once a server attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  end,
})
