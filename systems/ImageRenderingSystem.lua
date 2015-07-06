local ecs = require('tiny')

local ImageRenderingSystem = ecs.processingSystem(class 'ImageRenderingSystem')

function ImageRenderingSystem:init(images)
    self.images = images
    self.filter = ecs.requireAll('position', 'image')
end

function ImageRenderingSystem:preProcess()
    love.graphics.setColor(255, 255, 255, 255)
end

function ImageRenderingSystem:process(entity, dt)
    local image = self.images[entity.image]
    local drawX = entity.position.x
    local drawY = entity.position.y
    local offsetX = math.floor(image:getWidth() / 2)
    local offsetY = math.floor(image:getHeight() / 2)

    if entity.position.angle then
        love.graphics.draw(image, drawX, drawY, entity.position.angle, 1, 1, offsetX, offsetY)
    else
        love.graphics.draw(image, drawX, drawY, 0, 1, 1, offsetX, offsetY)
    end
end

return ImageRenderingSystem
