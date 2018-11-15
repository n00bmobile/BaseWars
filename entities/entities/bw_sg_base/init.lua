AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

util.AddNetworkString('bw_ents_sg')

function ENT:Initialize()
	self:SetModel('models/props_c17/TrapPropeller_Engine.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.NextShot = CurTime()
	self.Target = nil

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

local function communicate(turret, target)
	if target then
		net.Start('bw_ents_sg') 
			net.WriteBool(false)
			net.WriteEntity(turret)
			net.WriteEntity(target)
		net.Broadcast()
	else
		net.Start('bw_ents_sg') 
			net.WriteBool(true)
			net.WriteEntity(turret)
		net.Broadcast()
	end
end

function ENT:Think()
	if self:IsPowered() then
		local target = NULL
		local owner = self:CPPIGetOwner()
		
		for k, v in pairs(ents.FindInSphere(self:GetPos(), self.MaxRange)) do
			if v:IsPlayer() and not v:IsAlly(owner) then
				local tr = util.TraceHull({
					start = self:GetPos() +self:GetAngles():Up() *32,
					endpos = v:GetBonePosition(1),
					mins = Vector(-5, -5, -5),
					maxs = Vector(5, 5, 5),
					mask = MASK_SHOT_HULL
				})
			
				if tr.Entity == v then
					target = v
					break
				end
			end
		end
		
		if self.Target ~= target then
			communicate(self, target)
			self.Target = target
			self:EmitSound('buttons/blip2.wav')
			local delay = CurTime() +SoundDuration('buttons/blip2.wav')
			if self.NextShot <= delay then
				self.NextShot = delay
			end
		end
		
		if self.NextShot <= CurTime() and target:IsValid() then
			communicate(self)
			self.NextShot = CurTime() +self.ShotDelay
			target:TakeDamage(self.ShotDamage *self:GetEfficiency(), self:CPPIGetOwner(), self)
		end
	elseif self.Target ~= NULL then
		communicate(self, NULL)
		self.Target = NULL
	end
	
	self:NextThink(math.Clamp(0.2, 0, self.ShotDelay))
	return true
end