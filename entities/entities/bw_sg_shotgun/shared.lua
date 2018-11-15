ENT.Type = 'anim'
ENT.Base = 'bw_sg_base'
ENT.PrintName = 'Sentry Gun (Shotgun)'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 160
ENT.ShotDamage = 80
ENT.ShotDelay = 1
ENT.MaxRange = 100
-------------------------
ENT.GunModel = 'models/weapons/w_shotgun.mdl'
ENT.ShotSound = 'weapons/shotgun/shotgun_fire6.wav'

if SERVER then
	AddCSLuaFile('shared.lua')
	AddCSLuaFile('cl_init.lua')
	util.PrecacheModel(ENT.GunModel)
end
	
