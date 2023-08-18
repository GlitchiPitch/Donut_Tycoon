local Sounds = require(game.ReplicatedStorage.Sounds)


local DonutStatue = {}

DonutStatue.__index = DonutStatue

function DonutStatue.new(tycoon, instance)
	local self = setmetatable({}, DonutStatue)
	
	self.Tycoon = tycoon
	self.Instance = instance
	self.Sound = Sounds.CreateSound(self.Instance, Sounds.BuyStatue) 
	
	--self.multiplier = 3
	
	--self.Cost = 10 ^ self.multiplier
		
	return self
end

function DonutStatue:Init()
	self.Sound:Play()
end


return DonutStatue
