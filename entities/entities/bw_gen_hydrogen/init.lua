AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props/de_nuke/equipment1.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:Use(caller)
	if self:GetTurnedOn() then
		self:EmitSound('ambient/levels/citadel/pod_open1.wav')
		self.EmittedSound:Stop()
		self:SetTurnedOn(false)
	else
		self.EmittedSound = CreateSound(self, 'ambient/levels/citadel/field_loop1.wav')
		self.EmittedSound:SetSoundLevel(65)
		self.EmittedSound:Play()
		self:SetTurnedOn(true)
	end
end

function ENT:OnRemove()
	if self.EmittedSound then 
		self.EmittedSound:Stop() 
	end
end