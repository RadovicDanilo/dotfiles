local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ==========================================================================
-- 1. APPEARANCE (High-Contrast Gruvbox)
-- ==========================================================================
config.color_scheme = 'Gruvbox dark, hard (base16)' 
config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 14.0

-- Visual Tuning
config.use_dead_keys = false
config.scrollback_lines = 10000
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.5, -- Dim background splits slightly
}

-- Frame Adjustments
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95

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
