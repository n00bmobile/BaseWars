ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.PrintName = 'Solar Generator'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 150
-------------------------
ENT.UsesPower = false

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