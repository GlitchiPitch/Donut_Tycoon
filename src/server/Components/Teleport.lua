local Teleport = {}

Teleport.__index = Teleport

function Teleport.new(tycoon,instance)
	local self = setmetatable({}, Teleport)
	self.Tycoon = tycoon
	self.Instance = instance

	self.A = self.Instance.A
	self.B = self.Instance.B
	
	return self
end

function Teleport:CreatePrompt(part)
	local prompt = Instance.new('ProximityPrompt')
    prompt.Parent = part.promptAttachment
	prompt.ActionText = part:GetAttribute('Display')
	prompt.HoldDuration = .5

	return prompt
end

function Teleport:Activated(startPrompt, targetPart)
	startPrompt.Triggered:Connect(function(player)
		local character = player.Character
		if character then
			character:MoveTo(targetPart.promptAttachment.WorldCFrame.Position)
		end
		
	end)
end

function Teleport:Init()
	self:Activated(self:CreatePrompt(self.A), self.B)
	self:Activated(self:CreatePrompt(self.B), self.A)
end

return Teleport
