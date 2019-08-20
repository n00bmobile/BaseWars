--[[
--KIND OF DONE:
-Proper leveling.
-Make shit configurable.

Next Version:
-Spawn List in Store Tab
]]

--client
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('cl_hud.lua')
AddCSLuaFile('cl_scoreboard.lua')
AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_menu.lua')
--shared
AddCSLuaFile('config.lua')
AddCSLuaFile('buymenu.lua')
AddCSLuaFile('factions.lua')
AddCSLuaFile('chatsystem.lua')
AddCSLuaFile('objects.lua') 
AddCSLuaFile('notifications.lua') --hl2soung15
AddCSLuaFile('leveling.lua')
AddCSLuaFile('raiding.lua')
AddCSLuaFile('player.lua')

include('shared.lua')
include('config.lua')
include('objects.lua')
include('player.lua')
include('buymenu.lua')
include('factions.lua')
include('chatsystem.lua')
include('notifications.lua')
include('leveling.lua')
include('raiding.lua')

function BaseWars.SaveDatabase(user, data, name)
	if user then
		if not file.Exists('basewars/userdata', 'DATA') then
			if not file.Exists('basewars', 'DATA') then
				file.CreateDir('basewars')
			end
			
			file.CreateDir('basewars/userdata')
		end
		
		file.Write('basewars/userdata/'..string.Replace(user:SteamID(), ':', '_')..'.txt', data)
	else	
		if not file.Exists('basewars', 'DATA') then
			file.CreateDir('basewars')
		end
	
		file.Write('basewars/'..name..'.txt', data)
	end
end

concommand.Add('setowner', function(ply, cmd, args)
	if ply:IsSuperAdmin() then
		local ent = ply:GetEyeTrace().Entity
		
		if not ent:IsPlayer() and not ent:IsWorld() and player.GetAll()[tonumber(args[1])]:IsValid() then
			print('New owner set successfully.')
			ent:CPPISetOwner(player.GetAll()[tonumber(args[1])])
		else
			print('Failed to set owner.')
		end
	end
end)