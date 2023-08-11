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

function OwnerDoor:OnTouched(hit)
	local owner = self.Tycoon.Owner
	local character = hit:FindFirstAncestorWhichIsA('Model')
	local humanoid = character and character:FindFirstChild('Humanoid')
	if humanoid and character ~= owner.Character then
		humanoid:TakeDamage(100)
	end
end

return OwnerDoor
