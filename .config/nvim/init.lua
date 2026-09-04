-- OPTIONS
--
-- See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:h option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- Show line numbers in a column
vim.o.number = true

-- Show line numbers relative to where the cursor is.
-- Affects the 'number' option above, see `:h number_relativenumber`.
vim.o.relativenumber = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true -- Highlight the line where the cursor is on.
vim.o.scrolloff = 10 -- Keep this many screen lines above/below the cursor.
vim.o.list = true -- Show <tab> and trailing spaces.
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
vim.o.confirm = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Enable break indent: make long lines break and wrap at the indent,
-- instead of breaking and starting on the next line as if it was a new line.
vim.o.breakindent = true

-- sync clipboard with system clipboard
vim.opt.clipboard = "unnamedplus"

-- Decrease update time (affects wait time for LSP highlight)
vim.o.updatetime = 250

-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- bounce between last 2 buffers
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Toggle alternate buffer" })

vim.keymap.set('n', '<leader>`', ':terminal<CR>', { desc = 'Open terminal' })
vim.keymap.set('n', '<leader>w', '<Cmd>w<CR>', { desc = 'Save' })

-- Buffers
vim.keymap.set("n", "<leader>bb", "<cmd>buffers<CR>", { desc = "List buffers" })
vim.keymap.set("n", "<leader>bx", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Windows
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Vertical split (|)" })
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { desc = "Horizontal split (-)" })
vim.keymap.set("n", "<leader>wx", "<C-w>q", { desc = "Close window" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Only window" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

-- Tabs, gt and gT to go next tab and back
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>td", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- to appease muscle memory
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<Cmd>w<CR>', { desc = 'Save' })
vim.keymap.set('n', '<C-z>', 'u', { desc = 'Undo' })
vim.keymap.set('i', '<C-z>', '<C-o>u', { desc = 'Undo' })

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

-- Delete the swap file for the current buffer
vim.api.nvim_create_user_command("SwapDelete", function()
  local swap = vim.fn.swapname(vim.api.nvim_get_current_buf())

  if swap == "" then
    vim.notify("No swap file", vim.log.levels.INFO)
    return
  end

  vim.fn.delete(swap)
  vim.notify("Deleted swap file: " .. swap)
end, {})

-- PLUGINS
--
-- See `:h :packadd`, `:h vim.pack`

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd('packadd! nohlsearch')

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
  -- Quickstart configs for LSP
  'https://github.com/neovim/nvim-lspconfig',
  -- Fuzzy picker
  'https://github.com/ibhagwan/fzf-lua',
  -- Autocompletion
  'https://github.com/nvim-mini/mini.completion',
  -- Enhanced quickfix/loclist
  'https://github.com/stevearc/quicker.nvim',
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',
  -- Keybinding popup
  'https://github.com/folke/which-key.nvim',
  -- base16 colorscheme engine, required by matugen.lua
  'https://github.com/RRethy/base16-nvim',
  -- Treesitter parser manager
  'https://github.com/romus204/tree-sitter-manager.nvim',
  -- Statusline
  'https://github.com/nvim-lualine/lualine.nvim',
  -- File navigation
  'https://github.com/stevearc/oil.nvim',
  -- icons
  'https://github.com/nvim-mini/mini.icons',
  -- lazygit integration
  'https://github.com/kdheepak/lazygit.nvim',
})

require('fzf-lua').setup { fzf_colors = true }
require('mini.completion').setup {}
require('quicker').setup {}
require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end, { desc = 'Next Hunk' })
    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end, { desc = 'Prev Hunk' })
    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[H]unk [S]tage' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[H]unk [R]eset' })
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = '[H]unk [S]tage (selection)' })
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { desc = '[H]unk [R]eset (selection)' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[H]unk [S]tage Buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[H]unk [R]eset Buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[H]unk [P]review (popup)' })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = '[H]unk [I]nline Preview' })
    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end, { desc = '[H]unk [B]lame Line (full)' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = '[H]unk [D]iff Against Index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end, { desc = '[H]unk [D]iff Against Last Commit' })
    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, { desc = '[H]unk [Q]uickfix (all buffers)' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = '[H]unk [Q]uickfix (buffer)' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle Current Line [B]lame' })
    map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle [W]ord Diff' })
  end
}

require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 200,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk' },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
    { '<leader>c', group = '[C]ode' },
    { "<leader>b", group = "Buffers" },
    { "<leader>w", group = "Windows" },
    { "<leader>t", group = "Tabs" },
  }
}
require('tree-sitter-manager').setup({
  auto_install = true,
})

local function oil_copy(kind)
  return function()
    local oil = require('oil')
    local entry = oil.get_cursor_entry()
    local dir = oil.get_current_dir()
    if not entry or not dir then return end

    local value
    if kind == 'abs_path' then
      value = dir .. entry.name
    elseif kind == 'dir' then
      value = dir
    elseif kind == 'rel_path' then
      value = vim.fn.fnamemodify(dir .. entry.name, ':.')
    elseif kind == 'name' then
      value = entry.name
    elseif kind == 'name_no_ext' then
      value = vim.fn.fnamemodify(entry.name, ':r')
    end

    vim.fn.setreg('+', value)
    vim.fn.setreg('"', value)
    vim.notify('Copied: ' .. value, vim.log.levels.INFO)
  end
