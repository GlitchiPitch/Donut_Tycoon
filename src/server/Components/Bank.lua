local Players = game:GetService('Players')
local PlayerManager = require(game:GetService('ServerScriptService').PlayerManager)

local START_MAX_BALANCE = 10
local UPGRADE_AMOUNT = 5
local UPGRADE_COST_AMOUNT = 150

local Bank = {}

Bank.__index = Bank

function Bank.new(tycoon, instance)
	local self = setmetatable({}, Bank)

	self.Tycoon = tycoon
	self.Instance = instance
	self.Balance = 0

	self.MaxBalance = START_MAX_BALANCE

	return self
end

function Bank:Init()

	self.Instance.display.money.Text = self.Balance .. '/' .. self.MaxBalance	

	self.Prompt = self:CreatePrompt()
	self.Prompt.Triggered:Connect(function(player)
		self:OnTriggered(player)
	end)

	self.Tycoon:SubscribeTopic('SellDonut', function(worth, salary)
		print('sell')
		self:ChangeMoneyPlayer(salary)
		self:OnWorthChange(worth)
	end)

	self.Tycoon:SubscribeTopic('CheckBalance', function()
		self.Tycoon:PublishTopic('GetBalance', self.Balance)
		--self.Tycoon:PublishTopic('CheckBalance', self.Balance)
	end)


	self.Tycoon:SubscribeTopic('WorthChange', function(...)
		self:OnWorthChange(...)
	end)

	self.Instance.upgradeFridgeButton.Touched:Connect(function(hitPart)
		local char = hitPart:FindFirstAncestorWhichIsA('Model')
		if char:FindFirstChild('Humanoid') and Players:GetPlayerFromCharacter(char) == self.Tycoon.Owner then
			self:Upgrade()
		end

	end)

end

function Bank:Upgrade()
	self.MaxBalance += UPGRADE_AMOUNT
	self.Instance.upgradeFridgeButton:SetAttribute('Cost', self.Instance.upgradeFridgeButton:GetAttribute('Cost') + UPGRADE_COST_AMOUNT)
	print(self.MaxBalance)
	self:SetDisplay(self.Balance .. '/' .. self.MaxBalance)
end

function Bank:OnWorthChange(worth)
	self.Balance += worth
	self:SetDisplay(self.Balance .. '/' .. self.MaxBalance)

end

function Bank:SetDisplay(str)
	self.Instance.display.money.Text = str
end

function Bank:OnTriggered(player)
	if player == self.Tycoon.Owner and self.Balance < self.MaxBalance then
		local donutBox = player.Character:FindFirstChild('DonutBox')
		local currentSalary
		if donutBox then
			currentSalary = self.Balance + donutBox:GetAttribute('CollectionDonut')
			--print(currentSalary)
			donutBox:Destroy()
			if currentSalary > self.MaxBalance then
				print(currentSalary, ' if ')
				currentSalary = self.MaxBalance - self.Balance
			end
			print(currentSalary)
			self.Tycoon:PublishTopic('WorthChange', currentSalary)
		end
	end
end

function Bank:CreatePrompt()
	local prompt = Instance.new('ProximityPrompt')
	prompt.HoldDuration = .5
	prompt.ActionText = self.Instance:GetAttribute("Display")
	prompt.Parent = self.Instance.pad.promptAttachment
	return prompt
end

function Bank:ChangeMoneyPlayer(salary)
	local playerMoney = PlayerManager.GetMoney(self.Tycoon.Owner) + salary
	PlayerManager.SetMoney(self.Tycoon.Owner, playerMoney)
end

return Bank
