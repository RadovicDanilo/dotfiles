local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ==========================================================================
-- 1. APPEARANCE (Low-glare Gruvbox)
-- ==========================================================================
config.color_scheme = 'Gruvbox dark, soft (base16)'
config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 14.0
config.line_height = 1.1
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 800

-- Visual Tuning
config.use_dead_keys = false
config.scrollback_lines = 50000
config.window_background_opacity = 0.96
config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 10,
}
config.inactive_pane_hsb = {
  saturation = 0.75,
  brightness = 0.65,
}

-- Frame Adjustments
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.audible_bell = 'Disabled'
config.enable_scroll_bar = true
config.tab_bar_at_bottom = true
config.tab_max_width = 28
config.colors = {
  tab_bar = {
    background = '#282828',
    active_tab = {
      bg_color = '#504945',
      fg_color = '#ebdbb2',
    },
    inactive_tab = {
      bg_color = '#3c3836',
      fg_color = '#a89984',
    },
    inactive_tab_hover = {
      bg_color = '#504945',
      fg_color = '#d5c4a1',
    },
  },
}

-- ==========================================================================
-- 2. ERGONOMIC KEYBINDINGS (Split Screen Fix)
-- ==========================================================================
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- Split windows vertically (side-by-side)
  { 
    mods = 'LEADER', 
    key = 'v', 
    action = wezterm.action.SplitPane { direction = 'Right', size = { Percent = 50 } } 
  },
  -- Split windows horizontally (top-and-bottom)
  { 
    mods = 'LEADER', 
    key = 'h', 
    action = wezterm.action.SplitPane { direction = 'Down', size = { Percent = 50 } } 
  },
  -- Close current split pane
  { 
    mods = 'LEADER', 
    key = 'x', 
    action = wezterm.action.CloseCurrentPane { confirm = true } 
  },

  -- Navigation: Move cursor focus across panels with Option/Alt + Home-Row
  { mods = 'ALT', key = 'h', action = wezterm.action.ActivatePaneDirection 'Left' },
  { mods = 'ALT', key = 'l', action = wezterm.action.ActivatePaneDirection 'Right' },
  { mods = 'ALT', key = 'j', action = wezterm.action.ActivatePaneDirection 'Down' },
  { mods = 'ALT', key = 'k', action = wezterm.action.ActivatePaneDirection 'Up' },

  -- Vim Copy Mode Scrollback Trigger (Ctrl + Shift + X)
  { mods = 'CTRL|SHIFT', key = 'X', action = wezterm.action.ActivateCopyMode },
}

return config
