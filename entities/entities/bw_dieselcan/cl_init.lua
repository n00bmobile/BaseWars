include('shared.lua')

function ENT:Draw() 
    self:DrawModel()
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	
	cam.Start3D2D(pos +ang:Up() *4.1 -ang:Right() *14 -ang:Forward() *2, ang, 0.5)
		--background
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, 8, 50)
		--fuel bar
		surface.SetDrawColor(color_black)
		surface.DrawRect(1, 1, 6, 48)
		surface.SetDrawColor(0, 255, 0)
		surface.DrawRect(1, 1, 6, 48 *(self:GetFuelStored() /self.MaxFuel))
	cam.End3D2D()
end