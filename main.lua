local Engine = require('lib/eventengine')


function love.load()
    engine = Engine:new()
    engine:addModels({
        player=require('models/player'),
        key=require('models/key'),
        bulletManager=require('models/bullet-manager'),
        camera=require('models/camera'),
    })
    engine:addStates({
        --title=require('states/title'),
        overworld=require('states/overworld'),
    })
    engine:setState('overworld', {doUpdate=true, doDraw=true})
end


function love.draw()
    engine:draw()
end


function love.update(dt)
    engine:update(dt)
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        if key == ' ' then key = 'space' end
        if key == ',' then key = 'comma' end
        engine:trigger('keyDown', key)
    end
end


function love.keyreleased(key)
    if key == ' ' then key = 'space' end
    if key == ',' then key = 'comma' end
        engine:trigger('keyUp', key)
end


--[[
drawPlayer = (ctx, player) ->
    animation = animationStore.getForPlayer(player.username)
    if not animation? then return

    scalingFactor = screenStore.getScalingFactor()

    stateData = animation.states[animation.state]

    # Make sure the animation component was set up correctly
    if window.DEBUG
        if (animation.spritesheet.width % animation.frameWidth != 0 or
                animation.spritesheet.height % animation.frameHeight != 0)
            throw new Error(
                "Animation with spritesheet #{
                    animation.spritesheet.src
                } has frameWidth/Height that doesn't divide evenly."
            )

    # Do black magic math on numbers to draw the animation
    # in the right place with the right frame
    framesWide = animation.spritesheet.width / animation.frameWidth
    framesHigh = animation.spritesheet.height / animation.frameHeight

    sheetX = Math.floor((animation.currentFrame % framesWide) * animation.frameWidth)
    sheetY = Math.floor(stateData.row * animation.frameHeight)

    offsetX = Math.floor(animation.frameWidth * stateData.anchor.x)
    offsetY = Math.floor(animation.frameHeight * stateData.anchor.y)

    screenX = Math.floor((player.x * scalingFactor) - screenStore.scroll.x)
    screenY = Math.floor((player.y * scalingFactor) - screenStore.scroll.y)

    drawX = screenX - offsetX
    drawY = screenY - offsetY

    ctx.drawImage(
        animation.spritesheet
        sheetX
        sheetY
        animation.frameWidth
        animation.frameHeight
        drawX
        drawY
        animation.frameWidth * scalingFactor
        animation.frameHeight * scalingFactor
    )

    ctx.fillStyle = 'white'
    ctx.textAlign = 'center'
    ctx.font = '20px arial'
    ctx.fillText(player.username, screenX, screenY - 26)
end
]]--
