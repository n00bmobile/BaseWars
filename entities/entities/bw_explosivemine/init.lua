AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_combine/combine_mine01.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:Use()
	self:SetArmed(not self:GetArmed())
	self:EmitSound('buttons/button3.wav')
end

function ENT:Think()
	if not self:GetArmed() then return end
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
		if v:IsPlayer() and not v:IsAlly(self:CPPIGetOwner()) then
			timer.Simple(0.5, function()
				local effect = EffectData()
				effect:SetOrigin(self:GetPos())
				util.Effect('Explosion', effect)
				util.BlastDamage(self, self:CPPIGetOwner(), self:GetPos(), 90, 100)
				self:Remove()
			end)
			
			self:EmitSound('buttons/blip2.wav')
			self:NextThink(CurTime() +1)
			return true
		end
	end
end