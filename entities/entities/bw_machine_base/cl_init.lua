include('shared.lua')

function ENT:DrawStatus2D()
	local ang = self:GetAngles()
	local pos = self:LocalToWorld(self:OBBCenter()):ToScreen()
	pos.x = pos.x -100

	--background
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(pos.x, pos.y, 200, (73 +22 *#self.StatusBars))

	--[STATS]--
	--title
	surface.SetDrawColor(0, 255, 0)
	surface.DrawRect(pos.x, pos.y, 200, 20)
	draw.SimpleText(string.upper(self.PrintName), 'ImpactSmall', pos.x +100, pos.y -2, color_white, 1)
	
	--energy
	if self:GetTurnedOn() then
		if self.UsesPower and self:GetEfficiency() < 0.4 then
			draw.SimpleText(self:GetPowerStored()..'/'..self.MaxPower, 'ImpactLarge', pos.x +100, pos.y +12, Color(255, 0, 0, math.abs(math.sin(CurTime() *5) *255)), 1)
		else	
			draw.SimpleText(self:GetPowerStored()..'/'..self.MaxPower, 'ImpactLarge', pos.x +100, pos.y +12, color_white, 1)
		end
	else
		draw.SimpleText('OFF', 'ImpactLarge', pos.x +100, pos.y +12, Color(255, 0, 0), 1)
	end

	--bars
	for order, data in pairs(self.StatusBars) do
		surface.SetDrawColor(color_black)
		surface.DrawRect(pos.x +5, pos.y +(70 +22 *(order -1)), 190, 20)
		surface.SetDrawColor(data.color)
		surface.DrawRect(pos.x +7, pos.y +(72 +22 *(order -1)), data.getWidth(self), 16)
		draw.SimpleText(data.name, 'HudHintTextLarge', pos.x +100, pos.y +(72 +22 *(order -1)), color_white, 1)
	end
end