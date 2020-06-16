hook.Add('PhysgunPickup', 'bw_gm_sandboxhooksworkaround_physgunpickup', function(ply, ent) --i'll fix this later...
	if ent:GetMaxHealth() > 0 and ent:Health() <= 0 then
		return false
	end
end)

if CLIENT then return end

function GM:EntityTakeDamage(ent, dmg)
	if not ent:IsPlayer() and ent:GetMaxHealth() > 0 then
		local owner = ent:CPPIGetOwner()

		if owner then
			local att = dmg:GetAttacker()
			local raider = (att:IsPlayer() and att:IsRaiding(owner))
			
			if not raider then 
				dmg:ScaleDamage(BaseWars.Config.raid_dmg_penalty_percentage)
			end

			if ent:GetClass() ~= 'prop_physics' then
				ent:SetHealth(ent:Health() -dmg:GetDamage())
				
				if not ent.HasExploded and ent:Health() <= 0 then
					if raider then
						att:AddXP(BaseWars.Config.raid_reward_xp_ent)
						att:AddMoney(BaseWars.Config.raid_reward_ent) 
						BaseWars.AddNotification(att, 3, "You've been rewarded "..BaseWars.FormatMoney(BaseWars.Config.raid_reward_ent)..' and '..BaseWars.Config.raid_reward_xp_ent..'XP for destroying '..ent.PrintName..'!')
					end
				
					ent.HasExploded = true
					local price = ent:GetPrice() *BaseWars.Config.price_refund_percentage
					owner:AddMoney(price)
					BaseWars.AddNotification(owner, 2, 'You got '..BaseWars.FormatMoney(price)..' for your destroyed '..(ent.PrintName or 'Object')..'.')
					local explosion = EffectData()
					explosion:SetOrigin(ent:GetPos())
					util.Effect('Explosion', explosion)
					ent:Remove()
				end
			else
				ent:SetHealth(ent:Health() -dmg:GetDamage())				
				local percentage = math.Clamp(ent:Health() /ent:GetMaxHealth(), 0, 1)
				ent:SetColor(Color(255, 255 *percentage, 255 *percentage))
		
				if ent:Health() <= 0 then
					if raider then 
						att:AddXP(BaseWars.Config.raid_reward_xp_prop) 
					end
					
					local pobj = ent:GetPhysicsObject()
					
					if pobj:IsValid() then
						pobj:EnableMotion(true)
					end
					
					constraint.RemoveAll(ent)
					ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
					--ent:EmitSound('physics/concrete/concrete_break'..math.random(2, 3)..'.wav')
					timer.Simple(5, function() if ent:IsValid() then ent:Remove() end end)
				end
			end
		end
	end
end

function GM:PlayerSpawnedProp(ply, mdl, ent)
	local health = BaseWars.Config.prop_mat_health[ent:GetMaterialType()] or 100
	ent:SetMaxHealth(health)
	ent:SetHealth(health)
end

function GM:PlayerSpawnEffect(ply)
	if ply:CanSpawnSpecials() then
		return true
	else
		BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn effects!")
		return false
	end
end

function GM:PlayerSpawnNPC(ply)
	if ply:CanSpawnSpecials() then
		return true
	else
		BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn NPCs!")
		return false
	end
end

function GM:PlayerSpawnRagdoll(ply)
	if ply:CanSpawnSpecials() then
		return true
	else
		BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn Ragdolls!")
		return false
	end
end

function GM:PlayerSpawnSENT(ply)
	if ply:CanSpawnSpecials() then
		return true
	else
		BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn entities!")
		return false
	end
end

function GM:PlayerSpawnSWEP(ply)
	if ply:CanSpawnSpecials() then
		return true
	else
		BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn weapons!")
		return false
	end
end

function GM:PlayerSpawnVehicle(ply)
	if ply:CanSpawnSpecials() then
		return true
	else
		BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn vehicles!")
		return false
	end
end

function GM:PlayerGiveSWEP(ply)
	if ply:CanSpawnSpecials() then
		return true
	else
		BaseWars.Notify(ply, 1, 5, "You're not allowed to give yourself weapons!")
		return false
	end
end

for order, data1 in pairs(BaseWars.Config.buyables) do
	for name, data2 in pairs(data1.items) do
		FPP.Blocked.Toolgun1[name] = true
		FPP.Blocked.Spawning1[name] = true
	end
end