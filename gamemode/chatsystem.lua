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

------------------------------------------------------------
-- Let me guess, there was no option for selling stuff?
-- So, let it be. J.
------------------------------------------------------------
BaseWars.AddChatCommand('/sell', "Sells the item you're looking at.", function(ply)
	local raid = ply:IsPartakingRaid()
	
	if raid ~= 1 and raid ~= 2 then --make it so he can't sell anything while being raided
		local tr = ply:GetEyeTrace()
	
		if not tr.Entity:IsWorld() and tr.HitPos:Distance(ply:GetPos()) < 100 then --no long distance selling.
			local _, item	= BaseWars.FindBuyable(tr.Entity:GetClass()) --[[
				BaseWars.FindBuyable(String class) returns both the order of the category the item is in and its data, meaning you have acess to item data. 
				Entity:GetPrice() uses this function internally, so by calling both you are essencially running a loop that you could've run only once twice.
				
				Here's how item data is structured:
				{
					name = "Item name",
					model = "pathtomodel/itemmodel.mdl",
					desc = "Item description",
					price = 0,
					limit = 0,
					level = 0
				}
			]]
		
			if item then
				if tr.Entity:CPPIGetOwner() == ply then
					local refund = item.price * BaseWars.Config.price_refund_multiplier
					ply:AddMoney(refund)
					BaseWars.Notify(ply, 0, 10, 'You\'ve sold ' .. item.name .. ' for ' ..BaseWars.FormatMoney(refund))
					BaseWars.AddNotification(ply, 3, 'You sold '..item.name..' for '..BaseWars.FormatMoney(refund)) --use the notification board for things that affect the player long term like money.
					tr.Entity:Remove()
				else
					BaseWars.Notify(ply, 1, 5, "This isn't yours to sell!")
				end
			else
				BaseWars.Notify(ply, 1, 5, 'You can\'t sell this!')
			end
		else
			BaseWars.Notify(ply, 1, 8, 'You need to look from up close the item you want to sell!')
		end
	else
		BaseWars.Notify(ply, 1, 5, "You can't sell during a raid.")
	end
end)

BaseWars.AddChatCommand('/sellall', 'Sells all your items.', function(ply)
	local raid = ply:IsPartakingRaid()
	
	if raid ~= 1 and raid ~= 2 then --make it so he can't sell anything while being raided
		local refund = 0

		for _, ent in next, ents.GetAll() do
			local _, item	= BaseWars.FindBuyable(ent:GetClass())

			if item and ent:CPPIGetOwner() == ply then
				refund = refund + ent:GetPrice() * BaseWars.Config.price_refund_multiplier
				ent:Remove()
			end
		end

		if refund > 0 then
			BaseWars.Notify(ply, 1, 10, 'You\'ve sold all your items for ' .. BaseWars.FormatMoney(refund))
			BaseWars.AddNotification(ply, 3, "You sold all your items for "..BaseWars.FormatMoney(refund)) --use the notification board for things that affect the player long term like money.
			ply:AddMoney(refund) --[[
			Player:AddMoney(number amount) uses the NWVars system internally, more specifically NWString. 
			Everytime you call it you are sending an entire string (to mitigate floating point errors) to the client even if you didn't change anything (tl;dr Player:AddMoney(0) is a no no)
			]]
		else
			BaseWars.Notify(ply, 1, 5, 'You don\'t have items to sell.')
		end
	else
		BaseWars.Notify(ply, 1, 1, "You can't sell during a raid.")
	end
end)

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