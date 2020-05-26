local raid
local meta = FindMetaTable('Player')

function meta:IsPartakingRaid()
	if raid then
		if raid.attacker == self or raid.attacker:IsAlly(self) then
			return 1
		elseif raid.victim == self or raid.victim:IsAlly(self) then
			return 2
		end
	end
end

function meta:IsRaiding(ply)
	return self:IsPartakingRaid() == 1 and ply:IsPartakingRaid() == 2
end

function meta:CanRaid(victim)
	return not raid and self:GetNWFloat('next_raid') <= CurTime() and self:IsRaidable() and victim:IsRaidable()
end

function meta:IsRaidable()
	local value = 0

	for k, v in pairs(ents.GetAll()) do
		if not v:IsPlayer() and v:CPPIGetOwner() == self then
			value = value +v:GetPrice()
		end
	end
	
	return (value >= BaseWars.Config.raid_requirement)
end

function BaseWars.GetRaid()
	return raid
end

if SERVER then
	resource.AddFile('sound/bank_vault/siren.wav')
	util.AddNetworkString('bw_raid_manage')
	util.PrecacheSound('bank_vault/siren.wav')
	
	function BaseWars.StartRaid(victim, attacker)
		local limit = CurTime() +BaseWars.Config.raid_duration
		local name, data = attacker:GetFaction()
		raid = {victim = victim, attacker = attacker}

		net.Start('bw_raid_manage')
			net.WriteBool(true)
			net.WriteEntity(victim)
			net.WriteEntity(attacker) 
			net.WriteFloat(limit)
		net.Broadcast()

		if name then
			for k, v in pairs(data.members) do
				v:SetNWFloat('next_raid', limit +BaseWars.Config.raid_cooldown)
			end
		else
			attacker:SetNWFloat('next_raid', limit +BaseWars.Config.raid_cooldown)
		end
		
		BaseWars.AddSync('bw_raiding_sync', function(ply)
			net.Start('bw_raid_manage')
				net.WriteBool(true)
				net.WriteString(victim)
				net.WriteString(attacker) 
				net.WriteFloat(limit)
			net.Send(ply)
		end)
		timer.Create('bw_raiding_end', BaseWars.Config.raid_duration, 1, function() BaseWars.StopRaid() end)
	end
	
	function BaseWars.StopRaid()
		raid = nil
		net.Start('bw_raid_manage')
			net.WriteBool(false)
		net.Broadcast()
		timer.Remove('bw_raiding_end')
		BaseWars.EndSync('bw_raiding_sync')
		PrintMessage(HUD_PRINTCENTER, 'THE RAID HAS ENDED')
	end
	
	net.Receive('bw_raid_manage', function(len, ply)
		local start = net.ReadBool()
		
		if start then	
			local target = net.ReadEntity()
			
			if ply:CanRaid(target) then
				BaseWars.StartRaid(target, ply)
			end
		elseif ply:IsPartakingRaid() == 1 then
			BaseWars.StopRaid()
		end
	end)
return end

local display
net.Receive('bw_raid_manage', function()
	local started = net.ReadBool()
	
	if started then
		local victim = net.ReadEntity()
		local attacker = net.ReadEntity()
		local time = net.ReadFloat()
		local panel = vgui.Create('DPanel')
		panel:SetPos(ScrW(), 0)
		panel:MoveTo(ScrW() -350, 0, 0.5)
		panel:SetSize(350, 30)
		panel.Paint = function()
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, 350, 30)
		end
		panel.PaintOver = function()
			surface.SetDrawColor(255, 0, 0)
			surface.DrawRect(0, 0, 30, 30)
			draw.SimpleText('!', 'ImpactMedium', 15, -2, color_white, 1)
		end

		local ticker = vgui.Create('AppendableText', panel)
		ticker.FirstText = function()
			ticker.Think = nil
			ticker:ClearText()
			
			local name_att, data_att = attacker:GetFaction()
			local name_vic, data_vic = victim:GetFaction()
			
			if name_att then
				ticker:SetAppendedText(4, name_att, 'ImpactMedium', data_att.color)
			else
				ticker:SetAppendedText(4, attacker:Nick(), 'ImpactMedium', Color(255, 0, 0))
			end
			
			ticker:SetAppendedText(5, ' is raiding ', 'ImpactMedium')
			
			if name_vic then
				ticker:SetAppendedText(6, name_vic, 'ImpactMedium', data_vic.color)
			else
				ticker:SetAppendedText(6, victim:Nick(), 'ImpactMedium', Color(0, 255, 255))
			end

			ticker:SizeToContents()
		end
		ticker.SecondText = function()
			ticker:ClearText()
			ticker:SetAppendedText(1, math.Clamp(math.Round(time -CurTime()), 0, time)..' SECONDS LEFT', 'ImpactMedium')
			ticker:SizeToContents()
			ticker.Think = function()
				ticker:SetAppendedText(1, math.Clamp(math.Round(time -CurTime()), 0, time)..' SECONDS LEFT', 'ImpactMedium')
			end
		end
		ticker.SetAnim = function()
			ticker:SetPos(350, -2)
			ticker:MoveTo(-ticker:GetWide(), -2, 12, 0, 1, function() 
				if not ticker.Think then
					ticker:SecondText()
				else
					ticker:FirstText()
				end
				
				ticker:SetAnim()
			end)
		end
		ticker:FirstText()
		ticker:SetAnim()
		
		display = panel
		raid = {victim = victim, attacker = attacker}
		surface.PlaySound('siren.wav')
	elseif raid then
		raid = nil
		local pending = display
		pending:MoveTo(ScrW(), 0, 0.5, 0, -1, function() pending:Remove() end)
	end
end)