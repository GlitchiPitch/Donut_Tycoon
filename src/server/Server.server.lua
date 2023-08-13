local Tycoon = require(script.Parent.Tycoon)
local PlayerManager = require(script.Parent.PlayerManager)

PlayerManager.Start()

for _, o in pairs(workspace.Spawns:GetChildren()) do 
    local tycoon = Tycoon.new(o.CFrame)
    tycoon:Init()
end
