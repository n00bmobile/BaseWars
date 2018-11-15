AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'bw_drink_base'
ENT.PrintName = 'Low Gravity'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.Duration = 30
-------------------------

if SERVER then
	ENT.OnDrink = function(ply)
		ply:SetGravity(0.1)
	end
	ENT.OnTimeOut = function(ply)
		ply:SetGravity(1)
	end
end