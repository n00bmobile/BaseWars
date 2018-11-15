ENT.Type = 'anim'
ENT.Base = 'bw_sg_base'
ENT.PrintName = 'Sentry Gun (Revolver)'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 160
ENT.ShotDamage = 40
ENT.ShotDelay = 2.5
ENT.MaxRange = 800
-------------------------
ENT.GunModel = 'models/weapons/w_357.mdl'
ENT.ShotSound = 'weapons/357/357_fire2.wav'

if SERVER then
	AddCSLuaFile('shared.lua')
	AddCSLuaFile('cl_init.lua')
	util.PrecacheModel(ENT.GunModel)
end