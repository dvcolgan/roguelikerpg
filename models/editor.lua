local G = require('constants')


local Editor = {}
Editor.editing = false
Editor.selectedTile = 0
Editor.showTiles = false
Editor.selectedLayer = 1
Editor.hoveredRoomTile = {
    col = 0,
    row = 0,
}
Editor.hoveredTilesheetTile = {
    col = 0,
    row = 0,
}

function Editor:onMouseDown(x, y, button)
    if self.editing then
        if self.selectedLayer == 0 then
            local collidable
            if button == 'l' then collidable = 1 elseif button == 'r' then collidable = 0 end
            self.engine:trigger(
                'changeCollision',
                self.hoveredRoomTile.col,
                self.hoveredRoomTile.row,
                collidable
            )
        else
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
end

function Editor:onMouseMove(x, y, dx, dy)
    if self.editing then
        self.hoveredRoomTile.col = math.floor(x / G.TILE_SIZE) + 1
        self.hoveredRoomTile.row = math.floor(y / G.TILE_SIZE) + 1
        self.hoveredTilesheetTile.col = math.floor(x / G.EDITOR_TILE_SIZE) + 1
        self.hoveredTilesheetTile.row = math.floor(y / G.EDITOR_TILE_SIZE) + 1
        if self.selectedLayer == 0 then
            local collidable
            local button = nil
            if love.mouse.isDown('l') then button = 'l' end
            if love.mouse.isDown('r') then button = 'r' end
            if button then
                if button == 'l' then collidable = 1 elseif button == 'r' then collidable = 0 end
                self.engine:trigger(
                    'changeCollision',
                    self.hoveredRoomTile.col,
                    self.hoveredRoomTile.row,
                    collidable
                )
            end
        else
            if love.mouse.isDown('l') then
                if not self.showTiles then
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
    end
end

function Editor:onKeyDown(key)
    if key == 'tab' then
        if self.editing then
            self.engine:trigger('giveBackControls')
            self.engine:trigger('resumePhysics')
            self.engine:trigger('saveRoomTemplates')
            self.engine:trigger('roomChange', 0, 0, 0)
        else
            self.engine:trigger('takeAwayControls')
            self.engine:trigger('pausePhysics')
        end
        self.editing = not self.editing
    end

    if not self.editing then return end

    if key == 'lctrl' or key == 'rctrl' then
        self.showTiles = true
    end

    if key == '0' then self.selectedLayer = 0 end
    if key == '1' then self.selectedLayer = 1 end
    if key == '2' then self.selectedLayer = 2 end
    if key == '3' then self.selectedLayer = 3 end
    if key == '4' then self.selectedLayer = 4 end
    if key == '5' then self.selectedLayer = 5 end
    if key == '6' then self.selectedLayer = 6 end
    if key == '7' then self.selectedLayer = 7 end
    if key == '8' then self.selectedLayer = 8 end
    if key == '9' then self.selectedLayer = 9 end

    if key == 'x' then self.engine:trigger('createNewRoom') end
end

function Editor:onKeyUp(key)
    if key == 'lctrl' or key == 'rctrl' then
        self.showTiles = false
    end
end

return Editor
