-- ==========================================================================
-- 1. CORE SETTINGS (Split Keyboard & High Contrast/Aniridia Friendly)
-- ==========================================================================
vim.g.mapleader = " " -- Set SPACE as your Leader (Your primary thumb key)
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Visual Navigation & Eye Comfort Options
opt.number = true          -- Show line numbers
opt.relativenumber = true  -- Relative line numbers (makes jump calculations like '5j' easy)
opt.signcolumn = "yes"     -- Keep gutters reserved for Git indicators (prevents text jumping)
opt.cursorline = true      -- Highlight the current line horizontally
opt.cursorcolumn = true    -- VERTICAL CROSSHAIR: Lights up your current column (Excellent for visual alignment)
opt.colorcolumn = "80"     -- Subtle vertical guideline showing where the 80-character limit falls
opt.scrolloff = 8          -- Keep cursor centered with 8 lines of padding above and below when scrolling

-- Screen Splitting Rules
opt.splitbelow = true      -- New horizontal splits open below the current panel
opt.splitright = true      -- New vertical splits open to the right of the current panel

-- Text Indentation, Tabs, and Spaces
opt.expandtab = true       -- Convert tabs to spaces
opt.shiftwidth = 2         -- 2 spaces indentation
opt.tabstop = 2            -- 2 spaces tab display
opt.completeopt = { "menu", "menuone", "noselect" }

-- Performance & Integration Settings
opt.termguicolors = true   -- Enable true color (necessary for deep, high-contrast themes)
opt.ignorecase = true      -- Ignore case during searches...
opt.smartcase = true       -- ...unless a capital letter is typed in the search query
opt.clipboard = "unnamedplus" -- Sync with system clipboard (seamless copy-paste to/from OS)
opt.mouse = "a"            -- Mouse support enabled in case you need it occasionally
opt.undofile = true        -- Persistent Undo tracking (edits can be undone even after closing Neovim)
opt.updatetime = 250       -- Quicker save response and update times
opt.timeoutlen = 400       -- Fast keyboard action/chord sequence timeout

-- ==========================================================================
-- 2. BOOTSTRAP LAZY.NVIM (Plugin Manager)
-- ==========================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================================
-- 3. PLUGIN INSTALLATION
-- ==========================================================================
require("lazy").setup({
  -- [AESTHETICS] Gruvbox Material: Warm, eye-friendly theme with high contrast
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard" -- Cleanest high-contrast dark background
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_bold = 1
      
      -- CRITICAL visual tweak: Make comments bold and sand-beige (no more faint, low-contrast text)
      vim.cmd([[
        colorscheme gruvbox-material
        highlight Comment guifg=#a89984 gui=bold
      ]])
    end
  },

  -- [UI STATUS] Sleek bottom status panel configured to match Gruvbox
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "gruvbox-material" } } 
  },

  -- [NAVIGATION] High-Contrast horizontal jump highlighting (f/F/t/T navigation)
  {
    "unblevable/quick-scope",
    lazy = false,
    init = function()
      vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
      vim.g.qs_max_chars = 80
    end,
    config = function()
      -- Vibrant golden primary landing target and blue alternative target with underlines
      vim.api.nvim_set_hl(0, "QuickScopePrimary", { fg = "#fabd2f", underline = true, bold = true })
      vim.api.nvim_set_hl(0, "QuickScopeSecondary", { fg = "#83a598", underline = true, bold = true })
    end,
  },

  -- [NAVIGATION] Harpoon: Mark and switch files instantly via home-row keys
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      
      -- Set up keymaps: Space + ergonomic resting keys
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon Pin File" })
      vim.keymap.set("n", "<leader>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })
      
      -- Jump to corresponding pin index using 1, 2, 3, 4 indices mapped to h-row
      vim.keymap.set("n", "<leader>j", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>k", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>l", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>;", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
    end
  },

  -- [UTILITY] Easy commenting: Type 'gc' on lines, motions, or selections
  {
    'echasnovski/mini.comment',
    version = '*',
    config = function() require('mini.comment').setup() end
  },

  -- [CODING SPEED] Auto-Pairs: Instantly closes brackets () [] {} and quotes ""
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({}) end
  },
  
  -- [NAVIGATION] Flash.nvim: Quick leap/search jumps across the entire screen
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
    },
  },

  -- [SEARCH] Telescope: Fuzzy file, pattern, and open buffer finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Find Help" },
    },
    opts = { defaults = { layout_strategy = "horizontal", sorting_strategy = "ascending" } },
  },

  -- [FILE MANAGER] Oil.nvim: Edit directory structures like simple text documents
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "-", "<cmd>Oil<CR>", desc = "Open File Manager" } },
    opts = {},
  },

  -- [GIT] Gitsigns: Shows color changes inside the gutter (line additions, updates, deletions)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- [ACCESSIBILITY] Which-key: Keyboard assistant overlay that details leader mappings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- [AESTHETICS] Rainbow brackets so nested parentheses look distinct and colored
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
  },

  -- [FORMATTING] Conform: Auto formatting on save (:w) for Python, React, and YAML
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" }, -- Sorts imports, then runs Black formatter
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettier" },
          yaml = { "prettier" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        },
      })
    end,
  },

  -- [MARKDOWN RENDERING] High-contrast inline Markdown visualization inside Neovim
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {},
    ft = { "markdown" },
  },

  -- [MARKDOWN PREVIEW] Real-time browser preview wrapper
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- [LSP WORKSPACE MANAGER] Mason: Interactive installer UI for LSPs, formatters, and linters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- [LSP SETUP ENGINE] lspconfig: Links language servers to Neovim's auto-completer
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
  },

  -- [PARSING ENGINE] Treesitter: Generates precise syntax structural compilation
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local configs_ok, configs = pcall(require, "nvim-treesitter.configs")
      if configs_ok then
        configs.setup({
          highlight = { enable = true },
          indent = { enable = true },
        })
        return
      end
      require("nvim-treesitter").setup({})
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local language = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if language then pcall(vim.treesitter.start, args.buf, language) end
        end,
      })
    end,
  }
})

