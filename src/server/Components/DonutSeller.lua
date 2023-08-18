-- local PlayerManager = require(game:GetService('ServerScriptService').PlayerManager)
local Sounds = require(game.ReplicatedStorage.Sounds)

local ServerStorage = game:GetService('ServerStorage')

local itemsFolder = ServerStorage.Items
local Customers = itemsFolder.Customers:GetChildren()

local CUSTOMER_ANIMATION_ID = "http://www.roblox.com/asset/?id=14417243944"
local DONUT_COST = 2

local DonutSeller = {}

DonutSeller.__index = DonutSeller

function DonutSeller.new(tycoon, instance)
	local self = setmetatable({}, DonutSeller)

	self.Tycoon = tycoon
	self.Instance = instance

	self.Rate = instance:GetAttribute('Rate')
	self.Balance = 0
	
	self.DonutCost = DONUT_COST
	
	self.SellSound = Sounds.CreateSound(self.Instance, Sounds.Sell)
	
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
	self.SellSound:Play()
	self.Tycoon:PublishTopic('SellDonut', -1, self.DonutCost)
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
	
	self.Tycoon:SubscribeTopic('Upgrade Seller', function(...)
		self.DonutCost += 2
	end) 
	
	
	coroutine.wrap(function()
		local bool = true
		self.Tycoon:SubscribeTopic('RemoveOwner', function()
			bool = false
		end)
		
		while wait(self.Rate) and bool do
			if self:CheckBalance() then
				self:Sell()
				self:CreateCustomer()
			end
		end
	end)()

end

return DonutSeller
