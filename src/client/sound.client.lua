local Sounds = require(game.ReplicatedStorage.Sounds)

local bgSound = Instance.new('Sound')
bgSound.Parent = game.SoundService
bgSound.SoundId = "rbxassetid://" .. Sounds.BackgroundMusic
bgSound.Volume = .05

bgSound.Looped = true
bgSound:Play()

local bgSound2 = Instance.new('Sound')
bgSound2.Parent = game.SoundService
bgSound2.SoundId = "rbxassetid://" .. Sounds.BackgroundFx
bgSound2.Volume = .1

bgSound2.Looped = true
bgSound2:Play()