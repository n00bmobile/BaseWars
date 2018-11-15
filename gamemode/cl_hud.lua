local scrw, scrh = ScrW(), ScrH()

function GM:HUDPaint()
	self.BaseClass:HUDPaint(ply)
	--[ >PLAYER HUD< ]--
	--[HEALTH DISPLAY]--
	--background
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(5, scrh -45, 200, 40)
	--health bar
	local health = LocalPlayer():Health()
	surface.SetDrawColor(color_black)
	surface.DrawRect(10, scrh -40, 190, 30)
	surface.SetDrawColor(255, 0, 0)
	surface.DrawRect(10, scrh -40, math.Clamp(190 *health/LocalPlayer():GetMaxHealth(), 0, 190), 30)
	draw.SimpleText(health, 'Trebuchet24', 105, scrh -37, color_white, 1)
	--armor bar
	surface.SetDrawColor(0, 0, 255)
	surface.DrawRect(10, scrh -12, math.Clamp(190 *LocalPlayer():Armor()/100, 0, 190), 3)
	
	--[MONEY DISPLAY]--
	--money
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(5, scrh -67, 200, 20)
	draw.SimpleText('Account Balance: '..BaseWars.FormatMoney(LocalPlayer():GetMoney()), 'DermaDefault', 105, scrh -63, Color(0, 255, 0), 1)
	--print(LocalPlayer():GetMoney())
	--[LEVEL DISPLAY]--
	local level = LocalPlayer():GetNWInt('level')
	local requirement = LocalPlayer():GetLimitXP()
	--backgroung
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(5, scrh -89, 200, 20)
	--level bar
	surface.SetDrawColor(0, 0, 0) --900 /1500
	surface.DrawRect(7, scrh -87, 196, 16) --1500 -900/1500
	surface.SetDrawColor(0, 255, 0)
	surface.DrawRect(7, scrh -87, 196 *(requirement -LocalPlayer():GetRequiredXP())/requirement, 16)
	--level
	draw.SimpleText('LEVEL '..level..' (XP: '..LocalPlayer():GetNWInt('level_xp')..'/'..requirement..')', 'DermaDefault', 105, scrh -86, color_white, 1)
	
	--[ >FACTION HEALTH DISPLAY< ]--
	local name, faction = LocalPlayer():GetFaction()
	
	if name then
		local passes = 0
	
		for k, v in pairs(faction.members) do
			if v ~= LocalPlayer() then --MAX 8 PLAYERS IN FACTION
				local health = v:Health()
				local x = 210 +(105 *passes) 
				--health bar
				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(x, scrh -25, 100, 20)
				surface.SetDrawColor(color_black)
				surface.DrawRect(x +2, scrh -23, 96, 16)
				surface.SetDrawColor(255, 0, 0)
				surface.DrawRect(x +2, scrh -23, 96 *(health/v:GetMaxHealth()), 16)
				draw.SimpleText(health, 'DermaDefault', x +51, scrh -22, color_white, 1)
				--name (56 char max)
				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(x, scrh -38, 100, 12)
				draw.SimpleText(string.Left(v:GetName(), 56), 'HudHintTextSmall', x +50, scrh -37, color_white, 1)
				passes = passes +1
			end
		end
	end
	
	--[ >PROP PHYSICS HEALTH DISPLAY< ]--
	local ent = LocalPlayer():GetEyeTrace().Entity
	
	if ent:IsValid() then
		if LocalPlayer():GetEyeTrace().HitPos:DistToSqr(LocalPlayer():GetPos())  < 200 *200 then
			if ent:GetClass() == 'prop_physics' and ent:Health() > 0 then
				local pos = ent:GetPos():ToScreen()
				local max = ent:GetMaxHealth()
				local health = ent:Health()
				pos.x = pos.x -50 --put text in middle (for the majority of props)
				--health bar
				surface.SetDrawColor(color_black)
				surface.DrawRect(pos.x, pos.y, 100, 20)
				--surface.SetDrawColor(93, 93, 93)
				--surface.DrawRect(pos.x +2, pos.y +2, 96, 16)
				surface.SetDrawColor(255, 0, 0)
				surface.DrawRect(pos.x +2, pos.y +2, 96 *(health/max), 16)
				draw.SimpleText('Health: '..health..'/'..max, 'DermaDefault', pos.x +50, pos.y +2, color_white, 1)
			elseif ent.IsStatus2D then
				ent:DrawStatus2D()
			end
		end
	end
end

function GM:HUDShouldDraw(name)
	if name == 'CHudHealth' or name == 'CHudBattery' then 
		return false 
	else
		return true
	end
end

function GM:PreDrawHalos()
	local name, faction = LocalPlayer():GetFaction()
	
	if name then
		halo.Add(faction.members, Color(0, 255, 0), 1, 1, 1, true, true)
	end
end