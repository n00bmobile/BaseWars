ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'Diesel Can'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxFuel = 100
-------------------------
ENT.IsStatus2D = false

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'FuelStored')
	
	if SERVER then
		self:SetFuelStored(self.MaxFuel)
	end
end