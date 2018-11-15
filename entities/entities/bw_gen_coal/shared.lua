ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.PrintName = 'Coal Generator'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxFuel = 300
ENT.MaxPower = 400
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
			name = 'COAL', 
			color = Color(64, 64, 64), 
			getWidth = function(ent) 
				return 186 *(ent:GetFuelStored() /ent.MaxFuel) 
			end
		}
	}
end