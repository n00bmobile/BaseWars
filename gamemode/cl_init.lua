include('shared.lua')
include('config.lua')
include('cl_hud.lua')
include('buymenu.lua')
include('factions.lua')
include('chatsystem.lua')
include('objects.lua')
include('cl_scoreboard.lua')
include('notifications.lua')
include('leveling.lua')
include('cl_menu.lua')
include('raiding.lua')
include('player.lua')

surface.CreateFont('ImpactSmall', {font = 'Impact', size = 24})
surface.CreateFont('ImpactMedium', {font = 'Impact', size = 32})
surface.CreateFont('ImpactLarge', {font = 'Impact', size = 64})
surface.CreateFont('SegoeMedium', {font = 'Segoe Print', size = 32})

function draw.Circle(x, y, radius, texture, color)
	local circle = {}
	
	for i = 1, 360 do
		local ang = i *math.pi /180
		circle[i] = {x = x+ radius *math.cos(ang), y = y +radius *math.sin(ang)}
	end
	
	surface.SetDrawColor(color or color_white)
	surface.SetTexture(surface.GetTextureID(texture))
	surface.DrawPoly(circle)
end

--PANEL
PANEL = {}
PANEL.AppendedText = nil

function PANEL:Init()
	self.AppendedText = {}
end

function PANEL:Paint()
	local space = 0

	for id, data in pairs(self.AppendedText) do
		surface.SetTextColor(data.Color)
		surface.SetTextPos(space, 0, self:GetWide(), self:GetTall())
		surface.SetFont(data.Font)
		surface.DrawText(data.Text)
		space = space +surface.GetTextSize(data.Text)
	end
	
	return true
end

function PANEL:SizeToContents()
	local wide, tall = 0, 0
	
	for id, data in pairs(self.AppendedText) do
		surface.SetFont(data.Font)
		local append_wide, append_tall = surface.GetTextSize(data.Text)
		wide = wide +append_wide
		tall = append_tall
	end
	
	self:SetSize(wide, tall)
end

function PANEL:GetText()
	local text = ''
	
	for id, data in pairs(self.AppendedText) do
		text = text..data.Text
	end
	
	return text
end

function PANEL:ClearText()
	self.AppendedText = {}
end

function PANEL:SetAppendedText(id, text, font, color)
	self.AppendedText[id or 1] = {
		Text = text or 'Undefined',
		Font = font or 'DermaDefault',
		Color = color or color_white
	}
end

function PANEL:GetAppendedText(id)
	return self.AppendedText[id]
end

vgui.Register('AppendableText', PANEL, 'Panel')