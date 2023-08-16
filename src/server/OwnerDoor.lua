local Tycoon = require(game:GetService('ServerScriptService').Tycoon)

local OwnerDoor = {}

OwnerDoor.__index = OwnerDoor

function OwnerDoor.new(instance)
	local self = setmetatable({}, OwnerDoor)
	self.Tycoon = Tycoon.new(instance.Parent.PrimaryPart.CFrame)
	self.Instance = instance
	self.Gui = instance.BillboardGui

	-- print(self.Tycoon, self.Instance, self.Gui, self.Instance.Parent)

	return self
end

function OwnerDoor:Init()
	
	self.Instance.Touched:Connect(function(...)
		self:OnTouched(...)
	end)
	self.Tycoon:SubscribeTopic('RemoveOwner', function()
		print('Remove Player')
		print(self.Tycoon.Owner)
		self.Instance:SetAttribute("Owner", 0)
		self.Gui.TextLabel.Text = "Nobody's" .. ' ' .. 'place'
		self.Instance.CanTouch = true
	end)
end

function OwnerDoor:OnTouched(hitPart)
	local humanoid = hitPart.Parent:FindFirstChild("Humanoid")
	local player = game.Players:GetPlayerFromCharacter(humanoid.Parent)
	local hasTycoon = player:FindFirstChild("hasTycoon")
	local ownerAttribute = self.Instance:GetAttribute("Owner")
	-- print(humanoid, player, hasTycoon, ownerAttribute)
	if not hasTycoon.Value and ownerAttribute == 0 then
		self.Tycoon:Init()
		self.Instance.CanTouch = false
		self.Instance:SetAttribute("Owner", player.UserId)
		self.Tycoon.Owner = player
		hasTycoon.Value = true

		self.Gui.TextLabel.Text = player.Name .. "'s" .. ' ' .. 'place'

		self.Tycoon:PublishTopic("Button", self.Instance:GetAttribute("Id"))

		self.Tycoon:LoadUnlocks()
		self.Tycoon:WaitForExit()
		-- self:WaitForRebirth()
	end
end

return OwnerDoor
