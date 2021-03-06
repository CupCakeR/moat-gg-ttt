
TALENT.ID = 3
TALENT.Suffix = "the Inferno"
TALENT.Name = "Inferno"
TALENT.NameColor = Color( 255, 0, 0 )
TALENT.NameEffect = "fire"
TALENT.Description = "Each hit has a %s_^ chance to ignite the target for %s seconds and apply 1 damage every 0.2 seconds"
TALENT.Tier = 3
TALENT.LevelRequired = { min = 25, max = 30 }

TALENT.Modifications = {}
TALENT.Modifications[1] = { min = 5, max = 10 }	-- Chance to ignite
TALENT.Modifications[2] = { min = 2, max = 10 }	-- Ignite time

TALENT.Melee = true
TALENT.NotUnique = true

function TALENT:OnPlayerHit(victim, attacker, dmginfo, talent_mods)
	if (MOAT_ACTIVE_BOSS) then return end

	local chance = self.Modifications[1].min + ( ( self.Modifications[1].max - self.Modifications[1].min ) * math.min(1, talent_mods[1]) )
	if (chance > math.random() * 100) then
		status.Inflict("Inferno", {
			Victim = victim,
			Attacker = dmginfo:GetAttacker(),
			Inflictor = dmginfo:GetInflictor(),
			Time = self.Modifications[2].min + ( ( self.Modifications[2].max - self.Modifications[2].min ) * math.min(1, talent_mods[2]) )
		})
	end
end

if (SERVER) then
	local STATUS = status.Create "Inferno"
	function STATUS:Invoke(data)
		local effect = self:GetEffectFromPlayer("Inferno", data.Victim)
		if (effect) then
			effect:AddTime(data.Time)
		else
			self:CreateEffect "Inferno":Invoke(data, data.Time, data.Victim)
		end
	end

	local EFFECT = STATUS:CreateEffect "Inferno"
	EFFECT.Message = "On Fire"
	EFFECT.Color = TALENT.NameColor
	EFFECT.Material = "icon16/weather_sun.png"
	function EFFECT:Init(data)
		local victim = data.Victim
		local radius = data.Radius or 0

		victim:Ignite(data.Time, radius)
		victim.ignite_info = {att = data.Attacker, infl = data.Inflictor}
		self:CreateEndTimer(data.Time, data)
	end

	function EFFECT:OnEnd(data)
		if (not IsValid(data.Victim)) then return end

		local victim = data.Victim

		victim:Extinguish()
	end
end