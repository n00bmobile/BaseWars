ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'Mine'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'Armed')
end