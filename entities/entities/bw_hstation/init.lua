AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_lab/reciever_cart.mdl')
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
	local health = caller:Health()
	local charge = self:GetChargeStored()
	
	if self:IsPowered() and charge ~= 0 and health < caller:GetMaxHealth() then
		local new = math.Clamp(caller:Health() +charge, 0, caller:GetMaxHealth())
		self:SetChargeStored(charge -(new -health))
		self:EmitSound('items/smallmedkit1.wav')
		caller:SetHealth(new)
	else
		self:SetTurnedOn(not self:GetTurnedOn())
		self:EmitSound('buttons/button3.wav')
	end
end

function ENT:Think()
	if self:IsPowered() and self:GetChargeStored() ~= self.MaxCharge then
		if not self.NextCharge then
			self.NextCharge = CurTime() +self.ChargeDelay
		elseif self.NextCharge <= CurTime() then
			self:SetChargeStored(math.Clamp(self:GetChargeStored() +math.floor(10 *self:GetEfficiency()), 0, self.MaxCharge))
			self.NextCharge = CurTime() +self.ChargeDelay
		end
	else
		self.NextCharge = nil
	end
end