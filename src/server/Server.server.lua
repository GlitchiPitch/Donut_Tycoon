local PlayerManager = require(script.Parent.PlayerManager)
local CollectionService = game:GetService('CollectionService')
local OwnerDoor = require(game:GetService('ServerScriptService').OwnerDoor)

PlayerManager.Start()

for _, o in pairs(CollectionService:GetTagged('OwnerDoor')) do
    local door = OwnerDoor.new(o)
    door:Init()
end
