ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'Money'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'Amount')
end