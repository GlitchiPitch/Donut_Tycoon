local Conveyor = {}

Conveyor.__index = Conveyor

function Conveyor.new(tycoon, instance)
	local self = setmetatable({}, Conveyor)
	
	self.Tycoon = tycoon
	self.Instance = instance
	
	self.Speed = instance:GetAttribute('Speed')
	
	return self
	
end

function Conveyor:Init()
	local belt = self.Instance.belt
	print(belt.AssemblyLinearVelocity)
	belt.AssemblyLinearVelocity = belt.CFrame.LookVector * self.Speed
	print(belt.AssemblyLinearVelocity)
end

return Conveyor
