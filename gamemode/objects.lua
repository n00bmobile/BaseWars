hook.Add('PhysgunPickup', 'bw_gm_sandboxhooksworkaround_physgunpickup', function(ply, ent) --i'll fix this later...
	return ent:Health() > 0
end)

--[[function GM:PhysgunPickup(ply, ent)
	return ent:Health() > 0
end]]

hook.Add('CanTool', 'bw_gm_sandboxhooksworkaround_cantool', function(ply, tr, tool)
	local ent = tr.Entity
	
	if not ent:IsPlayer() and ent:GetClass() ~= 'prop_physics' and ent:CPPIGetOwner() then
		if tool == 'remover' then
			if SERVER then
				local price = ent:GetPrice() *BaseWars.Config.price_refund_multiplier
				ent:CPPIGetOwner():AddMoney(price)
				BaseWars.AddNotification(ent:CPPIGetOwner(), 1, 'You got '..BaseWars.FormatMoney(price)..' for your removed '..(ent.PrintName or 'Object')..'.')
			end
			
			return true
		else
			return false
		end
	else
		return true
	end
end)

--[[function GM:CanTool(ply, tr, tool)
	local ent = tr.Entity
	
	if not ent:IsPlayer() and ent:GetClass() ~= 'prop_physics' and ent:CPPIGetOwner() then
		if tool == 'remover' then
			if SERVER then
				local price = ent:GetPrice() *BaseWars.Config.price_refund_multiplier
				ent:CPPIGetOwner():AddMoney(price)
				BaseWars.AddNotification(ent:CPPIGetOwner(), 1, 'You got '..BaseWars.FormatMoney(price)..' for your removed '..(ent.PrintName or 'Object')..'.')
			end
			
			return true
		else
			return false
		end
	else
		return true
	end
end]]

if CLIENT then return end

function GM:EntityTakeDamage(ent, dmg)
	if not ent:IsPlayer() and ent:GetMaxHealth() > 0 then
		local owner = ent:CPPIGetOwner()
		local attacker = dmg:GetAttacker()
		
		if owner and owner ~= attacker then
			local isRaider = (attacker:IsPlayer() and attacker:IsRaiding(owner))
			
			if not isRaider then 
				dmg:ScaleDamage(0.25)
			end
			
			ent:SetHealth(ent:Health() -dmg:GetDamage())
			
			if ent:GetClass() == 'prop_physics' then
				local percentage = math.Clamp(ent:Health() /ent:GetMaxHealth(), 0, 1)
				ent:SetColor(Color(255, 255 *percentage, 255 *percentage))
		
				if ent:Health() <= 0 then
					if isRaider then 
						attacker:AddXP(BaseWars.Config.raid_reward_xp_prop) 
					end
					
					constraint.RemoveAll(ent)
					ent:GetPhysicsObject():EnableMotion(true)
					ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
					--ent:EmitSound('physics/concrete/concrete_break'..math.random(2, 3)..'.wav')
					timer.Simple(5, function() if ent:IsValid() then ent:Remove() end end)
				end
			elseif ent:Health() <= 0 then
				if isRaider then
					attacker:AddXP(BaseWars.Config.raid_reward_xp_ent)
					attacker:AddMoney(BaseWars.Config.raid_reward_ent) 
					BaseWars.AddNotification(attacker, 3, "You've been rewarded "..BaseWars.FormatMoney(BaseWars.Config.raid_reward_ent)..' and '..BaseWars.Config.raid_reward_xp_ent..'XP for destroying '..ent.PrintName..'!')
				end
				
				local price = ent:GetPrice() *BaseWars.Config.price_refund_multiplier
				owner:AddMoney(price)
				BaseWars.AddNotification(owner, 2, 'You got '..BaseWars.FormatMoney(price)..' for your destroyed '..(ent.PrintName or 'Object')..'.')
				local explosion = EffectData()
				explosion:SetOrigin(ent:GetPos())
				util.Effect('Explosion', explosion)
				ent:Remove()
			end
		end
	end
end

function GM:PlayerSpawnedProp(ply, mdl, ent)
	local health = BaseWars.Config.prop_material_health[ent:GetMaterialType()] or 100
	ent:SetMaxHealth(health)
	ent:SetHealth(health)
end

function GM:PlayerSpawnEffect(ply)
	BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn effects!")
	return false
end

function GM:PlayerSpawnNPC(ply)
	BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn NPCs!")
	return false
end

function GM:PlayerSpawnRagdoll(ply)
	BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn Ragdolls!")
	return false
end

function GM:PlayerSpawnSENT(ply)
	BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn entities!")
	return false
end

function GM:PlayerSpawnSWEP(ply)
	BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn weapons!")
	return false
end

function GM:PlayerSpawnVehicle(ply)
	BaseWars.Notify(ply, 1, 5, "You're not allowed to spawn vehicles!")
	return false
end

function GM:PlayerGiveSWEP(ply)
	BaseWars.Notify(ply, 1, 5, "You're not allowed to give yourself weapons!")
	return false
end