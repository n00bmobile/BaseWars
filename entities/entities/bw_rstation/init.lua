AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

util.PrecacheModel('models/props_c17/tools_wrench01a.mdl')

function ENT:Initialize()
	self:SetModel('models/props_c17/TrapPropeller_Engine.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:Think()
	local target = NULL
	
	if self:IsPowered() then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), self.MaxRange)) do
			if v ~= self and not v:IsPlayer() and v:Health() > 0 and v:Health() < v:GetMaxHealth() then
				if v:CPPIGetOwner():IsAlly(self:CPPIGetOwner()) then
					local tr = util.TraceHull({
						start = self:GetPos() +self:GetAngles():Up() *32,
						endpos = v:GetPos(),
						mins = Vector(-5, -5, -5),
						maxs = Vector(5, 5, 5),
						mask = MASK_SHOT_HULL
					})
					
					if tr.Entity == v then
						target = v
						break
					end
				end
			end
		end
		
		if target:IsValid() then
			target:EmitSound('hl1/fvox/boop.wav', 60, target:Health() /target:GetMaxHealth() *100)
			target:SetHealth(math.Clamp(target:Health() +1, 0, target:GetMaxHealth()))
			
			if target:GetClass() == 'prop_physics' then
				local percentage = math.Clamp(target:Health() /target:GetMaxHealth(), 0, 1)
				target:SetColor(Color(255, 255 *percentage, 255 *percentage))
			end
		end
	end
	
	if self:GetTarget() ~= target then
		self:SetTarget(target)
	end
end