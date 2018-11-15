ENT.Type = 'anim'
ENT.Base = 'bw_sg_base'
ENT.PrintName = 'Sentry Gun (SMG)'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 240
ENT.ShotDamage = 5
ENT.ShotDelay = 0.1
ENT.MaxRange = 500
-------------------------
ENT.GunModel = 'models/weapons/w_smg1.mdl'
ENT.ShotSound = 'weapons/smg1/smg1_fire1.wav'

if SERVER then
	AddCSLuaFile('shared.lua')
	AddCSLuaFile('cl_init.lua')
	util.PrecacheModel(ENT.GunModel)
end

	
