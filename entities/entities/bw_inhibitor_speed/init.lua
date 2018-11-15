AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_c17/TrapPropeller_Engine.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.Targets = {}
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:Use()
	if self:GetTurnedOn() then
		self:SetTurnedOn(false)
	else
		self.EmittedSound = CreateSound(self, 'weapons/physcannon/hold_loop.wav')
		self.EmittedSound:SetSoundLevel(50)
		self:SetTurnedOn(true)
	end
	
	self:EmitSound('buttons/button3.wav')
end

function ENT:OnRemove()
	if not self.EmittedSound then return end
	
	for target, dist in pairs(self.Targets) do
		target:SetWalkSpeed(target:GetWalkSpeed() *4)
		target:SetRunSpeed(target:GetRunSpeed() *4)
	end
	
	self.EmittedSound:Stop()
end

function ENT:Think()
	if not self.EmittedSound then return end
	
	if self:IsPowered() then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), self.MaxRange *self:GetEfficiency())) do
			if v:IsPlayer() and not v:IsAlly(self:CPPIGetOwner()) then
				if not self.Targets[v] then
					v:SetWalkSpeed(v:GetWalkSpeed() /4)
					v:SetRunSpeed(v:GetRunSpeed() /4)
				end
				
				self.Targets[v] = v:GetPos():DistToSqr(self:GetPos())
			end
		end
		
		self.EmittedSound:Play()
	else
		for target, dist in pairs(self.Targets) do
			target:SetWalkSpeed(target:GetWalkSpeed() *4)
			target:SetRunSpeed(target:GetRunSpeed() *4)
		end
		
		self.Targets = {}
		self.EmittedSound:Stop()
	end
	
	for target, dist in pairs(self.Targets) do
		if target:GetPos():DistToSqr(self:GetPos()) > dist then
			target:SetWalkSpeed(target:GetWalkSpeed() *4)
			target:SetRunSpeed(target:GetRunSpeed() *4)
			self.Targets[target] = nil
		end
	end
end