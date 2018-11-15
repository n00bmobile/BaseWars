include('shared.lua')

function ENT:Draw() 
    self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) <= 200 *200 then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 90)
		local pos = self:GetPos() +ang:Up() *10.6 -ang:Forward() *14.8 -ang:Right() *16
	
		cam.Start3D2D(pos, ang, 0.1)
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, 300, 310)
			surface.SetDrawColor(self.TitleBackgroundColor)
			surface.DrawRect(0, 0, 300, 60)
		
			--info
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(10, 70, 280, 135)
			--info text
		
			--title
			draw.SimpleText('Internal Debugging', 'ImpactSmall', 148, 70, color_white, 1)
		
			--power status
			if self:IsPowered() then --HSVToColor(CurTime() *100 %360, 1, 1)
				draw.SimpleText(self:GetPowerStored()..'/'..self.MaxPower, 'ImpactLarge', 148, 85, color_white, 1)
				draw.SimpleText('Print Efficiency: '..math.floor(self:GetEfficiency() *100)..'%', 'ImpactSmall', 148, 140, color_white, 1)
			else
				if self:GetTurnedOn() then
					draw.SimpleText('NO POWER', 'ImpactLarge', 148, 85, HSVToColor(CurTime() *100 %360, 1, 1), 1)
				else
					draw.SimpleText('OFF', 'ImpactLarge', 148, 85, Color(255, 0, 0), 1)
				end
			
				draw.SimpleText('NOT PRINTING MONEY', 'ImpactSmall', 148, 140, Color(255, 0, 0), 1)
			end
		
			--upgrade details
			draw.SimpleText('Print Time: '..self:GetPrintSpeed()..' Seconds', 'ImpactSmall', 148, 160, color_white, 1)
			draw.SimpleText('Printing Capacity: $'..self:GetPrintCapacity(), 'ImpactSmall', 148, 180, color_white, 1)
		
			--money
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(10, 255 -45, 280, 40)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(15, 260 -45, 270, 30)
			--money bar
			surface.SetDrawColor(0, 255, 0)
			surface.DrawRect(15, 260 -45, 270 *(self:GetStoredMoney()/self:GetMaxStorage()), 30)
			draw.SimpleText('MONEY ($'..self:GetStoredMoney()..'/$'..self:GetMaxStorage()..')', 'ImpactSmall', 148, 264 -45, color_white, 1)
		
			--health
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(10, 255, 280, 40)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(15, 260, 270, 30)
			--health bar
			surface.SetDrawColor(255, 0, 0)
			surface.DrawRect(15, 260, 270 *(self:Health()/self:GetMaxHealth()), 30)
			draw.SimpleText('HEALTH', 'ImpactSmall', 148, 264, color_white, 1)
		cam.End3D2D()
	
		cam.Start3D2D(pos, ang, 0.08)
			draw.SimpleText(self.PrintName, 'ImpactLarge', 188, 5, color_white, 1)
		cam.End3D2D()
	end
end

local function menu(ent)
	local frame = vgui.Create('DFrame')
	frame:SetSize(300, 204)
	frame:SetIcon('icon16/wrench.png')
	frame:Center()
	frame:SetTitle(ent.PrintName..' - Upgrades')
	frame:MakePopup()
	frame.Paint = function()
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, 300, 300)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, 300, 24)
	end
	
	--SPEED UPGRADE
	for name, data in pairs(ent.Upgrades) do
		local background = vgui.Create('DPanel', frame)
		background:DockMargin(0, 0, 0, 2)
		background:Dock(TOP)
		background.Paint = function()
			draw.RoundedBox(4, 0, 0, background:GetWide(), background:GetTall(), Color(0, 0, 0, 200))
		end
	
		local info = vgui.Create('DLabel', background)
		info:DockMargin(4, 0, 0, 0)
		info:Dock(TOP)
	
		if name == 'Speed' then
			info:SetText('Upgrading the Speed of a Money Printer makes it print\nfaster, creating money in less time.')
		elseif name == 'Capacity' then
			info:SetText('Upgrading the Capacity of a Money Printer enables it to\nprint more money than usual.')
		else
			info:SetText('Upgrading the Storage of a Money Printer enables it to\nprint for extended periods of time without the worry of\nrunning out of space for more money.')
		end
	
		local upgrade = vgui.Create('DButton', background)
		upgrade:SetText('Upgrade')
		upgrade:SetSize(100)
		upgrade:DockMargin(0, 2, 2, 2)
		upgrade:Dock(RIGHT)
		
		local progress = vgui.Create('DProgress', background)
		progress:SetSize(200 -16)
		progress:DockMargin(0, 2, 2, 2)
		progress:Dock(RIGHT)
		progress.Think = function()
			progress:SetFraction(ent:FindCurrentStats(name) /#data)
		end
		upgrade.DoClick = function()
			local data = ent:GetUpgrade(name)
			
			if data then
				local msg
				
				if name == 'Speed' then
					msg = 'and will decrease the printing time to '..data.value..' seconds.'
				elseif name == 'Capacity' then
					msg = 'and will increase the printing capacity to '..BaseWars.FormatMoney(data.value)..'.'
				else
					msg = 'and will increase the money storage capacity to '..BaseWars.FormatMoney(data.value)..'.'
				end
			
				Derma_Query(
					'Upgrading this printer will cost you '..BaseWars.FormatMoney(data.price)..' '..msg..'\nAre you sure you want to do this?',
					ent.PrintName..' - Upgrade',
					'Yes',
					function()
						if LocalPlayer():CanAfford(data.price) then
							net.Start('bw_ents_mprinter')
								net.WriteEntity(ent)
								net.WriteInt(3, 3)
								net.WriteString(name)
							net.SendToServer()
						else
							Derma_Message(
								"You can't afford this upgrade!",
								'Notification',
								'Ok'
							)
						end
					end,
					'No'
				)
			else
				Derma_Message(
					'This aspect is already fully upgraded!',
					'Notification',
					'Ok'
				)
			end
		end
		
		info:SizeToContents()
		background:SetTall(25 +info:GetTall())
	end
end

net.Receive('bw_ents_mprinter', function()
	local ent = net.ReadEntity()
	
	local query = Derma_Query(
		'Choose from one of the options below',
		ent.PrintName,
		'Toggle Power',
		function()
			net.Start('bw_ents_mprinter')
				net.WriteEntity(ent)
				net.WriteInt(1, 3)
			net.SendToServer()
		end,
		'Withdrawal',
		function()
			if ent:GetStoredMoney() > 0 then
				net.Start('bw_ents_mprinter')
					net.WriteEntity(ent)
					net.WriteInt(2, 3)
				net.SendToServer()
			else
				BaseWars.Notify(1, 5, 'The printer is empty!')
			end
		end,
		'Upgrade',
		function()
			menu(ent)
		end,
		'Close'
	)
end)