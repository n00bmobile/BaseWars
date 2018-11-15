ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.Author = 'n00bmobile'

ENT.UsesPower = true
ENT.IsStatus2D = true

function ENT:IsPowered()
	return self:GetTurnedOn() and self:GetPowerStored() > 0
end

function ENT:GetEfficiency()
	return self:GetPowerStored() /self.MaxPower
end

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'TurnedOn')
	self:NetworkVar('Int', 0, 'PowerStored')
end