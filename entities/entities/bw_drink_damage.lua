AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'bw_drink_base'
ENT.PrintName = 'Damage Increase'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values]--
ENT.Duration = 60
-------------------------

if SERVER then
	local active = {}
	
	ENT.OnDrink = function(ply)
		local laugh = CreateSound(ply, 'vo/ravenholm/madlaugh0'..math.random(1, 3)..'.wav')
		laugh:SetSoundLevel(90)
		laugh:SetDSP(24)
		laugh:Play()
		active[ply] = ply:Health()
	end
	ENT.OnTimeOut = function(ply)
		active[ply] = nil
	end

	hook.Add('ScalePlayerDamage', 'bw_ents_drink_damage', function(victim, hitgroup, dmg)
		if victim:IsPlayer() then 
			local attacker = dmg:GetAttacker()
		
			if attacker:IsPlayer() and active[attacker] then
				dmg:ScaleDamage(1 *(active[attacker]/attacker:Health()) *0.5)
			end
		end
	end)
end