include('shared.lua')

function ENT:Draw() 
    self:DrawModel()
	
	local pos = self:GetPos()
	local ang = LocalPlayer():GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)
	
	cam.Start3D2D(pos +Vector(0, 0, 8), ang, 0.1)
		surface.SetFont('DermaLarge')
		draw.WordBox(4, -(surface.GetTextSize(self.PrintName) /2), 0, self.PrintName, 'DermaLarge', Color(0, 0, 0, 200), color_white)
	cam.End3D2D()
end