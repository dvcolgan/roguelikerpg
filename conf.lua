function love.conf(t)

    io.stdout:setvbuf("no")
    _G.class = require('lib/30log')
    table.inspect = require('lib/inspect')
    math.randomseed(os.time())

    t.identity = "roguelike"
    t.version = "0.9.2"
    t.console = false

    t.window.title = "Roguelike"
    t.window.icon = nil
    t.window.width = 24*40
    t.window.height = 24*24
    t.window.borderless = false
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.fullscreentype = "normal"
    t.window.vsync = true
    t.window.fsaa = 0
    t.window.display = 2
    t.window.x = 60
    t.window.y = 40
    t.window.highdpi = false
    t.window.srgb = false
end
