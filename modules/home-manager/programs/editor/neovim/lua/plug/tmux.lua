return {
  'aserowy/tmux.nvim',
  lazy = false,
  opts = {
    copy_sync = {
      enable = true,
      sync_clipboard = false,
    },
    navigation = {
      enable_default_keybindings = false,
    },
    resize = {
      enable_default_keybindings = false,
      resize_step_x = 3,
      resize_step_y = 3,
    },
  },
}
