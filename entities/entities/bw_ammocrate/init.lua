AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/items/ammocrate_smg1.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.NextUse = CurTime()

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:OnRemove()
	if self:Health() < 0 then
		util.BlastDamage(self, self, self:GetPos(), 200, 200)
	end
end

function ENT:Use(caller)
	if self.NextUse <= CurTime() then
		local weapon = caller:GetActiveWeapon()
		
		if weapon:GetPrimaryAmmoType() > 0 or weapon:GetSecondaryAmmoType() > 0 then
			if weapon:GetMaxClip1() > 0 then
				caller:GiveAmmo(weapon:GetMaxClip1(), weapon:GetPrimaryAmmoType())
			else
				caller:GiveAmmo(1, weapon:GetPrimaryAmmoType())
			end
			
			if weapon:GetMaxClip2() > 0 then
				caller:GiveAmmo(weapon:GetMaxClip2(), weapon:GetSecondaryAmmoType())
			else
				caller:GiveAmmo(1, weapon:GetSecondaryAmmoType())
			end
			
			self:SetSequence(2)
			self:EmitSound('items/ammocrate_open.wav')
			self.NextUse = CurTime() +self.Cooldown
			timer.Simple(1, function() self:EmitSound('items/ammocrate_close.wav') self:SetSequence(1) end)
		end
	end
end