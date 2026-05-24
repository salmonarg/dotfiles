local opt = vim.opt

opt.maxmempattern = 2000

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.softtabstop = 4
opt.number = true
opt.background = "dark"

opt.termguicolors = false 

vim.opt.clipboard = "unnamedplus"
vim.o.statusline = vim.o.statusline .. " %{winwidth(0)}"

-- bufferline
vim.keymap.set("n", "<leader>x", function()
  if vim.bo.filetype == "NvimTree" then
    return
  end
  vim.cmd("Bdelete")
end, { silent = true, desc = "Delete buffer gently" })

vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })

-- check highlight group <F10>
vim.keymap.set("n", "<F10>", function()
    local pos = vim.api.nvim_win_get_cursor(0)
    local row, col = pos[1] - 1, pos[2]

    local captures = vim.treesitter.get_captures_at_pos(0, row, col)
    local ts_msg = "Tree-sitter: None"
    if #captures > 0 then
        local names = {}
        for _, capture in ipairs(captures) do
            table.insert(names, "@" .. capture.capture)
        end
        ts_msg = "Tree-sitter: " .. table.concat(names, ", ")
    end

    local syn_id = vim.fn.synID(pos[1], pos[2] + 1, 1)
    local syn_msg = "Syntax: " .. vim.fn.synIDattr(syn_id, "name")
    local trans_id = vim.fn.synIDtrans(syn_id)
    local trans_msg = "Link: " .. vim.fn.synIDattr(trans_id, "name")

    print(ts_msg .. " | " .. syn_msg .. " | " .. trans_msg)
end, { desc = "Inspect Highlight Group" })

-- dynamic cursor shape in insert mode
local function update_cursor_shape()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()
    local col = cursor[2]

    local char_at = line:sub(col + 1, col + 1)
    local char_before = line:sub(col, col)
    local brackets = "()[]{}<>"

    local is_bracket = (char_at ~= "" and brackets:find(char_at, 1, true) ~= nil) or 
                       (char_before ~= "" and brackets:find(char_before, 1, true) ~= nil)

    if is_bracket then
        vim.opt.guicursor:append("i:block-Cursor")
    else
        vim.opt.guicursor:remove("i:block-Cursor")
    end
end

local cursor_group = vim.api.nvim_create_augroup("InsertCursorBracket", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertEnter" }, {
    group = cursor_group,
    callback = update_cursor_shape,
})
vim.api.nvim_create_autocmd("InsertLeave", {
    group = cursor_group,
    callback = function()
        vim.opt.guicursor:remove("i:block-Cursor")
    end,
})

