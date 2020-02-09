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

local users = {}

local function clear(target)
	if users[target] then
		for k, v in pairs(users[target]) do
			v.timeOut(target)
		end

		target:SetNWBool('isDrugged', false)
		users[target] = nil
	end
end

function ENT:Use(caller)
	self:Remove()
	self.OnDrink(caller)
	
	if self.IsAntidote then
		clear(caller)
		return
	end
	
	if self.Duration then
		if users[caller] then
			if table.Count(users[caller]) == 2 then
				caller:Kill()
				return
			end
		else
			users[caller] = {}
		end
		
		local drink = self:GetClass()
		users[caller][drink] = {}
		users[caller][drink].timeOut = self.OnTimeOut
		users[caller][drink].ending = CurTime() +self.Duration
		caller:SetNWBool('isDrugged', true)
	end
	
	caller:EmitSound('ambient/levels/canals/toxic_slime_gurgle4.wav')
end

hook.Add('Think', 'bw_ents_drink_think', function()
	for drinker, data in pairs(users) do
		for drink, ddata in pairs(data) do
			if ddata.ending <= CurTime() then
				if table.Count(data) == 1 then
					drinker:SetNWBool('isDrugged', false)
					drinker:EmitSound('vo/npc/male01/moan0'..math.random(1, 5)..'.wav')
					users[drinker] = nil
				end
				
				ddata.timeOut(drinker)
				users[drinker][drink] = nil
			end
		end
	end
end)

hook.Add('PlayerDeath', 'bw_ents_drink_reset', function(victim)
	clear(victim)
end)