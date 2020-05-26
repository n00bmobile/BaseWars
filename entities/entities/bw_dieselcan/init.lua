AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_junk/gascan001a.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:OnRemove()
	if self:Health() < 0 then --remover tool does not trigger an explosion
		util.BlastDamage(self, self, self:GetPos(), 200, 200)
	end
end

function ENT:StartTouch(ent)
	if ent:GetClass() == 'bw_gen_diesel' then
		local left = ent:GetFuelStored()
		
		if ent.MaxFuel ~= left then
			local already = self:GetFuelStored()
			local newAmount = math.Clamp(left +already, 0, ent.MaxFuel)
			local left = already -(newAmount -left)
			ent:SetFuelStored(newAmount)

			if left == 0 then
				self:Remove()
			else
				self:SetFuelStored(left)
			end
			
			self:EmitSound('items/battery_pickup.wav')
		end
	end
end