--
-- Please note not all available settings / options are set here.
-- For a full list, see the wiki
--

-- See https://wiki.hypr.land/configuring/core/monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "2560x1600@165",
    position = "0x0",
    scale    = 1,
    mirror   = "DP-1",
})
-- hl.monitor({ output = "DP-1", mode = "preferred", position = "2880x0", scale = 1 })
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
    mirror   = "eDP-1",
})

local colors = require("hypr-colors")

-- See https://wiki.hypr.land/configuring/ for more

-- Execute your favorite apps at launch
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

-- Set programs that you use
local terminal    = "ghostty"
local fileManager = "thunar"
-- local menu     = "rofi -modi drun,run -show drun"
local menu        = "bash ~/.config/rofi/launchers/type-5/launcher.sh"

-- Some default env vars.
local home = os.getenv("HOME") or "/home/py"
hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GTK_THEME", "Materia-dark")
hl.env("BROWSER", "vivaldi-stable.desktop")
hl.env("XDG_DATA_DIRS", home .. "/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share")
hl.env("_JAVA_OPTIONS", "-Dsun.java2d.uiScale=2")

-- For all categories, see https://wiki.hypr.land/configuring/core/config-options/
hl.config({
    debug = {
        disable_logs = false,
    },

    input = {
        kb_layout = "us",
        -- kb_variant = "",
        -- kb_model = "",
        -- kb_options = "",
        -- kb_rules = "",

        follow_mouse = 1,
        -- mouse_refocus = false, -- so zoom menus dont disappear when hover
        scroll_factor = 1.1,

        touchpad = {
            clickfinger_behavior = true,
            natural_scroll       = false,
            disable_while_typing = true,
            tap_to_click         = true,
        },

        sensitivity = 0.1, -- -1.0 - 1.0, 0 means no modification.
    },

    general = {
        -- See https://wiki.hypr.land/configuring/core/config-options/ for more

        gaps_in     = 2, -- 3
        gaps_out    = 0,
        border_size = 0, -- formerly 3
        col = {
            active_border   = { colors = { colors.color13, colors.color11 }, angle = 270 },
            inactive_border = colors.color6,
        },

        layout = "dwindle",

        -- Please see https://wiki.hypr.land/configuring/extra/tearing/ before you turn this on
        allow_tearing = false,
    },

    decoration = {
        -- See https://wiki.hypr.land/configuring/core/config-options/ for more

        rounding = 8,

        blur = {
            enabled = false,
            size    = 9,
            passes  = 3,
            xray    = true,
        },

        -- shadow = {
        --     enabled      = false,
        --     range        = 4,
        --     render_power = 3,
        --     color        = 0xee1a1a1a,
        -- },
        dim_inactive = false,
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        -- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/ for more
        preserve_split = true, -- you probably want this
    },

    master = {
        -- See https://wiki.hypr.land/configuring/layouts/master-layout/ for more
        -- new_is_master = true,
        new_status = "slave",
    },

    scrolling = {
        -- See https://wiki.hypr.land/configuring/layouts/scrolling-layout/ for more
        fullscreen_on_one_column = true,
        column_width             = 0.9,
        direction                = "right",
    },

    misc = {
        -- See https://wiki.hypr.land/configuring/core/config-options/ for more
        force_default_wallpaper = 0, -- Set to 0 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true,
        -- focus_on_activate = true,
    },

    xwayland = {
        enabled            = true,
        force_zero_scaling = true,
    },
})

-- Some default animations, see https://wiki.hypr.land/configuring/core/animations/ for more
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 },  { 0.1, 1.1 } } })
hl.curve("boBez",    { type = "bezier", points = { { 0.49, -0.05 }, { 0.66, 1.0 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,    bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,    bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 0.01, bezier = "myBezier" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 0.01, bezier = "boBez",    style = "loop" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,    bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,    bezier = "default" })

-- Workspace 9 scrolling layout rule
hl.workspace_rule({
    workspace = "9",
    layout    = "scrolling",
})

-- Example per-device config
-- See https://wiki.hypr.land/configuring/core/devices/ for more
hl.device({
    name          = "m720-triathlon-mouse",
    sensitivity   = -0.3, -- -1.0 - 1.0, 0 means no modification.
    accel_profile = "custom",
    scroll_points = "0.2 0.0 0.5 1 1.2 1.5",
})

-- See https://wiki.hypr.land/configuring/core/rules/ for more
-- hl.window_rule({
--     name           = "suppress-maximize-events",
--     match          = { class = ".*" },
--     suppress_event = "maximize",
-- })

hl.window_rule({
    name  = "VSC Recent Picker Float",
    match = { class = "^(kitty-rec)$" },
    float = true,
    size  = "(0.35*monitor_w) (0.30*monitor_h)",
})

-- Rules for the GTK File Picker Portal
hl.window_rule({
    name        = "GTK File Picker Portal",
    match       = { class = "^(xdg-desktop-portal-gtk)$" },
    float       = true,
    size        = "(0.5*monitor_w) (0.5*monitor_h)",
    center      = true,
    border_size = 0,
})

hl.window_rule({
    name        = "Rofi",
    match       = { class = "^(Rofi)$" },
    float       = true,
    size        = "(0.5*monitor_w) (0.5*monitor_h)",
    center      = true,
    border_size = 0,
})

hl.window_rule({
    name   = "Polyscope",
    match  = { class = "^(Polyscope)$" },
    float  = true,
    size   = "(0.5*monitor_w) (0.5*monitor_h)",
    center = true,
})


-- See https://wiki.hypr.land/configuring/core/binds/ for more
-- local mainMod = "ALT"
local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("ALT + F4",             hl.dsp.window.close())
-- hl.bind(mainMod .. " + M",   hl.dsp.exit())
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE",  hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd("bash ~/.config/rofi/launchers/type-1/launcher.sh"))
hl.bind(mainMod .. " + Q",      hl.dsp.exec_cmd('kitty --override remember_window_size=no --class="kitty-rec" "/home/py/.config/hypr/vscrp/vscrp.sh"'))
-- hl.bind(mainMod .. " + P",   hl.dsp.window.pseudo()) -- dwindle

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",        hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize Window
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 70,  y = 0,   relative = true }))
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.resize({ x = -70, y = 0,   relative = true }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.resize({ x = 0,   y = -70, relative = true }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.resize({ x = 0,   y = 70,  relative = true }))

-- Eww Bar
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("ps -e | grep -q '[e]ww' && eww close bar || eww open bar"))

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),             { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),            { repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),          { repeating = true })

