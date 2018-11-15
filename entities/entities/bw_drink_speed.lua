AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'bw_drink_base'
ENT.PrintName = 'Speed Increase'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.Duration = 30
-------------------------

if SERVER then
	ENT.OnDrink = function(ply)
		ply:SetRunSpeed(ply:GetRunSpeed() *1.5)
	end
	ENT.OnTimeOut = function(ply)
		ply:SetRunSpeed(ply:GetRunSpeed() /1.5)
	end
end