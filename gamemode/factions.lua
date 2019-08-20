local factions = {}
local meta = FindMetaTable('Player')

function meta:GetFaction()
	for name, data in pairs(factions) do
		if data.owner == self or table.HasValue(data.members, self) then
			return name, data
		end
	end
end

function meta:IsAlly(member)
	if self == member then
		return true
	else
		local name, faction = self:GetFaction()

		if name then
			return table.HasValue(faction.members, member)
		end
	end
end

function BaseWars.GetAllFactions()
	return factions
end

if SERVER then
	--util.AddNetworkString('bw_factions')
	util.AddNetworkString('bw_factions_create')
	util.AddNetworkString('bw_factions_sync')
	
	local function noPassword()
		local filtered = table.Copy(factions)
		
		for name, data in pairs(filtered) do
			if data.password then
				filtered[name].password = nil
				filtered[name].isPublic = false
			else
				filtered[name].isPublic = true
			end
		end
		
		return filtered
	end
	
	local function resync()
		net.Start('bw_factions_sync')
			net.WriteTable(noPassword())
		net.Broadcast()
	end
	
	BaseWars.AddSync('bw_factions_sync', function(ply)
		net.Start('bw_factions_sync')
			net.WriteTable(noPassword())
		net.Broadcast()
	end)
	
	function meta:RemoveFromFaction()
		local name, faction = self:GetFaction()
		
		if name then
			if faction.owner == self then
				for k, v in pairs(faction.members) do
					BaseWars.AddNotification(v, 2, 'The owner has left '..name..'.\nThe faction has been dissipated.')
				end
				
				factions[name] = nil
			else
				BaseWars.AddNotification(self, 1, 'You are no longer part of '..name..'.')
				table.RemoveByValue(factions[name].members, self)
				
				for k, v in pairs(faction.members) do
					BaseWars.AddNotification(v, 1, self:GetName()..' is no longer part of this faction.')
				end
			end
			
			resync()
		end
	end	
	
	function meta:InsertInFaction(name)
		table.insert(factions[name].members, self)
		resync()

		for k, v in pairs(factions[name].members) do
			BaseWars.AddNotification(v, 1, self:GetName()..' has joined the faction.')
		end
	end
	
	function GM:PlayerShouldTakeDamage(ply, att)
		return ply == att or not ply:IsAlly(att)
	end
	
	net.Receive('bw_factions_create', function(len, ply)
		if ply:IsPartakingRaid() or ply:GetFaction() then return end
		
		local name = net.ReadString()
		local password = net.ReadString()
		local color = net.ReadColor()
		
		if #name >= 5 and #name <= 20 and not factions[name] then
			factions[name] = {
				owner = ply, 
				members = {ply}, 
				color = color
			}
			
			if password ~= '' then
				factions[name].password = password
			end
			
			BaseWars.AddNotification(ply, 1, 'You have created '..name..'.')
			resync()
		end
	end)

	net.Receive('bw_factions_sync', function(len, ply)
		if ply:IsPartakingRaid() then return end
		
		local isJoining = net.ReadBool()
		
		if isJoining then
			local name = net.ReadString()
			local faction = factions[name]
			
			if faction then
				if faction.password then
					local entered = net.ReadString()
					
					if faction.password == entered then
						ply:InsertInFaction(name)
					else
						ply:SendLua("Derma_Message('Incorrect Password', 'Notification', 'Ok')")
					end
				else
					ply:InsertInFaction(name)
				end
			end
		else	
			ply:RemoveFromFaction()
			--[[local target = net.ReadEntity()
			
			if target:IsPlayer() then
				local name, faction = ply:GetFaction()
			
				if faction.owner == ply then
					target:RemoveFromFaction()
				end
			else
				ply:RemoveFromFaction()
			end]]
		end
	end)
	
	--[[concommand.Add('factionAdd', function(ply)
		local bot = player.CreateNextBot('Test Dummy')
		
		if bot then
			factions['Terminator'] = {
				owner = bot, 
				members = {bot}, 
				color = ColorRand(),
				password = '123'
			}
			BaseWars.Notify(ply, 0, 5, 'Bot created and added to a faction.')
			resync()
		else
			BaseWars.Notify(ply, 1, 5, 'Failed to create bot!')
		end
	end)]]
return end

net.Receive('bw_factions_sync', function()
	factions = net.ReadTable()
end)