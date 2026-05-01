local opt = vim.opt

opt.maxmempattern = 2000

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.softtabstop = 4
opt.number = true
opt.background = "dark"

opt.termguicolors = false 

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
    
    -- background
    api.nvim_set_hl(0, "Normal",       { ctermfg = 255, bg = "none", ctermbg = "none" })
    api.nvim_set_hl(0, "NormalNC",     { bg = "none", ctermbg = "none" })
    api.nvim_set_hl(0, "SignColumn",   { bg = "none", ctermbg = "none" })

    -- statusline
    api.nvim_set_hl(0, "StatusLine",   { bg = "none", ctermbg = "none", reverse = false })
    api.nvim_set_hl(0, "StatusLineNC", { bg = "none", ctermbg = "none", reverse = false })
    api.nvim_set_hl(0, "WinSeparator", { bg = "none", ctermbg = "none" })
    api.nvim_set_hl(0, "VertSplit",    { bg = "none", ctermbg = "none" })
    
    api.nvim_set_hl(0, "Search",       { ctermbg = 22, ctermfg = 223 })
    api.nvim_set_hl(0, "Visual",       { ctermbg = 255, ctermfg = 0 })
    api.nvim_set_hl(0, "ModeMsg",      { ctermfg = 183, bold = true }) 
    api.nvim_set_hl(0, "MatchParen",   { ctermbg = 117, ctermfg = 0 }) 

    -- nvim tree-sitter 
    api.nvim_set_hl(0, "@string.regexp", { ctermfg = 217 })
    api.nvim_set_hl(0, "@variable.builtin", { ctermfg = 219 })
    api.nvim_set_hl(0, "@function.builtin", { ctermfg = 117 })
    api.nvim_set_hl(0, "@type.builtin", { ctermfg = 117 })
    api.nvim_set_hl(0, "@constant.builtin", { ctermfg = 194, bold = true })
    api.nvim_set_hl(0, "@keyword", { ctermfg = 117, bold = true })
    
    api.nvim_set_hl(0, "@string.escape", { ctermfg = 225 })
    api.nvim_set_hl(0, "@punctuation.special", { ctermfg = 225 })
    api.nvim_set_hl(0, "@variable", { ctermfg = 225 })
    api.nvim_set_hl(0, "@variable.member", { ctermfg = 225 })

    api.nvim_set_hl(0, "@function", { ctermfg = 255 })
    api.nvim_set_hl(0, "@function.call", { ctermfg = 255 })
    api.nvim_set_hl(0, "@function.method", { ctermfg = 255 })
    api.nvim_set_hl(0, "@function.method.call", { ctermfg = 255 })

    api.nvim_set_hl(0, "@constructor", { ctermfg = 117 })
    api.nvim_set_hl(0, "@property", { ctermfg = 117 })        
end

local color_augroup = vim.api.nvim_create_augroup("MyCustomColors", { clear = true })

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
        ts.install({
            "c", "python", "lua", "vim", "vimdoc", "query",
            "javascript", "typescript", "html", "css", "json",
            "markdown", "markdown_inline", "bash"
        })

        -- enable treesitter highlighting 
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
  },
})
