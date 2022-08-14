--[[

     AwesomeWM theme
     Created by: brickfrog
     Templating: S4NDM4N

--]]
--{{{ Required libraries.
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local math, string, os = math, string, os
local myTable = awful.util.table or gears.table -- 4.{0,1} compatibility
-- }}}

-- {{{ Theming for wal, kitty, etc. - change wallpaper there

xresources = require("beautiful.xresources")
xrdb = xresources.get_current_theme()

-- }}}

-- {{{ Initiating theme variable.
local theme                                     = {}
-- }}}

-- {{{ Assigning values to theme.
-- Theme config folder
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/eos-default"

--- {{{ Wallpaper
theme.wallpaper = "~/Pictures/Wallpapers/cyberpunk-highlife.jpg"
--- }}}

-- Theme fonts.
theme.font                                      = "Noto Sans Regular 11"
theme.taglist_font                              = "Noto Sans Regular 11"

-- Theme colors.
theme.bg_normal                                 = xrdb.background
theme.bg_focus                                  = xrdb.color12
theme.bg_urgent                                 = xrdb.color9
theme.bg_minimize                               = xrdb.color8
theme.bg_systray                                = theme.bg_normal
theme.fg_normal                                 = xrdb.foreground
theme.fg_focus                                  = theme.bg_normal
theme.fg_urgent                                 = theme.bg_normal
theme.fg_minimize                               = theme.bg_normal
theme.taglist_fg_focus                          = "#FFFFFF"
theme.tasklist_bg_focus                         = xrdb.color1
theme.tasklist_fg_focus                         = "#FFFFFF"
theme.border_normal                             = xrdb.color1
theme.border_focus                              = theme.bg_focus
theme.border_marked                             = xrdb.color10
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus

-- Menu and border widths.
theme.border_width                              = 2
theme.menu_border_width                         = 0
theme.menu_height                               = 25
theme.menu_width                                = 260

-- Icons for the theme.
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note.png"
theme.widget_music_pause                        = theme.dir .. "/icons/pause.png"
theme.widget_music_stop                         = theme.dir .. "/icons/stop.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.widget_task                               = theme.dir .. "/icons/task.png"
theme.widget_scissors                           = theme.dir .. "/icons/scissors.png"
theme.widget_weather                            = theme.dir .. "/icons/dish.png"

-- Tasklist and gap width.
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 2

-- Titalebar icons
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
-- }}}

local markup = lain.util.markup
local separators = lain.util.separators


-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'%a %d %b %R'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = "Noto Sans Mono Medium 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

local tempicon = wibox.widget.imagebox(theme.widget_temp)

-- Audio bar
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

-- Weather
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#FEFEFE", " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " "))
    end
})

-- Spotify
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")	

-- Github 
local github_contributions_widget = require("awesome-wm-widgets.github-contributions-widget.github-contributions-widget")

-- Separators
local arrow = separators.arrow_right

function theme.powerline_rl(cr, width, height)
    local arrow_depth, offset = height/2, 0

    -- Avoid going out of the (potential) clip area
    if arrow_depth < 0 then
        width  =  width + 2*arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset + arrow_depth         , 0        )
    cr:line_to(offset + width               , 0        )
    cr:line_to(offset + width - arrow_depth , height/2 )
    cr:line_to(offset + width               , height   )
    cr:line_to(offset + arrow_depth         , height   )
    cr:line_to(offset                       , height/2 )

    cr:close_path()
end

local function pl(widget, bgcolor, padding)
    return wibox.container.background(wibox.container.margin(widget, 16, 16), bgcolor, theme.powerline_rl)
end

