AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_lab/powerbox01a.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:Use(ply)
	local amount = self:GetStoredMoney()
	
	if amount > 0 then
		ply:AddMoney(amount)
		self:SetStoredMoney(0)
		BaseWars.AddNotification(ply, 3, 'You got '..BaseWars.FormatMoney(amount)..' from a Money Vault.')
	else
		BaseWars.Notify(ply, 1, 5, 'Money Vault is empty!')
	end
end

function ENT:AddStoredMoney(amount)
	local stored = self:GetStoredMoney()

	if stored ~= self.MaxMoney then
		local added = math.Clamp(amount, 0, self.MaxMoney -stored)
		self:SetStoredMoney(stored +added)
	
		return amount -added
	end
end

function ENT:StartTouch(ent)
	if ent:GetClass() == 'bw_money' then
		local left = self:AddStoredMoney(ent:GetAmount())
		
		if left then
			if left ~= 0 then
				ent:SetAmount(left)
			else
				ent:Remove()
			end
		end
	end
end

function ENT:OnRemove()
	local amount = self:GetStoredMoney()
	
	if amount ~= 0 then
		local money = ents.Create('bw_money')
		money:SetAmount(amount)
		money:SetPos(self:GetPos())
		money:Spawn()
	end	
end