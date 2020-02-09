AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'bw_drink_base'
ENT.PrintName = 'Antidote'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.IsAntidote = true

if SERVER then
	ENT.OnDrink = function(ply)
		ply:EmitSound('vo/npc/male01/moan0'..math.random(1, 5)..'.wav')
	end
end