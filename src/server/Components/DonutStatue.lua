-- local PlayerManager = require(game:GetService('ServerScriptService').PlayerManager)

local DonutStatue = {}

DonutStatue.__index = DonutStatue

function DonutStatue.new(tycoon, instance)
	local self = setmetatable({}, DonutStatue)
	
	self.Tycoon = tycoon
	self.Instance = instance
	
	--self.UpgradeButton = instance.donutStatueButton
	
	self.multiplier = 3
	
	self.Cost = 10 ^ self.multiplier
		
	return self
end

function DonutStatue:Init()
	--self.Prompt = self:CreatePrompt()
	--self.Prompt.Triggered:Connect(function(plr)
	--	if self.Tycoon.Owner == plr and PlayerManager.GetMoney(self.Tycoon.Owner) >= self.Cost then
			
	--	end
	--end)
end

--function DonutStatue:CreatePrompt()
--	local prompt = Instance.new('ProximityPrompt', self.UpgradeButton)
--	prompt.ActionText = self.UpgradeButton:GetAttribute('Display')
--	prompt.ObjectText = self.UpgradeButton:GetAttribute('Cost')
--end

return DonutStatue
