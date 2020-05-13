surface.CreateFont('BWScoreboardGenText', {font = 'Tahoma', size = 16})
surface.CreateFont('BWScoreboardPlayerName', {font = 'Tahoma', size = 20})

local scoreboard
function GM:ScoreboardShow()
	--frame
	local frame = vgui.Create('DFrame')
	frame:SetSize(ScrW() -150, ScrH() -200) --850, 600 (250 dif.)
	frame:SetTitle('')
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:MakePopup()
	frame:SetKeyboardInputEnabled(false)
	frame:Center()
	frame.Paint = function()
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, frame:GetWide(), 75)
		
		draw.SimpleText('welcome to', 'SegoeMedium', 10, 0, Color(255, 255, 0))
		draw.SimpleText(string.upper(GetHostName()), 'ImpactLarge', 25, 15, color_white)
	end
	
	local scroll = vgui.Create('DScrollPanel', frame)
	scroll:SetTall(frame:GetTall() -84)
	scroll:DockMargin(0, 50, 0, 0)
	scroll:Dock(TOP)
	
	--info
	local info = vgui.Create('DPanel', scroll)
	info:DockMargin(0, 0, 0, 0)
	info:Dock(TOP)
	info.Paint = function()
		draw.RoundedBoxEx(8, 0, 0, info:GetWide(), info:GetTall(), Color(0, 0, 0), true, true, false, false)
	end
	
	local info1 = vgui.Create('DLabel', info)
	info1:SetFont('BWScoreboardGenText')
	info1:SetTextColor(color_white)
	info1:SetText('Player Name')
	info1:SizeToContents()
	info1:DockMargin(40, 0, 0, 0)
	info1:Dock(LEFT)
	
	local info2 = vgui.Create('DLabel', info)
	info2:SetFont('BWScoreboardGenText')
	info2:SetTextColor(color_white)
	info2:SetText('Ping')
	info2:SizeToContents()
	info2:DockMargin(0, 0, 20, 0)
	info2:Dock(RIGHT)
	
	local info3 = vgui.Create('DLabel', info)
	info3:SetFont('BWScoreboardGenText')
	info3:SetTextColor(color_white)
	info3:SetText('Deaths')
	info3:SizeToContents()
	info3:DockMargin(0, 0, 20, 0)
	info3:Dock(RIGHT)
	
	local info4 = vgui.Create('DLabel', info)
	info4:SetFont('BWScoreboardGenText')
	info4:SetTextColor(color_white)
	info4:SetText('Score')
	info4:SizeToContents()
	info4:DockMargin(0, 0, 20, 0)
	info4:Dock(RIGHT)
	
	local info5 = vgui.Create('DLabel', info)
	info5:SetFont('BWScoreboardGenText')
	info5:SetTextColor(color_white)
	info5:SetText('Faction')
	info5:SizeToContents()
	info5:DockMargin(0, 0, 102, 0)
	info5:Dock(RIGHT)
	
	local info6 = vgui.Create('DLabel', info)
	info6:SetFont('BWScoreboardGenText')
	info6:SetTextColor(color_white)
	info6:SetText('Rank')
	info6:SizeToContents()
	info6:DockMargin(0, 0, 125, 0)
	info6:Dock(RIGHT)
	
	local counted = 0
	local function player_add(ply)
		--backgroud
		local backgroud = vgui.Create('DPanel', scroll)
		backgroud:DockMargin(0, 0, 0, 1)
		backgroud:Dock(TOP)
		backgroud:SetTall(34)
		backgroud.Paint = function()
			surface.SetDrawColor(color_white)
			surface.DrawRect(0, 0, backgroud:GetWide(), backgroud:GetTall())
		end
	
		--avatar
		local avatar = vgui.Create('AvatarImage', backgroud)
		avatar:SetWide(32)
		avatar:SetPlayer(ply, 32)
		avatar:DockMargin(1, 1, 0, 1)
		avatar:Dock(LEFT)
	
		local button = vgui.Create('DButton', avatar)
		button:SetText('')
		button.Paint = nil
		button:Dock(FILL)
		button.DoClick = function()
			local menu = DermaMenu()
			menu:SetParent(frame)
			menu:AddOption('View Profile', function() ply:ShowProfile() end)
			menu:AddOption('Copy SteamID', function() SetClipboardText(ply:SteamID()) end)
			surface.PlaySound('buttons/button14.wav')
				
			if ply:IsMuted() then
				menu:AddOption('Unmute', function()
					ply:SetMuted(false)
				end)
			else
				menu:AddOption('Mute', function()
					ply:SetMuted(true)
				end)
			end
		
			menu:Open()
		end
	    
		--info (name)
		local nick = vgui.Create('DLabel', backgroud)
		nick:SetTextColor(Color(93, 93, 93))
		nick:SetFont('BWScoreboardPlayerName')
		nick:DockMargin(5, 0, 0, 0)
		nick:Dock(LEFT)
	
		--info
		local ping = vgui.Create('DLabel', backgroud)
		ping:SetFont('BWScoreboardGenText')
		ping:SetTextColor(Color(93, 93, 93))
		ping:SetContentAlignment(5)
		ping:SetWide(info2:GetWide())
		ping:DockMargin(0, 0, 20, 0)
		ping:Dock(RIGHT)
	
		local deaths = vgui.Create('DLabel', backgroud)
		deaths:SetFont('BWScoreboardGenText')
		deaths:SetTextColor(Color(93, 93, 93))
		deaths:SetContentAlignment(5)
		deaths:SetWide(info3:GetWide())
		deaths:DockMargin(0, 0, 20, 0)
		deaths:Dock(RIGHT)
		
		local score = vgui.Create('DLabel', backgroud)
		score:SetFont('BWScoreboardGenText')
		score:SetTextColor(Color(93, 93, 93))
		score:SetContentAlignment(5)
		score:SetWide(info4:GetWide())
		score:DockMargin(0, 0, 20, 0)
		score:Dock(RIGHT)
	
		local faction = vgui.Create('DLabel', backgroud)
		faction:SetFont('BWScoreboardGenText')
		faction:SetWide(info5:GetWide() +120)
		faction:SetContentAlignment(5)
		faction:DockMargin(0, 0, 42, 0)
		faction:Dock(RIGHT)
	
		local rank = vgui.Create('DLabel', backgroud)
		rank:SetFont('BWScoreboardGenText')
		rank:SetWide(info6:GetWide() +120)
		rank:SetContentAlignment(5)
		rank:DockMargin(0, 0, 5, 0)
		rank:Dock(RIGHT)
		
		--manage all info within the background
		backgroud.Think = function()
			if ply:IsValid() then
				local name, data = ply:GetFaction()
				nick:SetText(ply:Nick())
				nick:SizeToContents()
				ping:SetText(ply:Ping())
				deaths:SetText(ply:Deaths())
				score:SetText(ply:Frags())
				
				if name then
					faction:SetTextColor(data.color)
					faction:SetText(name)
				else
					faction:SetTextColor(Color(93, 93, 93))
					faction:SetText('<NONE>')
				end
				
				if ply:IsSuperAdmin() then
					rank:SetTextColor(Color(255, 0, 0))
					rank:SetText('Super Admin')
				elseif ply:IsAdmin() then
					rank:SetTextColor(Color(255, 0, 128))
					rank:SetText('Admin')
				else
					rank:SetTextColor(Color(93, 93, 93))
					rank:SetText('User')
				end
			else
				counted = counted -1
				backgroud:Remove()
			end
		end
	end
	
	scroll.Think = function()
		local count = player.GetCount()
		
		if counted < count then
			local players = player.GetAll()
			
			for i = counted +1, count do
				counted = counted +1
				player_add(players[i])
			end
		end
	end
	
	scoreboard = frame
end

function GM:ScoreboardHide()
	scoreboard:Remove()
end