local in_display
local function faction_create()
	local frame = vgui.Create('DFrame')
	frame:SetTitle('CREATE YOUR FACTION')
	frame:SetSize(500, 380)
	frame:Center()
    frame:SetAlpha(0)
    frame:AlphaTo(255, 0.15)
	frame:DoModal(true)
	frame:ShowCloseButton(false)
    frame:SetDraggable(false)
	frame:MakePopup()

	--intro
	local intro = vgui.Create('DLabel', frame)
	intro:SetFont('DermaDefault')
	intro:SetText("Creating a faction grants you total control over its members.\nPlayers can join your faction by typing the password. A blank password means that the faction is\npublic and everyone can join.\nOwnership is not transferable, thus leaving your faction will result in permanent dissipation.")
	intro:SizeToContents()
	intro:Dock(TOP)

	--faction name
	local name_info = vgui.Create('DLabel', frame)
	name_info:Dock(TOP)
	name_info:SetFont('HudHintTextLarge')
	name_info:SetText('Choose a Name')

	local entry_name = vgui.Create('DTextEntry', frame)
	entry_name:SetText('My Faction')
	entry_name:Dock(TOP)

	--faction password
	local pass_info = vgui.Create('DLabel', frame)
	pass_info:Dock(TOP)
	pass_info:SetFont('HudHintTextLarge')
	pass_info:SetText('Choose a Password (Optional)')

	local entry_password = vgui.Create('DTextEntry', frame)
	entry_password:Dock(TOP)

	--faction color 
	local mixer_info = vgui.Create('DLabel', frame)
	mixer_info:Dock(TOP)
	mixer_info:SetFont('HudHintTextLarge')
	mixer_info:SetText('Choose a Color')

	local mixer = vgui.Create('DColorMixer', frame)
	mixer:SetPalette(true) 
	mixer:SetAlphaBar(false) 		
	mixer:SetWangs(false)
	mixer:Dock(LEFT)

	--buttons
	local create = vgui.Create('DButton', frame)
	create:SetText('Create Faction')
	create:SetIcon('icon16/accept.png')
	create:DockMargin(5, 150, 0, 0)
	create:Dock(TOP)
	create.DoClick = function()
		local name = entry_name:GetValue()

		if #name >= 5 then
			if #name <= 20 then
				Derma_Query(
					'Are you sure you want to create '..name..'?\nOnce created, factions cannot be edited.',
					'CREATE A FACTION',
					'Yes',
					function()
						local color = mixer:GetColor()
						frame:Close()
						net.Start('bw_factions_create')
							net.WriteString(name)
							net.WriteString(entry_password:GetValue())
							net.WriteColor(Color(color.r, color.g, color.b))
						net.SendToServer()
					end,
					'No'
				)
			else
				Derma_Message('You need to enter a name within 20 characters.', 'Notification', 'Ok')
			end
		else
			Derma_Message('You need to enter a name with at least 5 characters.', 'Notification', 'Ok')
		end
	end

	local cancel = vgui.Create('DButton', frame)
	cancel:SetText('Cancel')
	cancel:SetIcon('icon16/cross.png')
	cancel:DockMargin(5, 1, 0, 0)
	cancel:Dock(TOP)
	cancel.DoClick = function()
    	frame:AlphaTo(0, 0.15, 0, function()
			frame:Close()
		end)
	end
end

--[[
	Just in fact I have my own already rewritten menu,
	I don't think that's a good idea to put more 
	of my code in here without total rewrite, lol.
	And I'm sorry for using of my own code structure. J.
]]

