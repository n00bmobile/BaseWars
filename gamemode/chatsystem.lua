local cmds = {}

function BaseWars.GetChatCommands()
	return cmds
end

function BaseWars.AddChatCommand(name, desc, func)
	if SERVER then
		cmds[name] = func
	else
		cmds[name] = desc
	end
end

--cmds
BaseWars.AddChatCommand('/pm', 'Sends a private message to a specific player.', function(ply, args)
	local tab = string.Explode(' ', args)
	local target = tab[1]

	if #target > 0 then 
		local found = BaseWars.FindPlayer(target)
	
		if found and found ~= ply then
			local text = table.concat(tab, ' ', 2)
			net.Start('bw_chatsystem_pm')
				net.WriteEntity(ply)
				net.WriteString(text)
			net.Send(ply)
			net.Start('bw_chatsystem_pm')
				net.WriteEntity(ply)
				net.WriteString(text)
			net.Send(found)
		else
			BaseWars.Notify(ply, 1, 5, 'Valid target not found!')
		end
	else
		BaseWars.Notify(ply, 1, 5, 'You need to write a name of a player!')
	end
end)

BaseWars.AddChatCommand('/weapon', 'Drops the weapon you are holding.', function(ply)
	local wep = ply:GetActiveWeapon()
	
	if IsValid(wep) then
		local class = wep:GetClass()
		local droppable = (not BaseWars.Config.loadout[class])
		
		if droppable then
			local dropped = ply:SpawnInFront(class)
			
			if not dropped then
				BaseWars.Notify(ply, 1, 10, 'Failed to drop current weapon. Face away from any obstacles and try again.')
			else
				ply:StripWeapon(class)
				BaseWars.Notify(ply, 0, 10, 'You have dropped your current weapon.')
			end
		else
			BaseWars.Notify(ply, 1, 5, "The weapon you are holding can't be dropped!")
		end
	else
		BaseWars.Notify(ply, 1, 5, "You're not holding a weapon!")
	end
end)

BaseWars.AddChatCommand('/setmoney',  "Sets the specified player's money.", function(ply, args)
	if ply:IsSuperAdmin() then
		local tab = string.Explode(' ', args)
		local target = tab[1]
	
		if #target > 0 then
			local found = BaseWars.FindPlayer(target)
			
			if found then
				if tab[2] then
					local value = tonumber(tab[2])
				
					if value then
						found:SetMoney(value)
						
						for k, v in pairs(player.GetAll()) do
							BaseWars.Notify(v, 0, 30, ply:GetName()..' has set the money of '..found:GetName()..' to '..BaseWars.FormatMoney(value)..'.')
						end					
					else
						BaseWars.Notify(ply, 1, 5, 'Invalid number!')
					end
				else
					BaseWars.Notify(ply, 1, 5, 'You need to enter a number!')
				end
			else
				BaseWars.Notify(ply, 1, 5, 'Valid target not found!')
			end
		else
			BaseWars.Notify(ply, 1, 5, 'You need to write a name of a player!')
		end
	else
		BaseWars.Notify(ply, 1, 5, 'You need to be a SuperAdmin to use this command!')
	end
end)

BaseWars.AddChatCommand('/setlevel',  "Sets the specified player's level.", function(ply, args)
	if ply:IsSuperAdmin() then
		local tab = string.Explode(' ', args)
		local target = tab[1]
	
		if #target > 0 then
			local found = BaseWars.FindPlayer(target)
			
			if found then
				if tab[2] then
					local value = tonumber(tab[2])
				
					if value then
						found:SetLevel(value)
						
						for k, v in pairs(player.GetAll()) do
							BaseWars.Notify(v, 0, 30, ply:GetName()..' has set the level of '..found:GetName()..' to '..value..'.')
						end					
					else
						BaseWars.Notify(ply, 1, 5, 'Invalid number!')
					end
				else
					BaseWars.Notify(ply, 1, 5, 'You need to enter a number!')
				end
			else
				BaseWars.Notify(ply, 1, 5, 'Valid target not found!')
			end
		else
			BaseWars.Notify(ply, 1, 5, 'You need to write a name of a player!')
		end
	else
		BaseWars.Notify(ply, 1, 5, 'You need to be a SuperAdmin to use this command!')
	end
end)

BaseWars.AddChatCommand('/money', "Drops a specific amount of money.", function(ply, args)
	local amount = tonumber(string.Explode(' ', args)[1])
	
	if amount then
		amount = math.Round(amount)
		
		if amount > 0 then
			if ply:CanAfford(amount) then
				local spawned = ply:SpawnInFront('bw_money')
			
				if spawned then
					ply:AddMoney(-amount)
					spawned:SetAmount(amount)
				else
					BaseWars.Notify(ply, 1, 10, 'Failed to drop money. Face away from any obstacles and try again.')
				end
			else
				BaseWars.Notify(ply, 1, 5, "You can't afford this!")
			end
		else
			BaseWars.Notify(ply, 1, 5, 'You need to enter a number greater than zero!')
		end
	else
		BaseWars.Notify(ply, 1, 5, 'You need to enter a valid number!')
	end
end)

--[[BaseWars.AddChatCommand('/reset', 'Gives you a fresh start by resetting your money and level.', function(ply)
	for k, v in pairs(ents.GetAll()) do
		if not v:IsPlayer() and v:CPPIGetOwner() == ply then
			v:Remove()
		end
	end
	
	ply:Spawn()
	ply:SetLevel(1)
	ply:SetMoney(BaseWars.Config.starting_money)
	ply:SendLua('surface.PlaySound("ambient/alarms/warningbell1.wav")')
	BaseWars.AddNotification(ply, 1, 'Your character has been reset!')
end)]]

if SERVER then
	util.AddNetworkString('bw_chatsystem_pm')
	
	function GM:PlayerSay(sender, txt, group)
		if not group then
			for name, func in pairs(cmds) do
				if name == txt then
					func(sender, '')
					return ''
				elseif string.StartWith(txt, name..' ') then
					func(sender, string.Replace(txt, name..' ', ''))
					return ''
				end
			end
		end
		
		return txt
	end
	
	function GM:PlayerCanHearPlayersVoice(listen, speak)
		return listen:GetPos():DistToSqr(speak:GetPos()) <= 250000, true --500 squared
	end
	
	function GM:PlayerCanSeePlayersChat(msg, tchat, listen, speak)
		if tchat then
			return listen:IsAlly(speak)
		else
			return true
		end
	end
return end

function GM:OnPlayerChat(ply, msg, tchat, dead)
	if ply:IsValid() then
		local tags = {}
		
		if dead then
			table.insert(tags, color_black)
			table.insert(tags, '*DEAD* ')
		end
	
		local name, faction = ply:GetFaction()
	
		if name then
			if tchat then
				table.insert(tags, Color(0, 0, 255))
				table.insert(tags, '( FACTION ) ')
			end
			
			table.insert(tags, faction.color)
			table.insert(tags, '[ '..name..' ] ')
		end
		
		if LocalPlayer():IsAlly(ply) then
			table.insert(tags, Color(0, 255, 255))
		else
			table.insert(tags, Color(255, 0, 0))
		end
		
		table.insert(tags, ply:GetName())
		table.insert(tags, color_white)
		table.insert(tags, ': '..msg)
		chat.AddText(unpack(tags))
		
		return true
	end
end

net.Receive('bw_chatsystem_pm', function()
	--local sender = net.ReadEntity()
	chat.AddText(Color(0, 255, 255), '( PM ) ', net.ReadEntity():GetName(), color_white, ': '..net.ReadString())
end)