function theme.at_screen_connect(s)
    -- Quake application
   -- s.quake = lain.util.quake({ app = awful.util.terminal })
   s.quake = lain.util.quake({ app = "termite", height = 0.50, argname = "--name %s" })

    -- If wallpaper is a function, call it with the screen
    --local wallpaper = theme.wallpaper
    --if type(wallpaper) == "function" then
    --    wallpaper = wallpaper(s)
    --end
    --gears.wallpaper.maximized(wallpaper, s, true)

    if s == screen.primary then
        os.execute("~/.config/awesome/theming.sh")
    end

    -- All tags open with layout 1
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(myTable.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)
    
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)
    
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 20, bg = theme.bg_normal, fg = theme.fg_normal })
    
    -- Convenience functions
    local separator = wibox.widget.textbox("     ")
    -- not particularly secure, but to prevent key from being put in repo(s) 
    f = io.input(os.getenv('HOME') .. '/.env/weather.pem')
    weather_key = f :read()
    f :close()
    
    -- Might be a better way to do this, but it puts all the widgets on primary montir
    -- except the taglist, which is on all side monitors
    if s == screen.primary then
        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                --spr,
                s.mytaglist,
                s.mypromptbox,
                spr,
            },
            {
                layout = wibox.layout.fixed.horizontal,
                spotify_widget({
                    play_icon = '/usr/share/icons/Papirus/24x24/categories/spotify-client.svg',
                    pause_icon = '/usr/share/icons/Papirus-Dark/24x24/panel/spotify-indicator.svg',
                    max_length = 100,
                    dim_when_paused = true,
                    dim_opacity = 0.1
                }),
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                --using separators
                --arrow(theme.bg_normal, "#343434"),
                -- wibox.container.background(wibox.container.margin(wibox.widget { mailicon, mail and mail.widget, layout = wibox.layout.align.horizontal }, 4, 7), "#343434"),
                --arrow("alpha", xrdb.color12),
                --wibox.container.background(wibox.container.margin(wibox.widget { mpdicon, theme.mpd.widget, layout = wibox.layout.align.horizontal }, 3, 6), xrdb.color12),
                arrow("alpha", xrdb.color12),
                wibox.container.background(wibox.container.margin
                                           (wibox.widget
                                            { memicon, mem.widget, layout = wibox.layout.align.horizontal }, 2, 3), xrdb.color12),
                arrow(xrdb.color12, xrdb.color9),
                wibox.container.background(wibox.container.margin
                                           (wibox.widget
                                            { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }, 3, 4), xrdb.color9),
                --arrow("xrdb.color9", xrdb.color12)
                --wibox.container.background(wibox.container.margin(wibox.widget { tempicon, temp.widget, layout = wibox.layout.align.horizontal }, 4, 4), xrdb.color12),
                --arrow(xrdb.color12,"xrdb.color9"),
                --wibox.container.background(wibox.container.margin(wibox.widget { weathericon, theme.weather.widget, layout = wibox.layout.align.horizontal }, 3, 3), "xrdb.color9"),
                arrow(xrdb.color9, xrdb.color12),
                wibox.container.background(wibox.container.margin
                                           (wibox.widget
                                            { nil, neticon, net.widget, layout = wibox.layout.align.horizontal }, 4, 4), xrdb.color12),
                arrow(xrdb.color12, xrdb.color9),
                wibox.container.background(wibox.container.margin
                                           (clock, 4, 8), xrdb.color9),
                arrow(xrdb.color9, "alpha"),
                --]]
                separator,
                weather_widget({
                    api_key=weather_key,
                    coordinates = {39.0, -84.6},
                    units='imperial',
                    show_hourly_forecast = true,
                    show_daily_forecast = true,
                }),
                separator,
                volume_widget(),
                separator,
                wibox.widget.systray(),
                --s.mylayoutbox,
            },
        }
    else
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                --spr,
                s.mytaglist,
                s.mypromptbox,
                spr,
            },
            nil,
            nil,
        }
    end

    -- Creating the bottom wibox.
    s.mybottomwibox = awful.wibar({ position = "bottom",
                                    screen = s,
                                    border_width = 0,
                                    height = 20,
                                    bg = theme.bg_normal,
                                    fg = theme.fg_normal })

    -- Adding widgets to the bottom wibox.
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
        },
    }

end

return theme
