AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props/cs_assault/money.mdl')
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
	local amount = self:GetAmount()
	self:Remove()
	ply:AddMoney(amount)
	BaseWars.AddNotification(ply, 3, 'You got '..BaseWars.FormatMoney(amount)..' from the ground.')
end