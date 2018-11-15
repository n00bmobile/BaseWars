ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'Money Vault'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxMoney = 50000
-------------------------
ENT.IsStatus2D = true

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'StoredMoney')
end