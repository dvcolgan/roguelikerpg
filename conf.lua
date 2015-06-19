function love.conf(t)
    io.stdout:setvbuf("no")
    t.identity = "roguelike"
    t.version = "0.9.2"
    t.console = true

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
    t.window.display = 1
    t.window.highdpi = false
    t.window.srgb = false

    t.modules.physics = false
    t.modules.mouse = false
end
