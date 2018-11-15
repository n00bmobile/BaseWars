if SERVER then
	util.AddNetworkString('bw_notify')

	function BaseWars.Notify(target, type, time, msg)
		net.Start('bw_notify')
			net.WriteBool(true)
			net.WriteUInt(type, 4)
			net.WriteUInt(time, 8)
			net.WriteString(msg)
		net.Send(target)
	end

	function BaseWars.AddNotification(target, type, msg)
		net.Start('bw_notify')
			net.WriteBool(false)
			net.WriteUInt(type, 4)
			net.WriteString(msg)
		net.Send(target)
	end
return end

local board = {}
local generic = Material('icon16/information.png')
local warning = Material('icon16/exclamation.png')
local monetary = Material('icon16/money.png')
local help = Material('icon16/help.png')

function BaseWars.AddNotification(type, msg)
	if not board.base then
		local base = vgui.Create('DPanel')
		base:SetPos(5, 5)
		base.Paint = function()
			draw.RoundedBox(6, 0, 0, base:GetWide(), base:GetTall(), Color(0, 0, 0, 200))
		
			for k, v in pairs(board.labels) do
				local x, y = v[1]:GetPos()
				local type = v[2]
				
				if type == 2 then
					surface.SetDrawColor(255, 255, 255)
						surface.SetMaterial(warning)
					surface.DrawTexturedRect(8, y, 16, 16)	
				elseif type == 3 then
					surface.SetDrawColor(255, 255, 255)
						surface.SetMaterial(monetary)
					surface.DrawTexturedRect(8, y, 16, 16)		
				elseif type == 4 then
					surface.SetDrawColor(255, 255, 255)
						surface.SetMaterial(help)
					surface.DrawTexturedRect(8, y, 16, 16)
				else
					surface.SetDrawColor(255, 255, 255)
						surface.SetMaterial(generic)
					surface.DrawTexturedRect(8, y, 16, 16)
				end
			end
		end
		
		board = {
			base = base, 
			labels = {}
		}
	end

	if #board.labels == 10 then --max = 10
		board.labels[10][1]:Remove()
		table.remove(board.labels, 10)
	end
	
	local base = board.base
	local lbl = vgui.Create('DLabel', base)
	lbl:SetFont('HudHintTextLarge')
	lbl:SetPos(26, 10)
	lbl:SetText(os.date('%H:%M', os.time())..': '..msg)
	lbl:SizeToContents()
	
	if type == 2 then
		lbl:SetColor(Color(255, 0, 0))
	elseif type == 3 then
		lbl:SetColor(Color(0, 255, 0))
	elseif type == 4 then
		lbl:SetColor(Color(0, 255, 255))
	else
		lbl:SetColor(color_white)
	end
	
	local wide, tall = lbl:GetSize()
	local total = tall +20
	
	for k, v in pairs(board.labels) do
		local wide2, tall2 = v[1]:GetSize()
		v[1]:MoveTo(26, total, 0.25)
		total = total +tall2 +10
		
		if wide2 > wide then
			wide = wide2
		end
	end
	
	base:SizeTo(wide +35, total, 0.25)
	table.insert(board.labels, 1, {lbl, type})
	surface.PlaySound('buttons/button14.wav')
	MsgC(Color(255, 0, 0), '[Base Wars]', color_white, ': '..msg..'\n')
end

function BaseWars.Notify(type, time, msg)
	notification.AddLegacy(msg, type, time)
	surface.PlaySound('buttons/lightswitch2.wav')
	MsgC(Color(255, 0, 0), '[Base Wars]', color_white, ': '..msg..'\n')
end

net.Receive('bw_notify', function()
	if net.ReadBool() then --is standard notification
		BaseWars.Notify(net.ReadUInt(4), net.ReadUInt(8), net.ReadString())
	else
		BaseWars.AddNotification(net.ReadUInt(4), net.ReadString())
	end
end)