AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'bw_drink_base'
ENT.PrintName = 'Jump Increase'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.Duration = 30
-------------------------

if SERVER then
	ENT.OnDrink = function(ply)
		ply:SetJumpPower(ply:GetJumpPower() *1.5)
	end
	ENT.OnTimeOut = function(ply)
		ply:SetJumpPower(ply:GetJumpPower() /1.5)
	end
end
