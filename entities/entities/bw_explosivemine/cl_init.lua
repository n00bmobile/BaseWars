include('shared.lua')

function ENT:Draw() 
    self:DrawModel()
	
	if self:GetArmed() then
		local light = DynamicLight( self:EntIndex() )
		light.pos = self:GetPos() +self:GetAngles():Up() *12
		light.r = 255
		light.g = 0
		light.b = 0
		light.brightness = 2
		light.Decay = 1000
		light.Size = 256
		light.DieTime = CurTime() +1
	end
end