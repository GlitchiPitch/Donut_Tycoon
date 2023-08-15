local Tycoon = require(script.Parent.Tycoon)
local PlayerManager = require(script.Parent.PlayerManager)
local CollectionService = game:GetService('CollectionService')
local OwnerDoor = require(game:GetService('ServerScriptService').OwnerDoor)

PlayerManager.Start()

for _, o in pairs(CollectionService:GetTagged('OwnerDoor')) do
    -- local tycoon = Tycoon.new(o.Parent.PrimaryPart.CFrame)
    -- tycoon:Init()
    local door = OwnerDoor.new(o)
    door:Init()
end
