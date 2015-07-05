function love.conf(t)

    io.stdout:setvbuf("no")
    _G.class = require('30log')
    table.inspect = require('inspect')
    math.randomseed(os.time())

    t.identity = "roguelike"
    t.version = "0.9.2"
    t.console = false

    t.window.title = "Roguelike"
    t.window.icon = nil
    t.window.width = 64*15
    t.window.height = 64*9
    t.window.borderless = false
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.fullscreentype = "normal"
    t.window.vsync = true
    t.window.fsaa = 0
    t.window.display = 2
    t.window.x = 80
    t.window.y = 40
    t.window.highdpi = false
    t.window.srgb = false
end
