local class = require('middleclass')
local G = require('constants')


local Editor = class('Editor')

function Editor:initialize(engine)
    self.engine = engine
    self.editing = false
    self.selectedTile = 0
    self.showTiles = false
    self.hoveredRoomTile = {
        col = 0,
        row = 0,
    }
    self.hoveredTilesheetTile = {
        col = 0,
        row = 0,
    }
end

function Editor:onMouseDown(x, y, button)
    if self.editing then
        if self.showTiles then
            local tilesheet = self.engine.images.tilesheetSmall
            self.selectedTile = (self.hoveredTilesheetTile.row-1) * math.floor(tilesheet:getWidth() / G.EDITOR_TILE_SIZE) + self.hoveredTilesheetTile.col
        else
            self.engine:trigger(
                'changeTile',
                self.hoveredRoomTile.col,
                self.hoveredRoomTile.row,
                1,
                self.selectedTile
            )
        end
    end
end

function Editor:onMouseMove(x, y, dx, dy)
    self.hoveredRoomTile.col = math.floor(x / G.TILE_SIZE) + 1
    self.hoveredRoomTile.row = math.floor(y / G.TILE_SIZE) + 1
    self.hoveredTilesheetTile.col = math.floor(x / G.EDITOR_TILE_SIZE) + 1
    self.hoveredTilesheetTile.row = math.floor(y / G.EDITOR_TILE_SIZE) + 1
end

function Editor:onKeyDown(key)
    if key == 'tab' then
        if self.editing then
            self.engine:trigger('giveBackControls')
            self.engine:trigger('resumePhysics')
        else
            self.engine:trigger('takeAwayControls')
            self.engine:trigger('pausePhysics')
        end
        self.editing = not self.editing
    end
    if key == 'lctrl' or key == 'rctrl' then
        self.showTiles = true
    end
end

function Editor:onKeyUp(key)
    if key == 'lctrl' or key == 'rctrl' then
        self.showTiles = false
    end
end

return Editor
