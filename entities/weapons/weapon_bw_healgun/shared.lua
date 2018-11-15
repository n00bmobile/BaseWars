AddCSLuaFile()
PrecacheParticleSystem('vortigaunt_beam')

SWEP.PrintName = 'Heal Gun'
SWEP.Author = 'n00bmobile'
SWEP.Contact = "n00bmobile.lua@gmail.com"
SWEP.Purpose = 'Heal, heal, heal!'
SWEP.Instructions = "Left-Click to heal the object or player you're looking at.\nYou can't move at all while healing."

SWEP.WorldModel = 'models/weapons/w_physics.mdl'
SWEP.ViewModel = 'models/weapons/c_physcannon.mdl' 
SWEP.UseHands = true

SWEP.Slot = 0
SWEP.SlotPos = 3

SWEP.Primary.ClipSize	= -1	
SWEP.Primary.DefaultClip = -1	
SWEP.Primary.Automatic = true	
SWEP.Primary.Ammo	= ''

SWEP.Secondary.ClipSize	= -1	
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true	
SWEP.Secondary.Ammo	= ''

SWEP.IsHealing = false

function SWEP:Deploy()
	self:SetHoldType('physgun')
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() +1)
	self.ShotSound = CreateSound(self.Owner, 'weapons/physcannon/energy_sing_loop4.wav')
	timer.Simple(0.8, function() if self:IsValid() then self:SendWeaponAnim(ACT_VM_IDLE) end end)
end

function SWEP:Think()
	if SERVER and self.Owner:KeyReleased(IN_ATTACK) then
		self.IsHealing = false
		self.ShotSound:Stop()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
end

function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	
	if SERVER then
		if not self.IsHealing and self.Owner:KeyDown(IN_ATTACK) then
			self.IsHealing = true
			self.ShotSound:PlayEx(1, 90)
			self:SendWeaponAnim(ACT_VM_RELOAD)
		end
		
		local health = tr.Entity:Health()
		local maxHealth = tr.Entity:GetMaxHealth()
		
		if maxHealth > 0 and health < maxHealth then
			tr.Entity:SetHealth(health +1)
			
			if tr.Entity:GetClass() == 'prop_physics' then
				local percentage = math.Clamp(health /maxHealth, 0, 1)
				tr.Entity:SetColor(Color(255, 255 *percentage, 255 *percentage))
			end
		end
	end
	
	util.ParticleTracerEx('vortigaunt_beam', tr.StartPos, tr.HitPos, false, self:EntIndex(), 1)
	self:SetNextPrimaryFire(CurTime() +0.1)
end

function SWEP:SecondaryAttack()
end

hook.Add('StartCommand', 'bw_weapons_healgun', function(ply, cmd)
	if ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == 'weapon_bw_healgun' and ply:KeyDown(IN_ATTACK) then
		cmd:RemoveKey(IN_JUMP)
		cmd:RemoveKey(IN_DUCK)
		cmd:RemoveKey(IN_SPEED)
	end
end)