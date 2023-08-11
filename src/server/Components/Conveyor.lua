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
	belt.AssemblyLinearVelocity = belt.CFrame.LookVector * self.Speed
	
end

return Conveyor
