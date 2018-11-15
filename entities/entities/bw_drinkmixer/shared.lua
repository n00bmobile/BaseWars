ENT.Type = 'anim'
ENT.Base = 'bw_machine_base'
ENT.PrintName = 'Drink Mixer'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.MaxPower = 100
ENT.Cooldown = 600
-------------------------

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'TurnedOn')
	self:NetworkVar('Int', 0, 'PowerStored')
	self:NetworkVar('Int', 1, 'Countdown')
	
	if SERVER then
		self:SetCountdown(self.Cooldown)
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
			name = 'DRINK',
			color = Color(0, 255, 255),
			getWidth = function(ent)
				local countdown = ent:GetCountdown()
				
				if countdown == 0 then
					ent.StatusBars[2].name = 'DRINK READY'
				else
					ent.StatusBars[2].name = 'DRINK ('..string.ToMinutesSeconds(countdown)..')'
				end
				
				return 186 -186 *(countdown /ent.Cooldown)
			end
		}
	}
end