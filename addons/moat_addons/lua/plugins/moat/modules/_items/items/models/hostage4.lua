
ITEM.ID = 194

ITEM.Name = "Working Grandpa"

ITEM.Description = "Just your average male worker"

ITEM.Model = "models/player/hostage/hostage_04.mdl"

ITEM.Rarity = 3

ITEM.Collection = "Model Collection"

function ITEM:OnPlayerSpawn( ply )

	timer.Simple( 1, function() ply:SetModel( self.Model ) end )

end