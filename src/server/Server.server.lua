-- local CollectionService = game:GetService('CollectionService')
local Tycoon = require(script.Parent.Tycoon)

local PlayerManager = require(script.Parent.PlayerManager)

--function SetDoors()
--	for _, door in pairs(CollectionService:GetTagged('OwnerDoor')) do
--		door.Touched:Connect(function(hitPart)
--			print(hitPart)
--			local player = game.Players:GetPlayerFromCharacter(hitPart.Parent)
--			print(player, player.hasTycoon.Value, door:GetAttribute('Owner'))
--			if player and not player.hasTycoon.Value and not door:GetAttribute('Owner') then
--				player.hasTycoon.Value = true
--				door.CanTouch = false
--				door:SetAttribute('Owner', player.UserId)
--				local tycoon = Tycoon.new(player, door:GetAttribute('SpawnPoint'))
--				tycoon:Init()
--				door.BillboardGui.TextLabel.Text = player.Name .. "'s" .. ' place'
--			end
--		end)
--	end
--end

--SetDoors()

PlayerManager.Start()

-- game:GetService('Players').PlayerAdded:Connect(function()
--     print("added")
-- end)

for _, o in pairs(workspace.Spawns:GetChildren()) do 
    local tycoon = Tycoon.new(o.CFrame)
    tycoon:Init()
end