-- ==========================================================================
-- 4. ERGONOMIC KEYMAPS (Window Management & Nav)
-- ==========================================================================
local map = vim.keymap.set

-- Standard File Controls using Space/Leader Key
map("n", "<leader>w", ":w<CR>", { desc = "Save File" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit Editor" })

-- Easy Screen Splitting Actions
map("n", "<leader>v", ":vsplit<CR>", { desc = "Split Screen Vertically" })
map("n", "<leader>h", ":split<CR>", { desc = "Split Screen Horizontally" })
map("n", "<leader>o", "<C-w>o", { desc = "Close Other Split Screens" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Close Current Buffer" })
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Oil File Manager" })

-- Unified System Clipboard Operations
map("x", "<C-c>", '"+y', { desc = "Copy Selection" })

-- Fast Copy Entire File (Leader + y)
map("n", "<leader>y", 'ggVG"+y', { desc = "Copy Entire File to Clipboard" })

-- Fast Paste & Replace Entire File from Clipboard (Leader + p)
map("n", "<leader>p", 'ggVG"+p', { desc = "Replace Entire File with Clipboard Contents" })

-- Easy Window Jumping (Left, Down, Up, Right)
-- Path A: Standard Control key + Home-Row Arrow
map("n", "<C-h>", "<C-w>h", { desc = "Move to Left Window Split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to Bottom Window Split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to Top Window Split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to Right Window Split" })

-- Path B: Mac Option / Windows Alt key + Home-Row Arrow (Great for Sialkka split thumbs!)
map("n", "<A-h>", "<C-w>h", { desc = "Move to Left Window Split" })
map("n", "<A-l>", "<C-w>l", { desc = "Move to Right Window Split" })
map("n", "<A-j>", "<C-w>j", { desc = "Move to Bottom Window Split" })
map("n", "<A-k>", "<C-w>k", { desc = "Move to Top Window Split" })

-- Clear Search Highlights with Escape
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Ergonomic Home-Row Escape Trigger: Tap 'jk' simultaneously in insert mode
map("i", "jk", "<Esc>", { silent = true })

-- Open Markdown Previews in a Vertical split layout (Space + m + p)
map("n", "<leader>mp", ":vsplit | MarkdownPreview<CR>", { desc = "Markdown Live Preview (Vertical Split)" })

-- Visual feedback animation when copying text ("Yank Highlight")
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 }) end,
})

-- Safe Escape key mapping for Integrated Terminal modes
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit Integrated Terminal Focus" })

-- ==========================================================================
-- 5. NATIVE CLOUD DEVELOPMENT LSP CONFIG (Python, Node, React, YAML)
-- ==========================================================================
if vim.lsp.config then

  -- Global LSP Attach Autocmd (Applies keymaps when any server hooks into a file)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      
      -- Home-row friendly LSP controls (Perfect for split keyboards)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = bufnr })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation hover bubble", buffer = bufnr })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart Rename Symbol", buffer = bufnr })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line error diagnostics", buffer = bufnr })
    end,
  })

  -- Configure all language servers using native Neovim 0.11+ configuration
  vim.lsp.config("pyright", {})
  vim.lsp.config("ts_ls", {})
  vim.lsp.config("eslint", {})
  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        schemas = {
          ["kubernetes"] = { "k8s/*.yaml", "kube/*.yaml", "deployment.yaml", "service.yaml" },
        },
      },
    },
  })

  -- Enable them all in one parallel step
  vim.lsp.enable({ "pyright", "ts_ls", "eslint", "yamlls" })
end
