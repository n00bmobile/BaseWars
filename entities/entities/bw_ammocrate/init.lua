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
		
		if not self.WeaponBlacklist[weapon:GetClass()] then
			if weapon:GetPrimaryAmmoType() ~= -1 or weapon:GetSecondaryAmmoType() ~= -1 then
				local clip1 = weapon:GetMaxClip1()
				local clip2 = weapon:GetMaxClip2()
				
				if clip1 > 0 then
					caller:GiveAmmo(clip1 +clip1 *math.Clamp(math.floor((CurTime() -self.NextUse) /self.Cooldown), 0, self.MaxAdditional), weapon:GetPrimaryAmmoType())
				else
					caller:GiveAmmo(1, weapon:GetPrimaryAmmoType())
				end
			
				if weapon:GetMaxClip2() > 0 then
					caller:GiveAmmo(clip2 +clip2 *math.Clamp(math.floor((CurTime() -self.NextUse) /self.Cooldown), 0, self.MaxAdditional), weapon:GetSecondaryAmmoType())
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
end