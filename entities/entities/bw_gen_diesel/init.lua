AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_vehicles/generatortrailer01.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:ToggleMachine(turnOn)
	if turnOn then
		self.EmittedSound = CreateSound(self, 'vehicles/v8/v8_start_loop1.wav')
		self.EmittedSound:SetSoundLevel(60)
		self.EmittedSound:Play()
		self:SetTurnedOn(true)
	else
		self:EmitSound('vehicles/v8/v8_stop1.wav')
		self.EmittedSound:Stop()
		self:SetTurnedOn(false)
	end
end

function ENT:Use()
	if self:GetFuelStored() ~= 0 then
		self:ToggleMachine(not self:GetTurnedOn())
	else
		self:EmitSound('vehicles/v8/v8_stop1.wav')
	end
end

function ENT:OnRemove()
	if self.EmittedSound then 
		self.EmittedSound:Stop() 
	end
end

function ENT:Think()
	if self:GetTurnedOn() then
		if self:GetFuelStored() > 0 then
			self:SetFuelStored(self:GetFuelStored() -1)
		else
			self:ToggleMachine(false)
		end
	end
	
	self:NextThink(CurTime() +1)
	return true
end