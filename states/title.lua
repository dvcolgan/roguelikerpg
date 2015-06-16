return {
    vm={
        speed=300,
        x=0,
        y=0,
        dx=1,
        dy=1,
    },

    update=function(dt, vm)
        vm.x = vm.x + vm.speed * dt * vm.dx
        vm.y = vm.y + vm.speed * dt * vm.dy
        local width = love.window.getWidth()
        local height = love.window.getHeight()

        if vm.x > width then
            vm.x = width - 1
            vm.dx = -vm.dx
        end
        if vm.y > height then
            vm.y = height - 1
            vm.dy = -vm.dy
        end
        if vm.x < 0 then
            vm.x = 1
            vm.dx = -vm.dx
        end
        if vm.y < 0 then
            vm.y = 1
            vm.dy = -vm.dy
        end
    end,

    draw=function(vm)
        love.graphics.setColor(0, 255, 0, 255)
        love.graphics.print('This is the Title Screen', vm.x, vm.y)
    end,
}
