local _ = require('moses')
local G = require('constants')
local util = require('util')
local vector = require('vector')
local Item = {}

Item.itemTemplates = require('scenarios/prisonship/items')
Item.itemSets = {}
Item.currentItemSet = {}

function Item:initializeRoom(key)
    self.itemSets[key] = {}
end

function Item:activateRoom(key)
    self.currentItemSet = self.itemSets[key]
end

function Item:remove(uuid)
    self.currentItemSet[uuid] = nil
end

function Item:isItem(uuid)
    return self.currentItemSet[uuid] ~= nil
end

function Item:spawn(key, itemData)
    local items = self.itemSets[key]
    item = {
        uuid = util.uuid(),
        key = itemData.key,
        x = itemData.col * G.TILE_SIZE + G.TILE_SIZE / 2,
        y = itemData.row * G.TILE_SIZE + G.TILE_SIZE / 2,
    }
    items[item.uuid] = item
    return item
end

function Item:pickUp(pickUpperX, pickUpperY)
    local closestItem = nil
    local closestDist = nil
    for uuid, item in pairs(self.currentItemSet) do
        local dist = vector.dist(
            item.x, item.y,
            pickUpperX, pickUpperY
        )
        if dist < G.ITEM_PICKUP_DIST then
            if closestItem == nil or dist < closestDist then
                closestItem = item
                closestDist = dist
            end
        end
    end
    return closestItem
end

return Item
