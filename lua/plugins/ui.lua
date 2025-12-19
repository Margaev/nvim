return {
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  {
    -- installation: https://github.com/iamcco/markdown-preview.nvim/issues/690
    -- :Lazy load markdown-preview.nvim
    -- :Lazy build markdown-preview.nvim
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      vim.cmd [[
      function! OpenMarkdownPreview(url)
        execute "silent! ! open -a 'Google Chrome' -n --args --new-window " . a:url
      endfunction
      let g:mkdp_browserfunc = 'OpenMarkdownPreview'
      ]]
    end,
    keys = {
      {
        '<leader>tm',
        mode = { 'n', 'v' },
        '<cmd>MarkdownPreview<cr>',
        desc = 'Open MarkdownPreview',
      },
    },
  },

  {
    'sphamba/smear-cursor.nvim',
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      stiffness_insert_mode = 0.7,
      trailing_stiffness_insert_mode = 0.7,
      damping = 0.8,
      distance_stop_animating = 0.5,
    },
  },

  {
    'folke/zen-mode.nvim',
    opts = {},
    keys = {
      {
        '<leader>tz',
        mode = { 'n' },
        function()
          require('zen-mode').toggle {
            window = {
              width = 0.9,
              height = 0.9,
            },
          }
        end,
        desc = '[T]oggle [Z]en Mode',
      },
    },
  },
  {
    'mbbill/undotree',
    keys = {
      {
        '<leader>tu',
        mode = { 'n' },
        '<Cmd>UndotreeToggle<CR><Cmd>UndotreeFocus<CR>',
        desc = '[t]oggle [u]ndo tree',
      },
    },
  },
}
