ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.PrintName = 'Diesel Generator'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 700
ENT.MaxFuel = 300
-------------------------
ENT.UsesPower = false

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'TurnedOn')
	self:NetworkVar('Int', 0, 'PowerStored')
	self:NetworkVar('Int', 1, 'FuelStored')
	
	if SERVER then
		self:SetFuelStored(self.MaxFuel)
	end
end

if CLIENT then
	ENT.StatusBars = {
		[1] = {
			name = 'HEALTH',
			color = Color(255, 0, 0),
			getWidth = function(ent)
				return 186 *(ent:Health() /ent:GetMaxHealth())
			end
		},
		
		[2] = {
			name = 'DIESEL', 
			color = Color(230, 180, 32), 
			getWidth = function(ent) 
				return 186 *(ent:GetFuelStored() /ent.MaxFuel) 
			end
		}
	}
end