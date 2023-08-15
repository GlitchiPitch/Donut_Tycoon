-- local tycoonStorage = game:GetService('ServerStorage').TycoonStorage 
-- local CollectionService = game:GetService('CollectionService')

local Despawn = {}

Despawn.__index = Despawn

function Despawn.new(tycoon, instance)
	local self = setmetatable({}, Despawn)
	self.Tycoon = tycoon
	self.Instance = instance

	return self
end

function Despawn:Init()
	self.Tycoon:SubscribeTopic('Button', function(id)
		if id == self.Instance:GetAttribute('Id') then
			self.Instance:Destroy()
		-- 	if CollectionService:HasTag(self.Instance, 'unlockable') then
		-- 		self.Instance.Parent = tycoonStorage
		-- 	else
		-- 		self.Instance.Transparency = 1
		-- 		self.Instance.CanTouch = false
		-- 		self.Instance.ProximityPrompt.Enabled = false
		-- 	end
		end
	end)

end


return Despawn
