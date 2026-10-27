---@type LazySpec
return {
  {
    'jpalardy/vim-slime',
    init = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_no_mappings = 1
    end,
    keys = {
      { '<leader>S', '<Plug>SlimeMotionSend', mode = 'n', remap = true, desc = 'Send motion' },
      { '<leader>S', '<Plug>SlimeRegionSend', mode = 'x', remap = true, desc = 'Send selection' },
      { '<leader>Sf', ':%SlimeSend<CR>', mode = 'n', desc = 'Send file' },
      { '<leader>Sc', '<cmd>SlimeConfig<CR>', mode = 'n', desc = 'Configure Slime' },
    },
  },
}
