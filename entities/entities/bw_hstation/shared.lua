ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.PrintName = 'Health Station'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 160
ENT.MaxCharge = 100
ENT.ChargeDelay = 5
-------------------------

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'TurnedOn')
	self:NetworkVar('Int', 0, 'PowerStored')
	self:NetworkVar('Int', 1, 'ChargeStored')
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
			name = 'CHARGE', 
			color = Color(0, 255, 255), 
			getWidth = function(ent) 
				return 186 *(ent:GetChargeStored() /ent.MaxCharge) 
			end
		}
	}
end