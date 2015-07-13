local ShapeRenderingSystem = class('ShapeRenderingSystem')

function ShapeRenderingSystem:initialize()
    self.components = {'position', 'shape', 'color'}
end

function ShapeRenderingSystem:process(entity, dt)
    love.graphics.setColor(
        entity.color.red,
        entity.color.green,
        entity.color.blue,
        entity.color.alpha
    )
    if entity.shape.kind == 'rectangle' then
        love.graphics.rectangle('fill',
            math.floor(entity.position.x - entity.shape.width / 2),
            math.floor(entity.position.y - entity.shape.height / 2),
            entity.shape.width,
            entity.shape.height
        )
    elseif entity.shape.kind == 'circle' then
        love.graphics.circle('fill',
            entity.position.x,
            entity.position.y,
            entity.shape.radius,
            16
        )
    end
end

return ShapeRenderingSystem
