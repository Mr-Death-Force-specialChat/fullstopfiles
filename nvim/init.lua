vim.cmd [[colorscheme cslate]]
vimsyn_embed = 'lPr'
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.expandtab = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.guicursor = "a:ver25,r-cr:hor25,n:block"
vim.opt.foldmethod = "syntax"
-- Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		'dense-analysis/ale',
		config = function()
			-- Configuration goes here.
			local g = vim.g

			g.ale_ruby_rubocop_auto_correct_all = 1

			g.ale_cpp_cc_options = "-std=c++20 -Wall"
			g.ale_rust_rls_toolchain = 'stable'
			g.ale_linters = {
				rust = {'rust-analyzer', 'cargo'},
				ruby = {'rubocop', 'ruby'},
				lua = {'lua_language_server'}
			}
			g.ale_lint_on_save = 1
			g.ale_fixers = { rust = {'rustfmt'} }
			g.ale_completion_enabled = 1
			g.ale_c_parse_makefile = 1
		end
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end
	},
	{
		"timtro/glslView-nvim",
		viewer_path = 'glslViewer',
		args = { '-l' }
	}
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<F3>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<F8>', ':syn sync fromstart<cr>')

-- Shows tabs and spaces and newlines
vim.api.nvim_command([[nnoremap <F2> :<C-U>setlocal lcs=tab:>-,trail:_,eol:$ list! list? <CR>]])

vim.api.nvim_command([[
function Mkfn(...)
	call setline(line('.'), printf("%s %s(", a:1, a:2))
	
	let l:c = 3
	call setline(line("."), printf("%s%s %s", getline("."), a:{c}, a:{c+1}))
	let c += 2
	while c < a:0
		call setline(line("."), printf("%s, %s %s", getline("."), a:{c}, a:{c+1}))
		let c += 2
	endwhile

	call setline(line("."), printf("%s%s", getline("."), ")"))
	call appendbufline(bufname(), line("."), ["{", "\t", "}"] )
	startinsert
	call cursor(line('.') + 2, col('$'))
endfunction

command -nargs=* Mkfn call Mkfn(<f-args>)
]])
vim.api.nvim_command([[command Mkmain call Mkfn("int", "main", "int", "argc", "char**", "argv")]])
vim.api.nvim_command([[command -nargs=1 Rename call Rename(<f-args>)]])
vim.api.nvim_command([[tnoremap <Esc> <C-\><C-n>]])
