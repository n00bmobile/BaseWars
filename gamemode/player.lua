if CLIENT then
	hook.Add('Think', 'bw_player_loadcheck', function()
		if LocalPlayer():IsValid() then
			net.Start('bw_player_loadfinish')
			net.SendToServer()
			hook.Remove('Think', 'bw_player_loadcheck')
		end
	end)
return end

util.AddNetworkString('bw_player_loadfinish')

local toSync = {}
function BaseWars.AddSync(name, func)
	toSync[name] = func
end

function BaseWars.EndSync(name)
	toSync[name] = nil
end

function GM:PlayerLoaded(ply)
	for k, v in pairs(toSync) do
		v(ply)
	end
	
	BaseWars.AddNotification(ply, 4, 'Welcome to Base Wars!\nMade free by n00bmobile.\n\nNeed Help?\nEverything you might ever need is in the F3 menu!')
end

net.Receive('bw_player_loadfinish', function(length, ply)
	hook.Run('PlayerLoaded', ply)
end)

function GM:PlayerInitialSpawn(ply)
	ply:SetupVars()
end

function GM:PlayerDisconnected(ply)
	local refund = 0
	
	for k, v in pairs(ents.GetAll()) do
		if not v:IsPlayer() and v:GetClass() ~= 'prop_physics' and v:CPPIGetOwner() == ply then
			refund = refund +v:GetPrice() *BaseWars.Config.price_refund_multiplier
			v:Remove()
		end
	end
	
	if ply:IsPartakingRaid() then
		BaseWars.StopRaid()
	end
	
	ply:AddMoney(refund)
	ply:RemoveFromFaction()
end

function GM:PlayerLoadout(ply)
	for k, v in pairs(BaseWars.Config.loadout) do
		ply:Give(k)
	end
	
	return true
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)
	ply:SetRunSpeed(240)
	ply:SetWalkSpeed(160)
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if wep:GetPos():DistToSqr(ply:GetPos()) ~= 0 then
		if ply:KeyPressed(IN_USE) and ply:GetEyeTrace().Entity == wep then
			wep:CPPISetOwner(nil)
			return true
		else
			return false
		end
	else
		return true
	end
end

function GM:PlayerCanPickupItem(ply, ent)
	if ent:GetPos():DistToSqr(ply:GetPos()) ~= 0 then
		return ply:KeyPressed(IN_USE) and ply:GetEyeTrace().Entity == ent
	else
		return true
	end
end

function GM:PlayerDeath(victim, ent, attacker)
	if attacker:IsPlayer() and attacker:IsRaiding(victim) then 
		attacker:AddXP(BaseWars.Config.raid_reward_xp_player)
		attacker:AddMoney(BaseWars.Config.raid_reward_player) 
		BaseWars.AddNotification(attacker, 3, "You've been rewarded "..BaseWars.FormatMoney(BaseWars.Config.raid_reward_player)..' and '..BaseWars.Config.raid_reward_xp_player..'XP for killing '..victim:Nick()..'!')
	end
	
	if BaseWars.Config.respawn_delay > 0 then
		victim:Lock()
		timer.Simple(BaseWars.Config.respawn_delay, function()
			if victim:IsValid() then
				victim:UnLock()
			end
		end)
	end
	
	if BaseWars.Config.drop_weapon then
		for k, v in pairs(victim:GetWeapons()) do
			if not BaseWars.Config.loadout[v:GetClass()] then
				victim:DropWeapon(v)
			end
		end
	end
end

function BaseWars:GetFallDamage(ply, spd) 
    return math.Remap(spd / 8, 0, ply:GetMaxSpeed(), 1, ply:GetMaxHealth())
end

local meta = FindMetaTable('Player')
function meta:SaveData()
	local data = {
		money = self:GetMoney(),
		leveling = {
			self:GetNWInt('level'),
			self:GetNWInt('level_xp')
		}
	}
	BaseWars.SaveDatabase(self, util.TableToJSON(data))
end

function meta:SetupVars()
	local read = file.Read('basewars/userdata/'..string.Replace(self:SteamID(), ':', '_')..'.txt', 'DATA')
	
	if read then
		local data = util.JSONToTable(read)
		self:SetNWString('money', tostring(data.money)) --prevents saving for no reason
		self:SetNWInt('level', data.leveling[1])
		self:SetNWInt('level_xp', data.leveling[2])
	else
		self:SetNWString('money', tostring(BaseWars.Config.starting_money))
		self:SetNWInt('level', 1)
	end
end

function meta:SpawnInFront(class)
	local ent = ents.Create(class)
	local ang = self:EyeAngles()
	local tr = util.TraceHull({
		start = self:EyePos(),
		endpos = self:EyePos() +Angle(math.Clamp(ang.p, -90, 15), ang.y, ang.r):Forward() *80,
		filter = self,
		mins = ent:OBBMins(),
		maxs = ent:OBBMaxs()
	})

	if tr.Entity == NULL and util.IsInWorld(tr.HitPos) then
		ent:SetPos(tr.HitPos)
		ent:Spawn()
		return ent
	else
		ent:Remove()
	end
end

function meta:AddMoney(amount)
	self:SetMoney(self:GetMoney() +amount)
end

function meta:SetMoney(value)
	self:SetNWString('money', tostring(value))
	self:SaveData()
end

function meta:CanSpawnSpecials()
	local clearance = BaseWars.Config.spawn_clearance
	
	if clearance == 0 then
		return true
	elseif clearance == 1 then
		return self:IsAdmin()
	elseif clearance == 2 then
		return self:IsSuperAdmin()
	else
		return false
	end
end

timer.Create('bw_player_salary', 600, 0, function()
	for k, v in pairs(player.GetAll()) do
		v:AddXP(BaseWars.Config.salary_xp)
		v:AddMoney(BaseWars.Config.salary)
		BaseWars.AddNotification(v, 3, 'Payday! You got '..BaseWars.FormatMoney(BaseWars.Config.salary)..' and '..BaseWars.Config.salary_xp..'XP.')
	end
end)

--[[concommand.Add('addmoney', function(ply)
	ply:AddMoney(1000000)
end)]]