ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.PrintName = 'Radar Tower'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 100
ENT.MaxCharge = 30
ENT.ChargeDelay = 10
-------------------------

function ENT:CanScan()
	return self:IsPowered() and self:GetChargeStored() >= 5 -math.floor(4 *self:GetEfficiency())
end

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'TurnedOn')
	self:NetworkVar('Int', 0, 'PowerStored')
	self:NetworkVar('Int', 1, 'ChargeStored')
	self:NetworkVar('Entity', 0, 'Target')
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