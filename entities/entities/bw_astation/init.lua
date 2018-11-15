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
	local armor = caller:Armor()
	local charge = self:GetChargeStored()
	
	if self:IsPowered() and charge ~= 0 and armor < self.MaxCharge then
		local new = math.Clamp(armor +charge, 0, self.MaxCharge)
		self:SetChargeStored(charge -(new -armor))
		self:EmitSound('items/suitchargeok1.wav')
		caller:SetArmor(new)
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