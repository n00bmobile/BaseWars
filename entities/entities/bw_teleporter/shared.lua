ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.PrintName = 'Teleporter'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 100
-------------------------

hook.Add('PhysgunPickup', 'bw_ents_teleporter_physgun', function(ply, ent)
	return not (ent:GetClass() == 'bw_teleporter' and ent:GetTurnedOn())
end)

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