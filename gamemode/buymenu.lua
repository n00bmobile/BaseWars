local meta = FindMetaTable('Entity')

function meta:IsBuyable()
	for order, data in pairs(BaseWars.Config.buyables) do
		local found = data.items[self:GetClass()]
		
		if found then
			return true
		end
	end
	
	return false
end

function meta:GetPrice()
	for order, data in pairs(BaseWars.Config.buyables) do
		local found = data.items[self:GetClass()]
		
		if found then
			return found.price
		end
	end
	
	return 0
end

if not CLIENT then
	util.AddNetworkString('bw_buymenu')
	
	net.Receive('bw_buymenu', function(len, ply)
		local index = net.ReadUInt(8)
		local class = net.ReadString()
		
		if BaseWars.Config.buyables[index] then
			local bought = BaseWars.Config.buyables[index].items[class]
			
			if bought and ply:CanAfford(bought.price) and ply:ReachesLevel(bought.level) then
				if bought.limit and bought.limit > 0 then
					local count = 0
				
					for k, v in pairs(ents.FindByClass(class)) do
						if v:CPPIGetOwner() == ply then
							count = count +1
						end
					end
				
					if count >= bought.limit then
						BaseWars.Notify(ply, 1, 10, "You can only have "..bought.limit.." of this spawned at a time.")
						return
					end
				end
				
				local spawned = ply:SpawnInFront(class)
				
				if spawned then
					--spawned:DropToFloor()
					spawned:CPPISetOwner(ply)
					ply:AddMoney(-bought.price)
					ply:SendLua("surface.PlaySound('ambient/levels/labs/coinslot1.wav')")
					BaseWars.AddNotification(ply, 1, 'You bought '..bought.name..' for '..BaseWars.FormatMoney(bought.price)..'.')
					
					if bought.health and bought.health > 0 then
						spawned:SetMaxHealth(bought.health)
						spawned:SetHealth(bought.health)
					end
				else
					BaseWars.Notify(ply, 1, 10, "The object you tried to buy wasn't able to spawn. Face away from any obstacles and try again.")
				end
			end
		end
	end)
return end

spawnmenu.AddCreationTab('Store', function()
	local scroll = vgui.Create('DScrollPanel')
	
	for index, category in ipairs(BaseWars.Config.buyables) do
		local cat = vgui.Create('DCollapsibleCategory', scroll)									
		cat:SetExpanded(1)
		cat:SetLabel(category.name)
		cat:Dock(TOP)
		
		local layout = vgui.Create('DIconLayout', cat)
		layout:SetSpaceX(1)
		layout:SetSpaceY(1)
		--layout:SetSize(50, 50)
		cat:SetContents(layout)
	
		for class, data in SortedPairsByMemberValue(category.items, 'price') do
			local item = layout:Add('SpawnIcon')
			item:SetModel(data.model)
			item:SetTooltip(data.name..'\n'..data.desc..'\n\nPrice: '..BaseWars.FormatMoney(data.price))
			item.PaintOver = function()
				if not LocalPlayer():ReachesLevel(data.level) then
					draw.SimpleTextOutlined('LEVEL '..data.level, 'DermaDefault', 32, 32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				elseif not LocalPlayer():CanAfford(data.price) then
					draw.SimpleTextOutlined('Insufficient', 'DermaDefault', 32, 32 -5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
					draw.SimpleTextOutlined('Funds', 'DermaDefault', 32, 32 +5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				else
					draw.SimpleTextOutlined(string.MaxLen(data.name, 8), 'DermaDefault', 32, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
					draw.SimpleTextOutlined(BaseWars.FormatMoney(data.price), 'DermaDefault', 32, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
				end
			end
			item.Paint = function()
				if not LocalPlayer():ReachesLevel(data.level) then
					draw.RoundedBox(4, 0, 0, 64, 64, Color(47, 79, 79, 200))
				elseif not LocalPlayer():CanAfford(data.price) then
					draw.RoundedBox(4, 0, 0, 64, 64, Color(255, 0, 0, 200))
				else
					draw.RoundedBox(4, 0, 0, 64, 64, Color(0, 0, 255, 200))
				end
			end
			item.DoClick = function()
				if LocalPlayer():ReachesLevel(data.level) then
					if LocalPlayer():CanAfford(data.price) then
						net.Start('bw_buymenu')
							net.WriteUInt(index, 8)
							net.WriteString(class)
						net.SendToServer()
						return
					else
						BaseWars.Notify(1, 5, "You can't afford to buy "..data.name..'!')
					end
				else
					BaseWars.Notify(1, 5, 'Your level is not high enough to buy this item!')
				end
				
				surface.PlaySound('buttons/weapon_cant_buy.wav')
			end
			
			if data.level > 0 then
				item:SetTooltip(FindTooltip(item)..'\nRequired Level: '..data.level)
			end
		end
	end
	
	return scroll
end, 'icon16/money.png', 200)

function GM:PopulateContent() --remove everything else expect spawnlist
	local key = 1
	
	for i = 1, #g_SpawnMenu.CreateMenu.Items do
		if g_SpawnMenu.CreateMenu.Items[key].Tab:GetText() ~= language.GetPhrase('spawnmenu.content_tab') and g_SpawnMenu.CreateMenu.Items[key].Tab:GetText() ~= 'Store' then
			g_SpawnMenu.CreateMenu:CloseTab(g_SpawnMenu.CreateMenu.Items[key].Tab, true)
		else
			key = key +1
		end
    end
end