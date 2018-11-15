AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'bw_sg_base'
ENT.PrintName = 'Sentry Gun (Pistol)'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 100
ENT.ShotDamage = 5
ENT.ShotDelay = 0.5
ENT.MaxRange = 500
-------------------------
ENT.GunModel = 'models/weapons/w_pistol.mdl'
ENT.ShotSound = 'weapons/pistol/pistol_fire2.wav'

if SERVER then
	util.PrecacheModel(ENT.GunModel)
end