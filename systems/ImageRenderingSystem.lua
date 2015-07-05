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
    love.graphics.draw(image,
        math.floor(entity.position.x - image:getWidth() / 2),
        math.floor(entity.position.y - image:getHeight() / 2)
    )
end

return ImageRenderingSystem