local function menu()
	local frame = vgui.Create('DFrame')
	frame:SetSize(900, 600) --900, 600 (110 dif.)
	frame:SetMouseInputEnabled(false)
    frame:SetAlpha(0)
    frame:AlphaTo(255, 0.15)
	frame:Center()
	frame:SetTitle('Base Wars - Menu')
	frame:MakePopup()
	frame.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, self:GetWide(), 24)
		surface.DrawRect(0, 0, w, h)
	end
	frame.OnClose = function()
		in_display = nil
	end

	local sheet = vgui.Create('DPropertySheet', frame)
	sheet:Dock(FILL)
	sheet.Paint = function(self, w, h) return end
	sheet.CreateFramework = function(text)
		--background
		local background = vgui.Create('DPanel', sheet)
		background:Dock(FILL)
		background.Paint = function(self, w, h) return end

		--player list
		local player_list = vgui.Create('DListView', background)
		player_list:Dock(FILL)
		player_list:AddColumn('Player')
		player_list:AddColumn('Faction')
		player_list:DockMargin(5, 5, 5, 5)
		player_list:SetMultiSelect(false)

		local counted = 0
		local function player_add(ply)
			local new_line
			local name = ply:GetFaction()
			local pos = #player_list:GetLines() +1

			if name then
				new_line = player_list:AddLine(ply:Nick(), name)
			else
				new_line = player_list:AddLine(ply:Nick(), '<NONE>')
			end

			new_line.player_attached = ply
			new_line.Think = function()
				if ply:IsValid() then
					local up_name = ply:GetFaction()

					if up_name ~= name then
						if up_name then
							name = up_name
						else
							name = '<NONE>'
						end

						new_line:SetColumnText(2, name)
					end

					if ply:Nick() ~= new_line:GetColumnText(1) then
						new_line:SetColumnText(1, ply:Nick())
					end
				else
					counted = counted -1
					player_list:RemoveLine(pos)
				end
			end
		end

		player_list.Think = function()
			local count = player.GetCount()

			if counted < count then
				local players = player.GetAll()

				for i = counted +1, count do
					counted = counted +1

					if players[i] ~= LocalPlayer() then
						player_add(players[i])
					end
				end
			end
		end
		player_list.GetSelectedPlayer = function()
			local line = player_list:GetSelectedLine()

			if line then
				return player_list:GetLine(line).player_attached
			end
		end

		return background
	end

	--factions
	local fac_tab = sheet:CreateFramework()
	fac_tab:DockMargin(0, -8, 0, 0)
	
	local fac_list = fac_tab:GetChildren()[1]
	sheet:AddSheet('Factions', fac_tab, 'icon16/user.png').Tab.Paint = function(self, w, h) return end

	local fac_pnl = vgui.Create('DPanel', fac_tab)
    fac_pnl:Dock(BOTTOM)
    fac_pnl:SetTall(32)
    function fac_pnl:Paint(w, h)
        return
    end

	local create = vgui.Create('DButton', fac_pnl)
	create:SetText('Create Faction')
	create:SetIcon('icon16/building_add.png')
	create:SetWide(150)
	create:DockMargin(5, 0, 0, 5)
	create:Dock(LEFT)
	create.DoClick = function()
		faction_create()
	end
	create.Think = function()
		create:SetEnabled(not LocalPlayer():IsPartakingRaid() and not LocalPlayer():GetFaction())
	end

	local exit = vgui.Create('DButton', fac_pnl)
	exit:SetText('Exit Faction')
	exit:SetIcon('icon16/building_delete.png')
	exit:SetWide(150)
	exit:DockMargin(5, 0, 0, 5)
	exit:Dock(LEFT)
	exit.DoClick = function()
		net.Start('bw_factions_sync')
			net.WriteBool(false)
		net.SendToServer()
	end
	exit.Think = function()
		exit:SetEnabled(not LocalPlayer():IsPartakingRaid() and LocalPlayer():GetFaction())
	end

	local join = vgui.Create('DButton', fac_pnl)
	join:SetText('Join Faction')
	join:SetIcon('icon16/disconnect.png')
	join:SetEnabled(false)
	join:SetWide(150)
	join:DockMargin(5, 0, 0, 5)
	join:Dock(LEFT)
	join.DoClick = function()
		local name, data = fac_list:GetSelectedPlayer():GetFaction()

		if #data.members < 8 then
			if not data.isPublic then
				Derma_StringRequest(
					'Join Faction',
					'Enter the password of '..name..' to join it.',
					'',
					function(value)
						net.Start('bw_factions_sync')
							net.WriteBool(true)
							net.WriteString(name)
							net.WriteString(value)
						net.SendToServer()
					end,
					nil,
					'Join'
				)
			else
				net.Start('bw_factions_sync')
					net.WriteBool(true)
					net.WriteString(name)
				net.SendToServer()
			end
		else
			Derma_Message("Factions can't have more than 8 members!", 'Notification', 'Ok')
		end
	end
	join.Think = function()
		join:SetEnabled(fac_list:GetSelectedPlayer() and not LocalPlayer():IsPartakingRaid() and not LocalPlayer():GetFaction() and fac_list:GetSelectedPlayer():GetFaction())
	end

	local fac_pnl_name = vgui.Create('DPanel', fac_pnl)
    fac_pnl_name:Dock(FILL)
    fac_pnl_name:DockMargin(2, 2, 2, 2)
    function fac_pnl_name:Paint(w, h)
		return
    end

    local fac_name = vgui.Create('DLabel', fac_pnl_name)
    fac_name:SetFont('ImpactMedium')
    fac_name:SetContentAlignment(5)
    fac_name:DockMargin(2, 0, 2, 0)
    fac_name:Dock(FILL)
    function fac_name:Think()
        local name, data = LocalPlayer():GetFaction()

        if name then
            self:SetText(fac_pnl_name:GetWide() - 10)
            self:SetTextColor(data.color)
			self:SetText(name)
        else
            self:SetText('')
        end
	end

	--raids
	local raid_tab = sheet:CreateFramework()
	raid_tab:DockMargin(0, -8, 0, 0)
	
	local raid_list = raid_tab:GetChildren()[1]
	sheet:AddSheet('Raids', raid_tab, 'icon16/bomb.png').Tab.Paint = function(self, w, h) return end

	local raid_panel = vgui.Create('DPanel', raid_tab)
    raid_panel:Dock(BOTTOM)
    raid_panel:SetTall(32)
    function raid_panel:Paint(w, h)
        return
    end

	local start = vgui.Create('DButton', raid_panel)
	start:SetText('Start Raid')
	start:SetIcon('icon16/building_go.png')
	start:SetWide(150)
	start:DockMargin(5, 0, 0, 5)
	start:Dock(LEFT)
	start.DoClick = function()
		if LocalPlayer():IsRaidable() then
			if raid_list:GetSelectedPlayer():IsRaidable() then
				net.Start('bw_raid_manage')
					net.WriteBool(true)
					net.WriteEntity(raid_list:GetSelectedPlayer())
				net.SendToServer()
			else
				Derma_Message(
					'This player is not raidable since his possessions are valued under '..BaseWars.FormatMoney(BaseWars.Config.raid_requirement)..'.',
					'Notification',
					'Ok'
				)
			end
		else
			Derma_Message(
				'You are not raidable as your possessions are valued under '..BaseWars.FormatMoney(BaseWars.Config.raid_requirement)..'.\nYou need to be raidable to raid.',
				'Notification',
				'Ok'
			)
		end
	end
	start.Think = function()
		local next_raid = LocalPlayer():GetNWFloat('next_raid')
		
		if next_raid > CurTime() then
			start:SetText(math.Round(next_raid -CurTime())..' SECONDS')
			start:SetEnabled(false)
		else
			local selected = raid_list:GetSelectedPlayer()
			start:SetEnabled(selected and not LocalPlayer():IsAlly(selected))
		end
	end

	local stop = vgui.Create('DButton', raid_panel)
	stop:SetText('Stop Raid')
	stop:SetIcon('icon16/cross.png')
	stop:SetWide(150)
	stop:DockMargin(5, 0, 0, 5)
	stop:Dock(LEFT)
	stop.DoClick = function()
		net.Start('bw_raid_manage')
			net.WriteBool(false)
		net.SendToServer()
	end
	stop.Think = function()
		local raid = BaseWars.GetRaid()
		
		if raid then
			stop:SetEnabled(LocalPlayer():IsPartakingRaid() == 1)
		else
			stop:SetEnabled(false)
		end
	end

	--commands
	local cmd_background = vgui.Create('DScrollPanel', sheet)
	cmd_background:DockMargin(0, -4, 0, 0)
	cmd_background:Dock(FILL)
	cmd_background.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
	end
	sheet:AddSheet('Commands', cmd_background, 'icon16/application_osx_terminal.png').Tab.Paint = function(self, w, h) return end

	local title = vgui.Create('DLabel', cmd_background)
	title:SetText('ALL AVAILABLE CHAT COMMANDS')
	title:SetColor(Color(255, 255, 0))
	title:SetFont('ImpactMedium')
	title:SetContentAlignment(5)
	title:SizeToContents()
	title:DockMargin(0, 0, 0, 5)
	title:Dock(TOP)

	for name, desc in pairs(BaseWars.GetChatCommands()) do
		local cmd = vgui.Create('DLabel', cmd_background)
		cmd:SetText(string.format('%s : %s', name, desc))
		cmd:SetFont('ImpactSmall')
		cmd:SetTextColor(Color(255, 255, 255))
		cmd:SetContentAlignment(5)
		cmd:SizeToContents()
		cmd:DockMargin(0, 2, 0, 5)
		cmd:Dock(TOP)
	end

	--rules
	local rul_background = vgui.Create('DPanel', sheet)
	rul_background:DockMargin(0, -4, 0, 0)
	rul_background:Dock(FILL)
	sheet:AddSheet('Rules', rul_background, 'icon16/book_open.png').Tab.Paint = function(self, w, h) return end

	local webpage = vgui.Create('HTML', rul_background)
	webpage:OpenURL(BaseWars.Config.rulesURL)
	webpage:Dock(FILL)

	in_display = frame
end

function GM:Think()
	if not in_display and input.IsKeyDown(KEY_F3) then
		menu()
	end
end