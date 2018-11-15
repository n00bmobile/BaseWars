include('shared.lua')

function ENT:Draw() 
    self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) <= 200 *200 then
		local ang = self:GetAngles()
		local pos = self:GetPos() +ang:Up() *0.9 -ang:Forward() *4 -ang:Right() *1.8
		local amount = self:GetAmount()
	
		cam.Start3D2D(pos, ang, 0.1)
			surface.SetDrawColor(0, 0, 0, 225)
			surface.DrawRect(0, 0, 80, 36)
			draw.SimpleText('$'..amount, 'ImpactSmall', 40, 6, Color(0, 255, 0), 1)
		cam.End3D2D()
		
		ang:RotateAroundAxis(ang:Right(), 180)
		pos = pos +ang:Up() *0.9 -ang:Forward() *8
		
		cam.Start3D2D(pos, ang, 0.1)
			surface.SetDrawColor(0, 0, 0, 225)
			surface.DrawRect(0, 0, 80, 36)
			draw.SimpleText('$'..amount, 'ImpactSmall', 40, 6, Color(0, 255, 0), 1)
		cam.End3D2D()
	end
end