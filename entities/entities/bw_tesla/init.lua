AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_c17/substation_transformer01d.mdl')
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
	if self:GetTurnedOn() then
		self:SetTurnedOn(false)
	else
		self.ChargingSound = CreateSound(self, 'ambient/energy/electric_loop.wav')
		self:SetTurnedOn(true)
	end
	
	self:EmitSound('buttons/button3.wav')
end

function ENT:Think()
	if not self.ChargingSound then return end
	
	if self:IsPowered() then
		local pitch = self.ChargingSound:GetPitch() 
	
		if pitch == 255 then
			local effect = EffectData()
			effect:SetOrigin(self:GetPos())
			util.Effect('cball_explode', effect)
			self:EmitSound('npc/roller/mine/rmine_explode_shock1.wav')
			self:TakeDamage(10, self:CPPIGetOwner())
			self.ChargingSound:ChangePitch(100, 0)
			self:SetMaterial('')
			
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 150 *self:GetEfficiency())) do
				if v:IsPlayer() and not v:IsAlly(self:CPPIGetOwner()) then
					v:TakeDamage(100 *self:GetEfficiency())
				end
			end
		else
			if pitch > 225 then
				self:SetMaterial('models/alyx/emptool_glow')
			end
			
			self.ChargingSound:PlayEx(1, math.Clamp(pitch +5, 100, 255))
		end
	elseif self.ChargingSound:IsPlaying() then
		self:SetMaterial('')
		self.ChargingSound:Stop()
		self.ChargingSound:ChangePitch(100, 0)
	end
end

function ENT:OnRemove()
	if self.ChargingSound then
		self.ChargingSound:Stop()
	end
end