--------------------------------------------------------------------------------
-- HYPRLAND LUA CONFIG (Cleaned Mod Syntax)
--------------------------------------------------------------------------------

local term = "ghostty"
local browser = "zen-browser"
local alt_browser = "helium-browser-bin"
local fileman = "nautilus"

--------------------------------------------------------------------------------
-- Monitors
--------------------------------------------------------------------------------
hl.monitor({
  output = "desc:AOC Q27B35E 2S6R6HA008726",
  mode = "2560x1440@144",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "desc:Ancor Communications Inc ASUS VP278 GBLMTF073880",
  mode = "1920x1080@60",
  position = "2560x0",
  scale = 1,
})

--------------------------------------------------------------------------------
-- Environment
--------------------------------------------------------------------------------
hl.env("XCURSOR_SIZE", "18")
hl.env("XCURSOR_THEME", "Vimix-cursors")
hl.env("BROWSER", browser)
hl.env("DE", "generic")

-- NVIDIA
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- Qt / Wayland
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- XDG
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_PICTURES_DIR", "/home/rhosm/Pictures/Screenshots")

-- Other
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

--------------------------------------------------------------------------------
-- Input & Cursor
--------------------------------------------------------------------------------
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "altgr-intl",
    follow_mouse = 1,
    numlock_by_default = true,
    tablet = {
      output = "desc:AOC Q27B35E 2S6R6HA008726",
    },
  },
  cursor = {
    no_warps = false,
    inactive_timeout = 10,
  },
})

--------------------------------------------------------------------------------
-- General Layout & Decoration
--------------------------------------------------------------------------------
hl.config({
 general = {
    gaps_in = 4,
    gaps_out = 4,
    border_size = 2,
    col = {
      active_border = {
        colors = { "rgb(74c7ec)", "rgb(cba6f7)" },
        angle = 0,
      },
      inactive_border = "rgb(11111b)",
    },
 --   layout = "scrolling",
  },
  decoration = {
    rounding = 12,
    active_opacity = 0.98,
    inactive_opacity = 0.95,
    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      xray = true,
    },
  },
})

--------------------------------------------------------------------------------
-- Animations
--------------------------------------------------------------------------------
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.config({
  animations = {
    enabled = true,
  },
})

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 0%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "slidefade 20%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "easeOutQuint", style = "slide" })

--------------------------------------------------------------------------------
-- Autostart
--------------------------------------------------------------------------------
hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("input-remapper-control --command autoload")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("noctalia")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("discord --start-minimized --password-store=basic")
  hl.exec_cmd("hypridle")
end)

--------------------------------------------------------------------------------
-- Keybindings
--------------------------------------------------------------------------------

-- Window management
hl.bind("SUPER + Escape", hl.dsp.window.close())
hl.bind("SUPER + ALT + M", hl.dsp.exit())
hl.bind("SUPER + Z", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen(0))

-- Applications
hl.bind("SUPER + Q", hl.dsp.exec_cmd(term))
hl.bind("SUPER + P", hl.dsp.exec_cmd("ghostty -e btop"))
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + ALT + B", hl.dsp.exec_cmd(alt_browser))
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("foundryvtt"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("discord"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("steam"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("google-chrome https://tidal.com/feed"))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileman .. " " .. os.getenv("HOME")))
hl.bind("SUPER + W", hl.dsp.exec_cmd("gnome-text-editor"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("gnome-calculator"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("input-remapper-gtk"))
hl.bind("SUPER + K", hl.dsp.exec_cmd("krita"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("GDK_BACKEND=x11 rednotebook"))
-- hl.bind("SUPER + F11", hl.dsp.exec_cmd([[awww img "$(find ~/Pictures/Wallpapers -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | shuf -n 1)" --transition-type fade --transition-duration 2]]))
hl.bind("SUPER + F11", hl.dsp.exec_cmd("waypaper"))


-- Noctalia shell
hl.bind("SUPER + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind("SUPER + ALT + H", hl.dsp.exec_cmd("noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet"))

-- Screenshots
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("CTRL + ALT + PRINT", hl.dsp.exec_cmd(fileman .. " /home/rhosm/Pictures/Screenshots"))

-- Navigation & Move windows
-- Direction Focus
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "d" }))

-- Move Windows
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))

-- Workspace switching & moving
for i = 1, 8 do
  hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + Insert", hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + Delete", hl.dsp.focus({ monitor = "r" }))

hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + Insert", hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + Delete", hl.dsp.window.move({ monitor = "r" }))

-- Scrolling & Layout
hl.bind("SUPER + CTRL + Left", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + CTRL + Right", hl.dsp.layout("swapcol r"))
hl.bind("SUPER + SHIFT + F2", hl.dsp.layout("colresize +conf"))

hl.bind("SUPER + F1", hl.dsp.exec_cmd("hyprctl keyword general:layout master"))
hl.bind("SUPER + F2", hl.dsp.exec_cmd("hyprctl keyword general:layout scrolling"))
hl.bind("SUPER + F3", hl.dsp.exec_cmd("hyprctl keyword general:layout dwindle"))

-- Volume & Media Keys (locked = true, repeating = true)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Playback Controls (locked = true)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------------------------------------------------------
-- Workspace Mapping
--------------------------------------------------------------------------------
hl.workspace_rule({ workspace = "1", monitor = "desc:AOC Q27B35E 2S6R6HA008726" })
hl.workspace_rule({ workspace = "2", monitor = "desc:Ancor Communications Inc ASUS VP278 GBLMTF073880" })
hl.workspace_rule({ workspace = "3", monitor = "desc:AOC Q27B35E 2S6R6HA008726" })
hl.workspace_rule({ workspace = "4", monitor = "desc:Ancor Communications Inc ASUS VP278 GBLMTF073880" })
hl.workspace_rule({ workspace = "5", monitor = "desc:AOC Q27B35E 2S6R6HA008726" })
hl.workspace_rule({ workspace = "6", monitor = "desc:Ancor Communications Inc ASUS VP278 GBLMTF073880" })
hl.workspace_rule({ workspace = "7", monitor = "desc:AOC Q27B35E 2S6R6HA008726" })
hl.workspace_rule({ workspace = "8", monitor = "desc:Ancor Communications Inc ASUS VP278 GBLMTF073880" })

--------------------------------------------------------------------------------
-- Window Rules
--------------------------------------------------------------------------------

-- Global & Active Window Opacity
hl.window_rule({
  match = { class = ".*" },
  opacity = 0.95,
})

-- Active Focus Opacity
hl.window_rule({
  match = { focus = true },
  opacity = 1.0,
})

-- App Workspaces
hl.window_rule({
  match = { class = "^(zen)$" },
  workspace = 1,
})

hl.window_rule({
  match = { class = "^(discord)$" },
  workspace = 2,
})

hl.window_rule({
  match = { class = "^(steam)$" },
  workspace = 3,
})

hl.window_rule({
  match = { class = "^(google-chrome)$" },
  workspace = 4,
})

-- Floating Windows
local float_classes = {
  "^(org.quickshell)$",
  "^(org.gnome.Calendar)$",
  "^(org.pulseaudio.pavucontrol)$",
  "^(input-remapper-gtk)$",
  "^(lxqt-policykit-agent)$",
  "^(com.mitchellh.ghostty)$",
  "^(waypaper)$",
}

-- Special Floating Rules for Ghostty

hl.window_rule({
    match = { class = "com.mitchellh.ghostty" },
--    opacity = "1.0",
    size = { 1600, 1000 },
})

for _, cls in ipairs(float_classes) do
  hl.window_rule({
    match = { class = cls },
    float = true,
  })
end

-- Steam Friends List
hl.window_rule({
  match = { class = "^(steam)$", title = "^(Friends List)$" },
  float = true,
  size = { 300, 800 },
})

-- Opacity Fixes & Overrides
hl.window_rule({
  match = { class = "^(io.github.celluloid_player.Celluloid)$" },
  opacity = 1.0,
})

hl.window_rule({
  match = { class = "^(zen)$", title = ".*YouTube.*" },
  opacity = 1.0,
})

hl.window_rule({
  match = { class = "^(krita)$" },
  opacity = 1.0,
})

hl.window_rule({
  match = { class = "^(foundryvtt)$" },
  opacity = 1.0,
})

hl.window_rule({
  match = { class = "^(krita)$", title = "(Docker|Palette|Brush)" },
  float = true,
})

-- Steam Games (Fullscreen client / Workspace 3)
hl.window_rule({
  match = { class = "^(steam_app_.*)$" },
  fullscreen = 1,
  workspace = 3,
})

-- For Noctalia Color templates
require("noctalia").apply_theme()
