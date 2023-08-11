local Unlocked = {}

Unlocked.__index = Unlocked

function Unlocked.new(tycoon, instance)
	local self = setmetatable({}, Unlocked)
	
	self.Tycoon = tycoon
	self.Instance = instance
	
	return self
	
end


function Unlocked:Init()
	self.Subscription = self.Tycoon:SubscribeTopic("Button", function(...)
		self:OnButtonPressed(...)	
	end)
end

function Unlocked:OnButtonPressed(id)
	if id == self.Instance:GetAttribute("UnlockId") then
		self.Tycoon:Unlock(self.Instance, id)
		self.Subscription:Disconnect()
	end 
end

return Unlocked
