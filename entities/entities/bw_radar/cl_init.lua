include('shared.lua')

local holdScan
hook.Add('HUDPaint', 'bw_radar_seethrough', function()
	local targets = {}
	
	for ind, ent in pairs(ents.FindByClass('bw_radar')) do
		if ent:GetTarget():IsValid() and ent:CPPIGetOwner() and not targets[ent:GetTarget()] and ent:CPPIGetOwner():IsAlly(LocalPlayer()) then
			for k, v in pairs(ents.GetAll()) do
				if v:IsPlayer() then
					if v:IsAlly(ent:GetTarget()) then
						local pos = (v:GetPos() +Vector(0, 0, 40)):ToScreen()
						draw.DrawText('*Detected*\n'..v:Nick(), 'DermaDefault', pos.x, pos.y, Color(255, 0, 0), 1)
					end
				elseif v.MaxPower and v:CPPIGetOwner() and v:CPPIGetOwner():IsAlly(ent:GetTarget()) then
					local pos = v:GetPos():ToScreen()
					draw.DrawText('*Detected*\n'..(v.PrintName or 'Machine'), 'DermaDefault', pos.x, pos.y, Color(255, 255, 0), 1)
				end
				
				targets[v] = true
			end
		end
	end
	
	if not holdScan then
		holdScan = CreateSound(LocalPlayer(), 'weapons/physcannon/superphys_hold_loop.wav')
	end
	
	if #table.GetKeys(targets) ~= 0 then
		holdScan:SetSoundLevel(30)
		holdScan:Play()
	else
		holdScan:Stop()
	end
end)

function ENT:Initialize()
	self.CircleRadius = 0
	local mn, mx = self:GetRenderBounds()
	self:SetRenderBounds(mn -Vector(100, 100, 100), mx +Vector(100, 100, 100))
end

function ENT:Draw()
	if self:GetTarget():IsValid() then
		if self.CircleRadius > 99 then
			self.CircleRadius = 0
		end
		
		self.CircleRadius = Lerp((CurTime() -self.LastDrawn) *2, self.CircleRadius, 100)
		cam.Start3D2D(self:GetPos() +self:GetAngles():Up() *2, self:GetAngles(), 1)
			draw.Circle(0, 0, self.CircleRadius, 'vgui/white', Color(0, 255, 0, 100))
		cam.End3D2D()
	else
		self.CircleRadius = 0
	end
	
	self:DrawModel()
	self.LastDrawn = CurTime()
end

net.Receive('bw_ents_radar', function()
	local ent = net.ReadEntity()
	
	local frame = vgui.Create('DFrame')
	frame:SetTitle('Radar Tower')
	frame:SetSize(350, 328)
	frame:Center()
	frame:MakePopup()
	frame.Paint = function()
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, 350, 328)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, 350, 24)
	end
	
	local player_list = vgui.Create('DListView', frame)
	player_list:Dock(TOP)
	player_list:SetTall(250)
	player_list:AddColumn('Player')
	player_list:AddColumn('Status')
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
				if ent:GetTarget() == ply then
					new_line:SetColumnText(2, 'Scanning...')
				else
					new_line:SetColumnText(2, '')
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

	local scan = vgui.Create('DButton', frame)
	scan:SetText('Start Scanning')
	scan:Dock(TOP)
	scan.Think = function()
		local line = player_list:GetLine(player_list:GetSelectedLine())

		if line then
			if ent:GetTarget() == line.player_attached then
				scan:SetText('Stop Scanning')
			else
				scan:SetText('Start Scanning')
			end
			
			scan:SetEnabled(true)
		else
			scan:SetEnabled(false)
		end
	end
	scan.DoClick = function()
		if ent:CanScan() then
			frame:Close()
			net.Start('bw_ents_radar')
				net.WriteEntity(ent)
				net.WriteBool(true)
				net.WriteEntity(player_list:GetLine(player_list:GetSelectedLine()).player_attached) --target
			net.SendToServer()
		else
			Derma_Message(
				'The Radar Tower needs to be turned on, powered and with at least some charge before scanning someone.',
				'Notification',
				'Ok'
			)
		end
	end
	
	local toggle = vgui.Create('DButton', frame)
	toggle:Dock(TOP)
	toggle.DoClick = function()
		--frame:Close()
		net.Start('bw_ents_radar')
			net.WriteEntity(ent)
			net.WriteBool(false)
		net.SendToServer()
	end
	toggle.Think = function()
		if ent:GetTurnedOn() then
			toggle:SetText('Turn Off')
		else
			toggle:SetText('Turn On')
		end
	end
end)