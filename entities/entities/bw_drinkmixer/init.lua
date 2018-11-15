AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_lab/crematorcase.mdl')
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
	if self:GetCountdown() == 0 then
		local ent = ents.Create(table.Random({'bw_drink_damage', 'bw_drink_gravity', 'bw_drink_jump', 'bw_drink_speed'}))
		ent:CPPISetOwner(self:CPPIGetOwner())
		ent:SetPos(self:GetPos())
		ent:Spawn()
		self:SetCountdown(self.Cooldown)
	else
		self:SetTurnedOn(not self:GetTurnedOn())
		self:EmitSound('buttons/button3.wav')
	end
end

function ENT:Think()
	if self:IsPowered() and self:GetCountdown() ~= 0 then
		self:SetCountdown(self:GetCountdown() -1)
		self:NextThink(CurTime() +1)
		return true
	end
end