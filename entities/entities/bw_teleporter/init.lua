AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_lab/teleplatform.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:TeleportPlayer(target)
	target:SetPos(self:GetPos() +Vector(0, 0, 5))
	target:SetHealth(target:Health() *self:GetEfficiency())
	
	local data = EffectData()
	data:SetEntity(target)
	data:SetMagnitude(25)
    data:SetScale(5)
	util.Effect('TeslaHitboxes', data, true, true)
	
	local emit = table.Random({'ambient/energy/zap1.wav', 
		'ambient/energy/zap2.wav', 
		'ambient/energy/zap3.wav', 
		'ambient/energy/zap5.wav', 
		'ambient/energy/zap6.wav',
		'ambient/energy/zap7.wav',
		'ambient/energy/zap8.wav',
		'ambient/energy/zap9.wav'
	})
	self:EmitSound(emit)
end

function ENT:Use(ply)
	if not self:GetTurnedOn() then
		local pos = self:GetPos()
		local tr = util.TraceHull({ --effectively evades bought props from spawning outside the map or inside entities.
			start = pos,
			endpos = pos +Vector(0, 0, 5),
			filter = self,
			mins = ply:OBBMins(),
			maxs = ply:OBBMaxs()
		})
		
		if tr.Entity == NULL and util.IsInWorld(tr.HitPos) then
			self:SetTurnedOn(true)
			self:EmitSound('buttons/button3.wav')
			self:GetPhysicsObject():EnableMotion(false)
		else
			self:EmitSound('buttons/weapon_cant_buy.wav')
			BaseWars.Notify(ply, 1, 5, 'Something is obstructing the teleporter!')
		end
	else
		self:SetTurnedOn(false)
		self:EmitSound('buttons/button3.wav')
	end
end

hook.Add('PlayerSpawn', 'bw_ents_teleporter', function(ply)
	for k, v in pairs(ents.FindByClass('bw_teleporter')) do
		if v:CPPIGetOwner() == ply and v:IsPowered() then
			v:TeleportPlayer(ply)
			break
		end
	end
end)