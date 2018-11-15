AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Use()
	self:SetTurnedOn(not self:GetTurnedOn())
	self:EmitSound('buttons/button3.wav')
end

timer.Create('bw_ents_gen_power', 1, 0, function()
	local generators = {}
	local eletronics = {}
	
	for k, v in pairs(ents.GetAll()) do
		if v.MaxPower and not v.UsesPower and v:GetTurnedOn() then
			table.insert(generators, v)
		end
	end
	
	for k, v in pairs(ents.GetAll()) do
		if v.UsesPower and v:GetTurnedOn() then
			eletronics[v:EntIndex()] = 0
		end
	end

	for ind, gen in pairs(generators) do
		local toDistribute = {}
		local powerNeeded = 0
		local leftPower = gen.MaxPower
		
		for entInd, power in pairs(eletronics) do
			local ent = ents.GetByIndex(entInd)
			
			if gen:CPPIGetOwner():IsAlly(ent:CPPIGetOwner()) and gen:GetPos():DistToSqr(ent:GetPos()) <= 500 *500 then
				powerNeeded = powerNeeded +(ent.MaxPower -power)
				toDistribute[entInd] = ent.MaxPower -power
			end
		end
		
		while leftPower ~= 0 and table.Count(toDistribute) ~= 0 do
			for entInd, power in pairs(toDistribute) do
				local clamped = math.Clamp(math.ceil(power *math.Clamp(gen.MaxPower /powerNeeded, 0, 1)), 0, leftPower)
				leftPower = leftPower -clamped
				eletronics[entInd] = eletronics[entInd] +clamped
				toDistribute[entInd] = nil
			end
		end
		
		gen:SetPowerStored(leftPower)
	end
	
	for entInd, power in pairs(eletronics) do
		ents.GetByIndex(entInd):SetPowerStored(power)
	end
end)