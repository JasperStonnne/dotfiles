-- =========================
-- Basic Settings
-- =========================
vim.g.mapleader = " "          -- Space as leader key

local opt = vim.opt
opt.number = true              -- Line numbers
opt.relativenumber = true      -- Relative numbers
opt.tabstop = 4                -- Tab width
opt.shiftwidth = 4             -- Indent width
opt.expandtab = true           -- Tab to spaces
opt.smartindent = true         -- Smart indent
opt.termguicolors = true       -- True colors
opt.signcolumn = "yes"         -- Always show sign column
opt.cursorline = true          -- Highlight current line
opt.scrolloff = 8              -- Scroll offset 8
opt.ignorecase = true          -- Case insensitive search
opt.smartcase = true           -- Smart case
opt.splitright = true          -- Split right
opt.splitbelow = true          -- Split below
opt.clipboard = "unnamedplus"  -- System clipboard
opt.undofile = true            -- Persistent undo

-- =========================
-- Keymaps
-- =========================
local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Right window" })

-- Keep selection after indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Clear search highlight
map("n", "<Esc>", ":noh<CR>", { desc = "Clear highlight" })

-- Quick close terminal with q
map("t", "<C-q>", [[<C-\><C-n>:q<CR>]], { desc = "Close terminal" })

-- Save / Quit
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit" })

-- Compile & run current file
map("n", "<leader>r", function()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("Save file first", vim.log.levels.WARN)
        return
    end
    vim.cmd("w")
    local ft = vim.bo.filetype
    local cmd_map = {
        python     = "python3 " .. file,
        javascript = "node " .. file,
        typescript = "npx tsx " .. file,
        lua        = "lua " .. file,
        rust       = "rustc " .. file .. " -o /tmp/out && /tmp/out",
        c          = "gcc " .. file .. " -o /tmp/out && /tmp/out",
        cpp        = "g++ " .. file .. " -o /tmp/out && /tmp/out",
        go         = "go run " .. file,
        sh         = "bash " .. file,
        java       = "javac " .. file .. " && java -cp " .. vim.fn.fnamemodify(file, ":h") .. " " .. vim.fn.fnamemodify(file, ":t:r"),
    }
    local cmd = cmd_map[ft]
    if not cmd then
        vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
        return
    end
    -- Reuse existing terminal buffer if found
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "terminal" then
            local win = vim.fn.bufwinid(buf)
            if win ~= -1 then
                vim.api.nvim_set_current_win(win)
                vim.cmd("terminal " .. cmd)
                vim.cmd("startinsert")
                return
            end
        end
    end
    vim.cmd("split | terminal " .. cmd)
    vim.cmd("startinsert")
end, { desc = "Run" })

-- =========================
-- Plugin Manager (lazy.nvim)
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- Theme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    -- Dashboard
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                "                                                     ",
                "       [  The only way to do great work is to love   ",
                "              what you do.  -- Steve Jobs  ]          ",
                "                                                     ",
            }

            local button = dashboard.button
            dashboard.section.buttons.val = {
                button("f", "   Find File",    "<cmd>lua require('lazy').load({plugins={'telescope.nvim'}}); vim.cmd('Telescope find_files')<CR>"),
                button("r", "   Recent Files", "<cmd>lua require('lazy').load({plugins={'telescope.nvim'}}); vim.cmd('Telescope oldfiles')<CR>"),
                button("g", "   Live Grep",    "<cmd>lua require('lazy').load({plugins={'telescope.nvim'}}); vim.cmd('Telescope live_grep')<CR>"),
                button("n", "   New File",     ":ene <BAR> startinsert<CR>"),
                button("e", "   File Tree",    "<cmd>lua require('lazy').load({plugins={'nvim-tree.lua'}}); vim.cmd('NvimTreeToggle')<CR>"),
                button("c", "   Config",       ":e ~/.config/nvim/init.lua<CR>"),
                button("q", "   Quit",         ":qa<CR>"),
            }

            -- Footer with stats
            dashboard.section.footer.val = function()
                local stats = require("lazy").stats()
                local v = vim.version()
                return {
                    "                                                     ",
                    string.format("  Neovim v%d.%d.%d  |  %d plugins loaded  |  %dms startup",
                        v.major, v.minor, v.patch, stats.loaded, math.floor(stats.startuptime)),
                    "                                                     ",
                }
            end
            dashboard.section.footer.opts.hl = "AlphaFooter"

            -- Button highlight groups
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            for _, btn in ipairs(dashboard.section.buttons.val) do
                btn.opts.hl = "AlphaButtons"
                btn.opts.hl_shortcut = "AlphaShortcut"
            end

            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.opts.layout[1].val = 4  -- top padding

            alpha.setup(dashboard.config)
        end,
    },

    -- File Tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", function() require("nvim-tree.api").tree.toggle() end, desc = "File Tree" },
        },
        config = function()
            require("nvim-tree").setup({
                view = { width = 30 },
                filters = { dotfiles = false },
                filesystem_watchers = { enable = true },
            })
        end,
    },

    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find File" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Live Grep" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help" },
            { "<leader>fr", function() require("telescope.builtin").oldfiles() end,   desc = "Recent Files" },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git/" },
                },
            })
        end,
    },

    -- Syntax Highlighting (tree-sitter)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local ensure = { "lua", "python", "javascript", "typescript", "rust", "go", "bash", "json", "yaml", "markdown" }
            for _, lang in ipairs(ensure) do
                pcall(vim.treesitter.language.require, lang)
            end
        end,
    },

    -- LSP Support
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            { "williamboman/mason-lspconfig.nvim" },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local b = function(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
                    end
                    b("gd", vim.lsp.buf.definition, "Go to definition")
                    b("gr", vim.lsp.buf.references, "Find references")
                    b("K",  vim.lsp.buf.hover, "Hover docs")
                    b("<leader>rn", vim.lsp.buf.rename, "Rename")
                    b("<leader>ca", vim.lsp.buf.code_action, "Code action")
                    b("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                    b("]d", vim.diagnostic.goto_next, "Next diagnostic")
                end,
            })

            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "ts_ls" },
                automatic_enable = true,
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })
            vim.lsp.config("pyright", {})
            vim.lsp.config("ts_ls", {})
        end,
    },

    -- Auto Completion (blink.cmp)
    {
        "saghen/blink.cmp",
        version = "v0.*",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        opts = {
            keymap = {
                preset = "super-tab",
            },
            sources = {
                default = { "lsp", "snippets", "buffer", "path" },
            },
            completion = {
                accept = { auto_brackets = { enabled = true } },
                documentation = { auto_show = true, auto_show_delay_ms = 200 },
                list = { selection = { preselect = true, auto_insert = true } },
                trigger = { show_in_snippet = false },
            },
            signature = { enabled = true },
        },
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "tokyonight" },
            })
        end,
    },

    -- Git Signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Auto Pair Brackets
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- Comments: gcc line, gc selection
    {
        "numToStr/Comment.nvim",
        config = true,
    },

})
