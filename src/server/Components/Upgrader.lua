local Upgrader = {}

Upgrader.__index = Upgrader

function Upgrader.new(tycoon, instance)
	local self = setmetatable({}, Upgrader)
	self.Tycoon = tycoon
	self.Instance = instance
	
	self.ParticlePart = instance.particlePart
	
	return self
end

function Upgrader:Init()
	self.Instance.detector.Touched:Connect(function(...)
		self:OnTouch(...)
	end)
end

function Upgrader:OnTouch(hit)
	local worth = hit:GetAttribute('Worth')
	if worth then
		hit:SetAttribute('Worth', worth * self.Instance:GetAttribute('Multiplier'))
		self.ParticlePart.ParticleEmitter.Enabled = true
		task.wait(1)
		self.ParticlePart.ParticleEmitter.Enabled = false
	end
end

return Upgrader
