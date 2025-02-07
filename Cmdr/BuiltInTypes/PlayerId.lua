local Util = require(script.Parent.Parent.Shared.Util)
local Players = game:GetService("Players")
local PlayersController
if game:GetService("RunService"):IsClient() then
	PlayersController = require(game:GetService("ReplicatedStorage"):WaitForChild("Controllers").PlayersController)
end

local nameCache = {}
local function getUserId(name)
	if nameCache[name] then
		return nameCache[name]
	elseif Players:FindFirstChild(name) then
		nameCache[name] = Players[name].UserId
		return Players[name].UserId
	else
		local ok, userid = pcall(Players.GetUserIdFromNameAsync, Players, name)

		if not ok then
			return nil
		end

		nameCache[name] = userid
		return userid
	end
end

local playerIdType = {
	DisplayName = "Full Player Name",
	Prefixes = "# positiveInteger",

	Transform = function(text)
		local findPlayer = Util.MakeFuzzyFinder(PlayersController:GetPlayers())

		return text, findPlayer(text)
	end,

	ValidateOnce = function(text)
		return getUserId(text) ~= nil, "No player with that name could be found."
	end,

	Autocomplete = function(_, players)
		return Util.GetNames(players)
	end,

	Parse = function(text)
		return getUserId(text)
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
	cmdr:RegisterType("playerId", playerIdType)
	cmdr:RegisterType(
		"playerIds",
		Util.MakeListableType(playerIdType, {
			Prefixes = "# positiveIntegers",
		})
	)
end
