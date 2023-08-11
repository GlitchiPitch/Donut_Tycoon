local PlayerManager = require(game:GetService('ServerScriptService').PlayerManager)

local MAX_LEVEL = 3
local UPGRADE_COST_UP = 100

local UpgradeButton = {}

UpgradeButton.__index = UpgradeButton

function UpgradeButton.new(tycoon, part)
	
	local self = setmetatable({}, UpgradeButton)
	
	self.Tycoon = tycoon
	self.Instance = part
	self.MaxLevel = MAX_LEVEL
	
	self.upgradeValue = 0
	
	return self
end

function UpgradeButton:ChangeLabel()
	self.Instance.BillboardGui.TextLabel.Text = '$' .. self.Instance:GetAttribute('Cost')
end

function UpgradeButton:Init()
	
	self.Instance.Touched:Connect(function(hitPart)
		--print('touched', self.Instance)
		local touchedPlayer = game.Players:GetPlayerFromCharacter(hitPart.Parent)
		--print(touchedPlayer)
		local checkOwner = self.Tycoon.Owner == touchedPlayer
		--print(checkOwner)
		--print(PlayerManager.GetMoney(self.Tycoon.Owner), self.Instance:GetAttribute('Cost'))
		
		local checkMoney = PlayerManager.GetMoney(self.Tycoon.Owner) >= self.Instance:GetAttribute('Cost')
		--print(checkMoney)
		--print(self.upgradeValue)
		
		if checkOwner and checkMoney then
			--print(' touched is good ')
			PlayerManager.SetMoney(self.Tycoon.Owner, PlayerManager.GetMoney(self.Tycoon.Owner) - self.Instance:GetAttribute('Cost'))
			self.Tycoon:PublishTopic(self.Instance:GetAttribute('Display'))
			self.Instance:SetAttribute('Cost', self.Instance:GetAttribute('Cost') + UPGRADE_COST_UP)
			self.upgradeValue += 1
			self:ChangeLabel()
			if self.upgradeValue >= MAX_LEVEL and self.Instance:GetAttribute('Display') == 'Upgrade Seller' then
				self.Instance:Destroy()
			end
		end
	end)
	
	self:ChangeLabel()
	
end

return UpgradeButton
