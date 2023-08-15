-- local PlayerManager = require(game:GetService('ServerScriptService').PlayerManager)


local ServerStorage = game:GetService('ServerStorage')

local itemsFolder = ServerStorage.Items
local Customers = itemsFolder.Customers:GetChildren()

local CUSTOMER_ANIMATION_ID = "http://www.roblox.com/asset/?id=14417243944"
local DONUT_COST = 10000

local DonutSeller = {}

DonutSeller.__index = DonutSeller

function DonutSeller.new(tycoon, instance)
	local self = setmetatable({}, DonutSeller)

	self.Tycoon = tycoon
	self.Instance = instance

	self.Rate = instance:GetAttribute('Rate')
	self.Balance = 0
	
	self.UpgradeButton = instance.upgradeSellerButton
	self.upgradeValue = 0
	
	return self
end

function DonutSeller:CreateCustomer()
	local customer = Customers[math.random(#Customers)]:Clone()
	customer.Parent = self.Instance
	customer:PivotTo(self.Instance.spawnCustomer.CFrame * CFrame.new(0,customer:GetExtentsSize().Y/2 - self.Instance.spawnCustomer.Size.Y/2, 0))
	local humanoid = customer:FindFirstChild('Humanoid')
	local animation = humanoid:FindFirstChild('purchase')
	animation.AnimationId = CUSTOMER_ANIMATION_ID
	humanoid:LoadAnimation(animation):Play()
	wait(self.Rate)
	customer:Destroy()
end

function DonutSeller:Sell()
	self.Tycoon:PublishTopic('SellDonut', -1, DONUT_COST)
end

function DonutSeller:ChangeBalance(balance)
	self.Balance = balance
end

function DonutSeller:CheckBalance()
	self.Tycoon:PublishTopic('CheckBalance')
	print(self.Balance)
	if self.Balance > 0 then
		return true
	else
		return false
	end
end

function DonutSeller:Init()
	
	self.Tycoon:SubscribeTopic('GetBalance', function(...)
		self:ChangeBalance(...)
	end) 
	
	coroutine.wrap(function()
		while wait(self.Rate) do
			if self:CheckBalance() then
				self:Sell()
				self:CreateCustomer()
			end
		end
	end)()
end

return DonutSeller
