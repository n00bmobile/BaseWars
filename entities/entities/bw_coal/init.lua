AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_junk/rock001a.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetColor(Color(60, 60, 60))
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:StartTouch(ent)
	if ent:GetClass() == 'bw_gen_coal' and ent:GetFuelStored() ~= ent.MaxFuel then
		ent:SetFuelStored(ent.MaxFuel)
		self:EmitSound('items/battery_pickup.wav')
		self:Remove()
	end
end