end

require("oil").setup {
    columns = { 'icon', 'size', 'mtime' },
    keymaps = {
        ['<C-h>'] = 'actions.parent',
        ['<C-l>'] = 'actions.select',
        ['<C-f>'] = {
          callback = function()
            local dir = require('oil').get_current_dir()
            require('fzf-lua').files({ cwd = dir })
          end,
          desc = 'Fuzzy find in current oil directory',
        },
        ['cc'] = { callback = oil_copy('abs_path'),   desc = 'Yank absolute path' },
        ['cd'] = { callback = oil_copy('dir'),         desc = 'Yank directory path' },
        ['cr'] = { callback = oil_copy('rel_path'),    desc = 'Yank relative path' },
        ['cf'] = { callback = oil_copy('name'),        desc = 'Yank file name' },
        ['cF'] = { callback = oil_copy('name_no_ext'), desc = 'Yank file name (no ext)' },
    }
}

require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons() -- compatibility shim for plugins expecting nvim-web-devicons

-- Load base16-colorscheme (matugen.lua is generated by Noctalia)
local ok, matugen = pcall(require, 'matugen')
if ok then matugen.setup() end

require('lualine').setup({
  options = {
    theme = 'base16',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
})

-- fzf-lua
local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })
vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
vim.keymap.set('v', '<leader>sw', fzf.grep_visual, { desc = '[S]earch current [W]ord (selection)' })
vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>so', fzf.oldfiles, { desc = '[S]earch [O]ldfiles (recently opened)' })
vim.keymap.set('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader>sb', fzf.buffers, { desc = '[S]earch existing [B]uffers' })

-- gitsigns
vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>hu', require('gitsigns').undo_stage_hunk, { desc = 'Unstage hunk' })

-- Treesitter config
-- Open TUI with :TSManager. Can uninstall auto-installed parsers from there.
vim.keymap.set('n', '<leader>ct', '<cmd>TSManager<cr>', { desc = '[C]ode [T]reesitter' })

-- LSP config

-- typescript
-- npm install -g typescript-language-server typescript@6
vim.lsp.enable('ts_ls')

-- customize the highlight style LSP reference highlighting uses
vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Visual' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local fzf = require('fzf-lua')
    local buf = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = buf, desc = desc })
    end

    -- Navigation (fuzzy-picker versions of built-ins)
    map('grr', fzf.lsp_references, '[G]oto [R]eferences')
    map('gri', fzf.lsp_implementations, '[G]oto [I]mplementation')
    map('grd', fzf.lsp_definitions, '[G]oto [D]efinition')
    map('grt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')
    map('gO', fzf.lsp_document_symbols, 'Open Document Symbols')
    map('gW', fzf.lsp_live_workspace_symbols, 'Open Workspace Symbols')

    -- Info
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gK', vim.lsp.buf.signature_help, 'Signature Help')

    -- Code-related
    map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'v' })
    map('<leader>cf', function() vim.lsp.buf.format({ async = true }) end, '[C]ode [F]ormat')
    map('<leader>cd', fzf.diagnostics_document, '[C]ode [D]iagnostics (buffer)')
    map('<leader>cD', fzf.diagnostics_workspace, '[C]ode [D]iagnostics (workspace)')

    -- Inlay hints, only if the server supports it
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
      end, '[T]oggle Inlay [H]ints')
    end

    -- Highlight all references to symbol under cursor when your cursor rests there for a little while.
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = buf, group = highlight_group, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = buf, group = highlight_group, callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(evt)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = evt.buf })
        end,
      })
    end
  end,
})

-- oil
local oil = require('oil')
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '<leader>oo', function()
  vim.ui.input({ prompt = 'Path: ' }, function(path)
    if path and path ~= '' then oil.open(path) end
  end)
end, { desc = '[O]il [O]pen path' })
vim.keymap.set('n', '<C-j>', 'j', { desc = 'Move down' })
vim.keymap.set('n', '<C-k>', 'k', { desc = 'Move up' })


-- lazygit
vim.g.lazygit_floating_window_winblend = 0
vim.g.lazygit_floating_window_scaling_factor = 0.95
vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
vim.g.lazygit_use_neovim_remote = 1 -- lets lazygit's internal editor invocations open in your existing nvim instance
vim.keymap.set('n', '<leader>gg', '<Cmd>LazyGit<CR>', { desc = '[G]it (lazygit)' })
vim.keymap.set('n', '<leader>gF', '<Cmd>LazyGitFilter<CR>', { desc = '[G]it log [F]ilter (whole repo)' })
vim.keymap.set('n', '<leader>gc', '<Cmd>LazyGitFilterCurrentFile<CR>', { desc = '[G]it log for [C]urrent file' })
