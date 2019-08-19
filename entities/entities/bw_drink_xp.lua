AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'bw_drink_base'
ENT.PrintName = 'Mysterious Misture'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true

if SERVER then
	ENT.OnDrink = function(ply)
		local amount = math.random(5, 5000)
		ply:AddXP(amount)
		ply:EmitSound('items/gift_drop.wav')
		BaseWars.AddNotification(ply, 3, 'You got '..amount..'XP from a Mysterious Misture.')
	end
end