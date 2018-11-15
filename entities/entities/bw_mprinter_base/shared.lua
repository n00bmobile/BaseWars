ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.Author = 'n00bmobile'

ENT.IsStatus2D = false

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'TurnedOn')
	self:NetworkVar('Int', 0, 'PowerStored')
	self:NetworkVar('Int', 1, 'StoredMoney')
	self:NetworkVar('Int', 2, 'PrintSpeed')
	self:NetworkVar('Int', 3, 'PrintCapacity')
	self:NetworkVar('Int', 4, 'MaxStorage')
	
	if SERVER then
		self:SetPrintSpeed(self.BaseSpeed)
		self:SetPrintCapacity(self.BaseCapacity)
		self:SetMaxStorage(self.BaseStorage)
	end
end

function ENT:FindCurrentStats(name)
	for num, data in pairs(self.Upgrades[name]) do
		if name == 'Speed' then
			if self:GetPrintSpeed() == data.value then
				return num
			end
		elseif name == 'Capacity' then
			if self:GetPrintCapacity() == data.value then
				return num
			end
		else
			if self:GetMaxStorage() == data.value then
				return num
			end
		end
	end
	
	return 0
end

function ENT:GetUpgrade(name)
	return self.Upgrades[name][self:FindCurrentStats(name) +1]
end

function ENT:CanUpgrade(name)
	return self.Upgrades[name][self:FindCurrentStats(name) +1]
end