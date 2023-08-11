local CollectionService = game:GetService('CollectionService')

local template = game:GetService('ServerStorage').Template
local componentFolder = script.Parent.Components

local PlayerManager = require(game:GetService('ServerScriptService').PlayerManager)

local tycoonStorage = game:GetService('ServerStorage').TycoonStorage 

local function NewModel(model, cframe)
    print(model, cframe)
	local newModel = model:Clone()
	newModel:SetPrimaryPartCFrame(cframe)
	newModel.Parent = workspace
	
	return newModel
end

local Tycoon = {}

Tycoon.__index = Tycoon

function Tycoon.new(player, spawnPoint)
	print(player, spawnPoint)
	local self = setmetatable({}, Tycoon)
	self.Owner = player
	
	self._spawn = spawnPoint
    -- print(self._spawn)
	self._topicEvent = Instance.new('BindableEvent')
	
	return self
end

function Tycoon:Init()
	print(self._spawn)   
	self.Model = NewModel(template, self._spawn) --.CFrame
	--self._spawn:SetAttribute('Occupied', true)
	--self.Owner.RespawnLocation = self.Model.spawn
	--self.Owner:LoadCharacter()
	self:LockAll()
	self:LoadUnlocks()
	self:WaitForExit()
	self:WaitForRebirth()
	
end

function Tycoon:LoadUnlocks()
	for _, id in ipairs(PlayerManager.GetUnlockIds(self.Owner)) do
		self:PublishTopic('Button', id)
	end
end

function Tycoon:AddComponents(instance)
	for _, tag in ipairs(CollectionService:GetTags(instance)) do
		local component = componentFolder:FindFirstChild(tag)
		if component then
			self:CreateComponents(instance, component)
		end
	end
	
end

function Tycoon:LockAll()
	for _, instance in ipairs(self.Model:GetDescendants()) do
		if CollectionService:HasTag(instance, 'unlockable') then
            -- print('if')
			self:Lock(instance)
		else
            -- print('else')
			self:AddComponents(instance)
		end
	end
end

function Tycoon:Unlock(instance, id)
    print(instance, id)
	PlayerManager.AddUnlockId(self.Owner, id)
	
	CollectionService:RemoveTag(instance, 'unlockable')
	self:AddComponents(instance)
	instance.Parent = self.Model
end

function Tycoon:Lock(instance)
	instance.Parent = tycoonStorage
	self:CreateComponents(instance, componentFolder.Unlocked)
end

function Tycoon:CreateComponents(instance, componentScript)
	local compModule = require(componentScript)
	local newComp = compModule.new(self, instance)
	newComp:Init()
	
end

function Tycoon:PublishTopic(topicName, ...)
	--print(topicName, ...)
	self._topicEvent:Fire(topicName, ...)
end

function Tycoon:SubscribeTopic(topicName, callback)
	local connection = self._topicEvent.Event:Connect(function(name, ...)
		if name == topicName then
			callback(...)
		end
	end)
	return connection
end

function Tycoon:WaitForExit()
	PlayerManager.PlayerRemoving:Connect(function(player)
		if self.Owner == player then
			self:Destroy()
		end
	end)
end

function Tycoon:WaitForRebirth()
	self:SubscribeTopic('Button', function(id)
		if id == 'Rebirth' then
			local spawnPoint = self._spawn
			local owner = self.Owner
			
			
			PlayerManager.ClearUnlockIds(owner)
			PlayerManager.SetMoney(owner, 0)
			self:Destroy()
			
			local tyc = Tycoon.new(owner, spawnPoint)
			tyc:Init()
			
			PlayerManager.AddMultiplier(owner, 1.25)
		end
	end)
end

function Tycoon:Destroy()
	self.Model:Destroy()
	--self._spawn:SetAttribute('Occupied', false)
	self._topicEvent:Destroy()
end

return Tycoon