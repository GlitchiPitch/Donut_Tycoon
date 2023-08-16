local Players = game:GetService('Players')
local DataStoreService = game:GetService('DataStoreService')
local PlayerData = DataStoreService:GetDataStore('PlayerData')
-- local MarketplaceService = game:GetService('MarketplaceService')
-- local Gamepasses = require(game:GetService('ServerScriptService').Gamepasses)

local function Reconcile(source, template)
    -- print(source, template)
	for k, v in pairs(template) do
		-- print(k, v)
		if not source[k] then
			source[k] = v
		end
	end
	return source
end

local function LeaderboardSetup(value)
	
	local hasTycoon = Instance.new('BoolValue')
	hasTycoon.Name = 'hasTycoon'
	
	local leaderstats = Instance.new('Folder')
	leaderstats.Name = 'leaderstats'
	
	local money = Instance.new('IntValue')
    money.Parent = leaderstats
	money.Name = 'Money'
	money.Value = value
	
	return leaderstats, hasTycoon
end

local playerAdded = Instance.new('BindableEvent')
local playerRemoving = Instance.new('BindableEvent')

local function LoadData(player)
	local success, result = pcall(function()
		return PlayerData:GetAsync(player.UserId)
	end)
	
	if not success then
		warn(result)
	end
	return success, result
end

local function SaveData(player, data)
	local success, result = pcall(function()
		PlayerData:SetAsync(player.UserId, data)
	end)
	if not success then
		warn(result)
	end
	return success
end

local sessionData = {}

local playerManager = {}

playerManager.PlayerAdded = playerAdded.Event
playerManager.PlayerRemoving = playerRemoving.Event

function playerManager.Start()
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(playerManager.OnPlayerAdded)(player)
	end
	Players.PlayerAdded:Connect(playerManager.OnPlayerAdded)
	Players.PlayerRemoving:Connect(playerManager.OnPlayerRemoving)
	
	game:BindToClose(playerManager.OnClose)
end

function playerManager.OnPlayerAdded(player)
	-- playerManager.RegisterGamepasses(player)
	
	player.CharacterAdded:Connect(function(character)
		playerManager.OnCharacterAdded(player, character)
	end)
	
	local success, data = LoadData(player)
	-- print(success, data)
	sessionData[player.UserId] = Reconcile( 
		if success then data else {}, --  
		{
			Money = 0,
			UnlockIds = {},
			Multiplier = 1,
		}
	)
	-- print(sessionData)

	local leaderstats, hasTycoon = LeaderboardSetup(playerManager.GetMoney(player))

	leaderstats.Parent = player
	hasTycoon.Parent = player
	
	playerAdded:Fire(player)
end

function playerManager.OnCharacterAdded(player, character)
	local humanoid = character:FindFirstChild('Humanoid')
	if humanoid then
		humanoid.Died:Connect(function()
			wait(3)
			player:LoadCharacter()
		end)
	end
	
end 

function playerManager.GetMoney(player)
	return sessionData[player.UserId].Money
end

function playerManager.SetMoney(player, value)
	if value then
		sessionData[player.UserId].Money = value
		
		local leaderstats = player.leaderstats
		if leaderstats then
			local money = leaderstats.Money
			if money then
				money.Value = value
			end
		end
	end
end

function playerManager.AddMultiplier(player, multiplier)
	sessionData[player.UserId].Multiplier *= multiplier
end

function playerManager.GetMultiplier(player)
	return sessionData[player.UserId].Multiplier
end

function playerManager.AddUnlockId(player, id)
    -- print(player, id)
	local data = sessionData[player.UserId]
    -- print(data)
	
	if not table.find(data.UnlockIds, id) then
		table.insert(data.UnlockIds, id)
	end	
end

function playerManager.ClearUnlockIds(player)
	local data = sessionData[player.UserId]
	
	table.clear(data.UnlockIds)
end

function playerManager.GetUnlockIds(player)
	-- print(sessionData[player.UserId])
	return sessionData[player.UserId].UnlockIds
end

function playerManager.OnPlayerRemoving(player)
	-- print(player)
	SaveData(player, sessionData[player.UserId])
	playerRemoving:Fire(player)
end 

function playerManager.OnClose()
	if game:GetService('RunService'):IsStudio() then return end
	
	for _, player in ipairs(Players:GetPlayers()) do
		playerManager.OnPlayerRemoving(player)
	end
end

-- function playerManager.RegisterGamepasses(player)
-- 	for id, passFunction in pairs(Gamepasses) do
-- 		if MarketplaceService:UserOwnsGamePassAsync(player.UserId, id) then
-- 			passFunction(player)
-- 		end
-- 	end
-- end

return playerManager
