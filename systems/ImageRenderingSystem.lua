local ecs = require('tiny')

local ImageRenderingSystem = ecs.processingSystem(class 'ImageRenderingSystem')

function ImageRenderingSystem:init()
    self.filter = ecs.requireAll('transform', 'image')
end

function ImageRenderingSystem:preProcess()
    love.graphics.setColor(255, 255, 255, 255)
end

function ImageRenderingSystem:process(entity, dt)
    local image = assets.images[entity.image]
    local drawX = entity.transform.x
    local drawY = entity.transform.y
    local offsetX = math.floor(image:getWidth() / 2)
    local offsetY = math.floor(image:getHeight() / 2)

    if entity.transform.angle then
        love.graphics.draw(image, drawX, drawY, entity.transform.angle, 1, 1, offsetX, offsetY)
    else
        love.graphics.draw(image, drawX, drawY, 0, 1, 1, offsetX, offsetY)
    end
end

return ImageRenderingSystem
