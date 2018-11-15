AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_junk/popcan01a.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

local drugged = {}

function ENT:Use(caller)
	if drugged[caller] then
		drugged[caller].timeOut(caller)
		drugged[caller] = nil
	end
	
	if self.Duration then
		drugged[caller] = {
			timeOut = self.OnTimeOut,
			ending = CurTime() +self.Duration
		}
	end
	
	self:EmitSound('ambient/levels/canals/toxic_slime_gurgle4.wav')
	self.OnDrink(caller)
	self:Remove()
end

hook.Add('Think', 'bw_ents_drink', function()
	for drinker, data in pairs(drugged) do
		if data.ending <= CurTime() then
			data.timeOut(drinker)
			drinker:EmitSound('vo/npc/male01/moan0'..math.random(1, 5)..'.wav')
			drugged[drinker] = nil
		end
	end
end)