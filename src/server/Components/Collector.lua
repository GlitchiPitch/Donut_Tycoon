local PlayerManager = require(game:GetService('ServerScriptService').PlayerManager)
local itemsFolder = game:GetService('ServerStorage').Items
local Collector = {}

Collector.__index = Collector

function Collector.new(tycoon, instance)
	local self = setmetatable({}, Collector)

	self.Tycoon = tycoon
	self.Instance = instance

	self.CollectionDonut = 0
	self.collectLabel = instance.giver.BillboardGui.donut

	self.DonutBox = itemsFolder.DonutBox

	return self
end

function Collector:Init()

	self.Prompt = self:CreatePrompt()
	self.Prompt.Triggered:Connect(function(player)
		if self.CollectionDonut > 0 then
			self:AddDonutBox(player)
			self.CollectionDonut = 0
			self.collectLabel.Text = 'Collect: ' .. self.CollectionDonut
		end
	end)

	self.Instance.collider.Touched:Connect(function(...)
		self:OnTouched(...)
	end)
end

function Collector:OnTouched(hitPart)
	local worth = hitPart:GetAttribute('Worth')
	if worth then
		local multiplier = self.Tycoon.Owner:GetAttribute('MoneyMultiplier') or 1
		local rebirthMultiplier = PlayerManager.GetMultiplier(self.Tycoon.Owner)
		self.CollectionDonut += worth * multiplier * rebirthMultiplier
		self.collectLabel.Text = 'Collect: ' .. self.CollectionDonut 
		hitPart:Destroy()
	end
end

function Collector:AddDonutBox(player)
	if player == self.Tycoon.Owner and not player.Character:FindFirstChild('DonutBox') then
		local donutBox = self.DonutBox:Clone()
		donutBox.Parent = player.Character
		donutBox:SetAttribute('CollectionDonut', self.CollectionDonut)
	end
end

function Collector:CreatePrompt()
	local prompt = Instance.new('ProximityPrompt')
	prompt.HoldDuration = .5
	prompt.ActionText = 'Collect'  --self.Instance:GetAttribute("Display")
	prompt.Parent = self.Instance.giver.promptAttachment

	return prompt
end

return Collector
