-- Neovim: IDE basica para C e Assembly
vim.g.mapleader = " "

local o = vim.opt
o.number = true
o.relativenumber = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.termguicolors = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.updatetime = 250
o.splitright = true
o.splitbelow = true
o.completeopt = { "menu", "menuone", "noselect" }

-- Arquivos assembly: NASM para .asm/.nasm, GAS para .s/.S
vim.filetype.add({
  extension = { asm = "nasm", nasm = "nasm", inc = "nasm", s = "asm", S = "asm" },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nasm", "asm" },
  callback = function() vim.bo.tabstop = 4; vim.bo.shiftwidth = 4; vim.bo.expandtab = true end,
})

-- Windows: usa PowerShell como shell do :terminal
if vim.fn.has("win32") == 1 then o.shell = "powershell.exe" end

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function() vim.cmd.colorscheme("catppuccin-mocha") end },

  -- Syntax highlight
  { "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate",
    config = function()
      local langs = { "c", "cpp", "lua", "vim", "vimdoc", "make", "cmake", "bash", "nasm", "asm" }
      pcall(function() require("nvim-treesitter").install(langs) end)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(a) pcall(vim.treesitter.start, a.buf) end,
      })
    end },

  -- Autocomplete
  { "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer" }, { name = "path" } }),
      })
    end },

  -- LSP (API nativa do nvim 0.11+; nvim-lspconfig fornece as configs)
  { "neovim/nvim-lspconfig",
    config = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = caps })
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
      })
      local servers = { "clangd" }
      if vim.fn.executable("asm-lsp") == 1 then table.insert(servers, "asm_lsp") end
      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local m = function(k, f, d) vim.keymap.set("n", k, f, { buffer = ev.buf, desc = d }) end
          m("gd", vim.lsp.buf.definition, "Ir para definicao")
          m("gr", vim.lsp.buf.references, "Referencias")
          m("K", vim.lsp.buf.hover, "Documentacao")
          m("<leader>rn", vim.lsp.buf.rename, "Renomear")
          m("<leader>ca", vim.lsp.buf.code_action, "Code action")
          m("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Formatar")
          m("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Diag anterior")
          m("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Proximo diag")
        end,
      })
    end },

  -- Navegacao
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Arquivos" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    } },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" } },
    opts = {} },
  { "nvim-lualine/lualine.nvim", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },
}, { rocks = { enabled = false } })

-- Compilar/rodar rapido
vim.keymap.set("n", "<leader>b", function()
  local f = vim.fn.expand("%")
  local ft = vim.bo.filetype
  local cmd
  if ft == "c" then cmd = ("gcc -g -Wall -Wextra %s -o %s.exe && .\\%s.exe"):format(f, vim.fn.expand("%:r"), vim.fn.expand("%:r"))
  elseif ft == "nasm" then cmd = ("nasm -f win64 %s -o %s.obj && gcc %s.obj -o %s.exe"):format(f, vim.fn.expand("%:r"), vim.fn.expand("%:r"), vim.fn.expand("%:r"))
  else return end
  vim.cmd("write | botright 12split | terminal " .. cmd)
end, { desc = "Compilar e rodar" })
-- Mover linhas: Alt+j / Alt+k (normal, insert e visual)
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Descer linha" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Subir linha" })
vim.keymap.set("i", "<A-j>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Descer linha" })
vim.keymap.set("i", "<A-k>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Subir linha" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Descer selecao" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Subir selecao" })

-- Indentar: Alt+l indenta, Alt+h desindenta (normal, insert e visual)
vim.keymap.set("n", "<A-l>", ">>", { desc = "Indentar linha" })
vim.keymap.set("n", "<A-h>", "<<", { desc = "Desindentar linha" })
vim.keymap.set("i", "<A-l>", "<C-t>", { desc = "Indentar linha" })
vim.keymap.set("i", "<A-h>", "<C-d>", { desc = "Desindentar linha" })
vim.keymap.set("v", "<A-l>", ">gv", { desc = "Indentar selecao" })
vim.keymap.set("v", "<A-h>", "<gv", { desc = "Desindentar selecao" })
-- Visual: Tab / Shift+Tab e < > mantem a selecao
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indentar selecao" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Desindentar selecao" })
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