-- Screen brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })
hl.bind("code:232",              hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })
hl.bind("code:233",              hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
hl.bind("code:192",              hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })
hl.bind("code:191",              hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })

-- Keyboard brightness
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("brightnessctl --device='asus::kbd_backlight' set +1"), { repeating = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("brightnessctl --device='asus::kbd_backlight' set 1-"), { repeating = true })

-- Screenshot - Save / Clipboard
hl.bind("Print",             hl.dsp.exec_cmd("/usr/local/bin/screen"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("/usr/local/bin/screen"))

-- Fullscreen
-- maximized makes it "fake fullscreen". This is here so then vivaldi can full screen while on vivaldi without
-- having all the UI disappear
-- I believe this is a chromium + wayland issue. See here: https://issues.chromium.org/issues/374101953/resources
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- Suspend
hl.bind("SUPER + F12", hl.dsp.exec_cmd("systemctl suspend"))

-- Autostart (Notifications, GNOME Keyring, Portals)
hl.on("hyprland.start", function()
    hl.exec_cmd("dunst &")
    hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
end)

-- Cursor submap for wl-kbptr
hl.define_submap("cursor", function()
    -- Jump cursor to a position
    hl.bind("a", hl.dsp.exec_cmd("hyprctl dispatch submap reset && wl-kbptr && hyprctl dispatch submap cursor"))

    -- Cursor movement
    hl.bind("j", hl.dsp.exec_cmd("wlrctl pointer move 0 20"),  { repeating = true })
    hl.bind("k", hl.dsp.exec_cmd("wlrctl pointer move 0 -20"), { repeating = true })
    hl.bind("l", hl.dsp.exec_cmd("wlrctl pointer move 20 0"),  { repeating = true })
    hl.bind("h", hl.dsp.exec_cmd("wlrctl pointer move -20 0"), { repeating = true })

    -- Left, Middle, Right button
    hl.bind("s", hl.dsp.exec_cmd("wlrctl pointer click left"))
    hl.bind("d", hl.dsp.exec_cmd("wlrctl pointer click middle"))
    hl.bind("f", hl.dsp.exec_cmd("wlrctl pointer click right"))

    -- Scroll up and down
    hl.bind("e", hl.dsp.exec_cmd("wlrctl pointer scroll 20 0"),  { repeating = true })
    hl.bind("r", hl.dsp.exec_cmd("wlrctl pointer scroll -20 0"), { repeating = true })

    -- Scroll left and right
    hl.bind("t", hl.dsp.exec_cmd("wlrctl pointer scroll 0 -20"), { repeating = true })
    hl.bind("g", hl.dsp.exec_cmd("wlrctl pointer scroll 0 20"),  { repeating = true })

    -- Exit cursor submap
    hl.bind("escape", function()
        hl.config({ cursor = { inactive_timeout = 3 } })
        hl.dispatch(hl.dsp.submap("reset"))
        hl.notification.create({
            text      = "Cursor Mode Disabled",
            timeout   = 2000,
            color     = 0xfffff000,
            font_size = 20,
        })
    end)
end)

hl.bind(mainMod .. " + g", function()
    hl.config({ cursor = { inactive_timeout = 0 } })
    hl.dispatch(hl.dsp.submap("cursor"))
    hl.notification.create({
        text      = "Cursor Mode Enabled",
        timeout   = 5000,
        color     = 0xffff0000,
        font_size = 20,
    })
end)

hl.bind(mainMod .. " + c", hl.dsp.exec_cmd("wl-kbptr -o modes=tile,click"))

-- Gestures
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
-- hl.gesture({ fingers = 3, direction = "up",   action = "dispatcher", dispatcher = "togglefloating" })
-- hl.gesture({ fingers = 3, direction = "down", action = "dispatcher", dispatcher = "togglefloating" })

-- Scrolling workspaces
hl.bind(mainMod .. " + period",         hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + comma",          hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.layout("swapcol l"))