-- color scheme
local function set_colors()
    local api = vim.api
    
    api.nvim_set_hl(0, "Comment", { ctermfg = 146 })
    api.nvim_set_hl(0, "LineNr",  { ctermfg = 146 })
    api.nvim_set_hl(0, "NonText", { ctermfg = 146 })
    api.nvim_set_hl(0, "EndOfBuffer", { ctermfg = 146, bg = "none", ctermbg = "none" }) 
    
    api.nvim_set_hl(0, "Statement",    { ctermfg = 117, bold = true })
    api.nvim_set_hl(0, "Function",     { ctermfg = 117, bold = true })
    api.nvim_set_hl(0, "Type",         { ctermfg = 255 })
    api.nvim_set_hl(0, "StorageClass", { ctermfg = 117, bold = true })
    
    api.nvim_set_hl(0, "String",       { ctermfg = 223 })
    
    api.nvim_set_hl(0, "Number",       { ctermfg = 194 })
    api.nvim_set_hl(0, "Boolean",      { ctermfg = 194 })
    api.nvim_set_hl(0, "Constant",     { ctermfg = 194 })
    
    api.nvim_set_hl(0, "Operator",     { ctermfg = 255 })
    api.nvim_set_hl(0, "Delimiter",    { ctermfg = 255 })
    
    api.nvim_set_hl(0, "Normal",       { ctermfg = 255, bg = "none", ctermbg = "none" })
    api.nvim_set_hl(0, "NormalNC",     { bg = "none", ctermbg = "none" })
    api.nvim_set_hl(0, "SignColumn",   { bg = "none", ctermbg = "none" })

    api.nvim_set_hl(0, "StatusLine",   { bg = "none", ctermbg = "none", reverse = false })
    api.nvim_set_hl(0, "StatusLineNC", { bg = "none", ctermbg = "none", reverse = false })
    api.nvim_set_hl(0, "WinSeparator", { bg = "none", ctermbg = "none" })
    api.nvim_set_hl(0, "VertSplit",    { bg = "none", ctermbg = "none" })
    
    api.nvim_set_hl(0, "Search",       { ctermbg = 22, ctermfg = 223 })
    api.nvim_set_hl(0, "Visual",       { ctermbg = 255, ctermfg = 0 })
    api.nvim_set_hl(0, "ModeMsg",      { ctermfg = 183, bold = true }) 
    api.nvim_set_hl(0, "MatchParen",   { ctermbg = 117, ctermfg = 0 }) 
    api.nvim_set_hl(0, "Cursor",       { ctermbg = 255, ctermfg = 0 })
    api.nvim_set_hl(0, "TermCursor",   { ctermbg = 255, ctermfg = 0 })

    -- nvim tree-sitter 
    api.nvim_set_hl(0, "@string.regexp", { ctermfg = 217 })
    api.nvim_set_hl(0, "@variable.builtin", { ctermfg = 219 })
    api.nvim_set_hl(0, "@function.builtin", { ctermfg = 117 })
    api.nvim_set_hl(0, "@type.builtin", { ctermfg = 117 })
    api.nvim_set_hl(0, "@constant.builtin", { ctermfg = 194 })
    api.nvim_set_hl(0, "@keyword", { ctermfg = 117, bold = true })
    api.nvim_set_hl(0, "@attribute.builtin", { ctermfg = 117, bold = true })

    api.nvim_set_hl(0, "@string.escape", { ctermfg = 225 })
    api.nvim_set_hl(0, "@punctuation.special", { ctermfg = 225 })
    api.nvim_set_hl(0, "@variable", { ctermfg = 225 })
    api.nvim_set_hl(0, "@variable.member", { ctermfg = 225 })

    api.nvim_set_hl(0, "@module", { ctermfg = 255 })
    api.nvim_set_hl(0, "@module.builtin", { ctermfg = 117 })

    api.nvim_set_hl(0, "@function", { ctermfg = 255 })
    api.nvim_set_hl(0, "@function.call", { ctermfg = 255 })
    api.nvim_set_hl(0, "@function.method", { ctermfg = 255 })
    api.nvim_set_hl(0, "@function.method.call", { ctermfg = 255 })

    api.nvim_set_hl(0, "@constructor", { ctermfg = 117 })
    api.nvim_set_hl(0, "@property", { ctermfg = 117 })        
end

local color_augroup = vim.api.nvim_create_augroup("Asyk", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
    group = color_augroup,
    pattern = "*",
    callback = set_colors,
})

set_colors()

-- lazy nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", 
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local status_ok, ts = pcall(require, "nvim-treesitter")
        if not status_ok then
            vim.notify("failed to load nvim-treesitter", vim.log.levels.ERROR)
            return
        end
        ts.setup()
        -- ts.install({
        --     "c", "python", "lua", "vim", "vimdoc", "query",
        --     "javascript", "typescript", "html", "css", "json",
        --     "markdown", "markdown_inline", "bash"
        -- })

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        default_component_configs = {
          icon = {
            folder_closed = "[+]",
            folder_open   = "[-]",
            folder_empty  = "[ ]",
            default       = " ",
            highlight     = "NeoTreeFileIcon"
          },
          git_status = {
            symbols = {
              added     = "A",
              modified  = "M",
              deleted   = "D",
              renamed   = "R",
              untracked = "U",
              ignored   = "I",
              unstaged  = "G",
              staged    = "S",
              conflict  = "C",
            }
          }
        },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          }
        }
      })
      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true })
    end
  },
  { 'famiu/bufdelete.nvim' },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    config = function()

      require("bufferline").setup({
        options = {
          mode = "buffers",
          always_show_bufferline = false,
          show_buffer_icons = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = "thin",
          modified_icon = "[M]",

          custom_filter = function(buf_number)
            if vim.bo[buf_number].filetype == "NvimTree" then
              return false
            end
            return true
          end,

          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = false
            }
          }
        },
        highlights = {
          buffer_selected = {
            ctermfg = 15,
            bold = true,
            italic = false,
            ctermbg = 0
          },
          modified_selected = {
            ctermfg = 15,
            ctermbg = 0,
            bold = true
          }
        }
      })
    end
  }
})
