ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.Author = 'n00bmobile'
ENT.PrintName = 'Repair Station'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 240
ENT.MaxRange = 800
-------------------------

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'TurnedOn')
	self:NetworkVar('Int', 0, 'PowerStored')
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
		}
	}
end