local OwnerDoor = {}

OwnerDoor.__index = OwnerDoor

function OwnerDoor.new(tycoon, instance)
	local self = setmetatable({}, OwnerDoor)
	self.Tycoon = tycoon
	self.Instance = instance

	return self
end

function OwnerDoor:Init()
	self.Instance.Touched:Connect(function(...)
		self:OnTouched(...)
	end)
end

function OwnerDoor:OnTouched(hitPart)
	-- print(hitPart)
	local humanoid = hitPart.Parent:FindFirstChild("Humanoid")
	local player = game.Players:GetPlayerFromCharacter(humanoid.Parent)
	local hasTycoon = player:FindFirstChild("hasTycoon")
	local ownerAttribute = self.Instance:GetAttribute("Owner")
	print(humanoid, player, hasTycoon, ownerAttribute)
	if not hasTycoon.Value and ownerAttribute == 0 then
		self.Instance.CanTouch = false
		self.Instance:SetAttribute("Owner", player.UserId)
		self.Tycoon.Owner = player
		hasTycoon.Value = true

		self.Tycoon:PublishTopic("Button", self.Instance:GetAttribute("Id"))

		self.Tycoon:LoadUnlocks()
		self.Tycoon:WaitForExit()
		-- self:WaitForRebirth()
	end
end

return OwnerDoor
