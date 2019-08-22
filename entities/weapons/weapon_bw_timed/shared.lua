AddCSLuaFile()

SWEP.PrintName = 'Timed Explosive Charge'
SWEP.Author = 'n00bmobile'
SWEP.Contact = "n00bmobile.lua@gmail.com"
SWEP.Purpose = 'Destroy it all!'
SWEP.Instructions = 'Left-Click on any surface to plant the charge.\nRight-Click to alter the detonation time.'

SWEP.WorldModel = 'models/weapons/w_c4.mdl'
SWEP.ViewModel = 'models/weapons/v_c4.mdl' 
SWEP.ViewModelFOV = 80

SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.Primary.ClipSize	= -1	
SWEP.Primary.DefaultClip = -1	
SWEP.Primary.Automatic = true	
SWEP.Primary.Ammo	= ''

SWEP.Secondary.ClipSize	= -1	
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false	
SWEP.Secondary.Ammo	= ''

SWEP.DetonationTime = 10

function SWEP:Deploy()
	self:SetHoldType('slam')
	self:SendWeaponAnim(ACT_VM_IDLE)
end

if SERVER then
	local planted = {}

	function SWEP:Think()
		if self.AttackFinished and not self.Owner:KeyDown(IN_ATTACK) then
			self.AttackFinished = nil
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	end
	
	function SWEP:PrimaryAttack()
		local tr = self.Owner:GetEyeTrace()
	
		if tr.HitPos:DistToSqr(self.Owner:GetPos()) <= 10000 then
			if not self.AttackFinished then
				self.AttackFinished = CurTime() +2.8
				self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			elseif self.AttackFinished <= CurTime() then
				--spawn
				local ang = tr.HitNormal:Angle()
				ang:RotateAroundAxis(ang:Right(), -90)
				ang:RotateAroundAxis(ang:Up(), 180)
				local ent = ents.Create('prop_physics') --too lazy to make my own entity
				ent:SetPos(tr.HitPos)
				ent:SetAngles(ang)
				ent:SetModel('models/weapons/w_c4_planted.mdl')
				ent:Spawn()
				ent:CPPISetOwner(self.Owner)
				ent:SetSolid(SOLID_NONE)
				ent:SetMoveType(SOLID_NONE)
				ent:PhysicsInit(SOLID_NONE)
				ent.NextDeduction = CurTime() +1
				ent.NextSound = CurTime() +math.Clamp(self.DetonationTime /10, SoundDuration('weapons/c4/c4_click.wav'), 999)
				planted[ent] = self.DetonationTime
				--strip
				self.Owner:EmitSound('buttons/button14.wav', 60)
				self.Owner:StripWeapon(self:GetClass())
			end
		elseif self.AttackFinished then
			self.AttackFinished = nil
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
	end

	function SWEP:SecondaryAttack()
	    self.DetonationTime = self.DetonationTime +10
		
		if self.DetonationTime > 60 then
			self.DetonationTime = 10
		end

		self.Owner:PrintMessage(HUD_PRINTCENTER, 'DETONATE IN '..self.DetonationTime..' SECONDS')
	end
	
	hook.Add('Think', 'bw_weapons_timed', function()
		for ent, time in pairs(planted) do	
			if ent:IsValid() then
				if time == 0 then
					local effect = EffectData()
					effect:SetOrigin(ent:GetPos())
					util.Effect('Explosion', effect)
					util.BlastDamage(ent, ent:CPPIGetOwner(), ent:GetPos(), 80, 9999999999)
					ent:Remove()
				else
					if ent.NextDeduction <= CurTime() then
						planted[ent] = time -1
						ent.NextDeduction = CurTime() +1
					end
			
					if ent.NextSound <= CurTime() then
						sound.Play('weapons/c4/c4_click.wav', ent:GetPos(), 60)
						ent.NextSound = CurTime() +math.Clamp(time /10, SoundDuration('weapons/c4/c4_click.wav'), 999)
					end
				end
			else
				planted[ent] = nil
			end
		end
	end)    
else
	function SWEP:PrimaryAttack()
	end
	
	function SWEP:SecondaryAttack()
		if IsFirstTimePredicted() then
			surface.PlaySound('buttons/button17.wav')
		end
	end
end