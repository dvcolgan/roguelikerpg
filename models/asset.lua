local Asset = {}

Asset.images = {
    self.gear = love.graphics.newImage('assets/gear.png')
    self.crosshairs = love.graphics.newImage('assets/crosshairs.png')
    self.tilesheet = love.graphics.newImage('assets/tilesheet.png')
    self.tilesheetSmall = love.graphics.newImage('assets/tilesheet-small.png')
}

return Asset
