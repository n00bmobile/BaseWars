ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.Author = 'n00bmobile'

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'TurnedOn')
	self:NetworkVar('Int', 0, 'PowerStored')
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