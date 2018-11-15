include('shared.lua')

function ENT:Draw() 
    self:DrawModel()
end

function ENT:DrawStatus2D()
	local pos = self:GetPos():ToScreen()
	pos.x = pos.x -100

	--background
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(pos.x, pos.y, 200, 116 -40) --115

	--[STATS]--
	--title
	surface.SetDrawColor(0, 255, 0)
	surface.DrawRect(pos.x, pos.y, 200, 20)
	draw.SimpleText('MONEY VAULT', 'ImpactSmall', pos.x +100, pos.y -2, color_white, 1)

	draw.SimpleText('$'..self:GetStoredMoney()..'/$'..self.MaxMoney, 'ImpactMedium', pos.x +100, pos.y +18, color_white, 1)
	
	--health
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(pos.x +5, pos.y +91 -40, 190, 20)
	surface.SetDrawColor(255, 0, 0)
	surface.DrawRect(pos.x +7, pos.y +93 -40, 186 *(self:Health()/self:GetMaxHealth()), 16)
	draw.SimpleText('HEALTH', 'HudHintTextLarge', pos.x +100, pos.y +93 -40, color_white, 1)
end