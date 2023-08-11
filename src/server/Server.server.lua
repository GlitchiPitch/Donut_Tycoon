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



-- wait(1)

print("ok")

game:GetService('Players').PlayerAdded:Connect(function(player)
    print("added")
    PlayerManager.Start()
	local tycoon = Tycoon.new(player, CFrame.new(0,1,0))
	tycoon:Init()
end)