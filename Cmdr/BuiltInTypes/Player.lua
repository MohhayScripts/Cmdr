local Util = require(script.Parent.Parent.Shared.Util)
local PlayersController = require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers").PlayersController)

local playerType = {
	Transform = function(text)
		local findPlayer = Util.MakeFuzzyFinder(PlayersController:GetPlayers())

		return findPlayer(text)
	end,

	Validate = function(players)
		return #players > 0, "No player with that name could be found."
	end,

	Autocomplete = function(players)
		return Util.GetNames(players)
	end,

	Parse = function(players)
		return players[1]
	end,

	Default = function(player)
		return player.Name
	end,

	ArgumentOperatorAliases = {
		me = ".",
		all = "*",
		others = "**",
		nearby = "***",
		random = "?",
	},
}

return function(cmdr)
	cmdr:RegisterType("player", playerType)
	cmdr:RegisterType(
		"players",
		Util.MakeListableType(playerType, {
			Prefixes = "% teamPlayers",
		})
	)
end
