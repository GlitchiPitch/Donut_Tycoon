local Sounds = {}

Sounds.BackgroundMusic = '9125627017' -- 1846731977
Sounds.BackgroundFx = '9112835068'
Sounds.Udgrade = '9120089728'
Sounds.AddDonut = '9114771714' -- 9113651645
Sounds.Win = '1842300772'
Sounds.DropCopper = '9113305107'
Sounds.GetDonutBox = '9118772457'
Sounds.Sell = '3020841054'
Sounds.BuyStatue = '356817586'

function Sounds.CreateSound(parent, id)
	local sound = Instance.new('Sound')
    sound.Parent = parent
	sound.SoundId = "rbxassetid://" .. id
	sound.Volume = .1
	return sound
end

return Sounds