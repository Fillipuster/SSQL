/*---------------------------------------------------------------------------
Events/Hooks
---------------------------------------------------------------------------*/
hook.Add("PlayerInitialSpawn", "SSQL_InitialSpawn", function(ply)
	SSQL.players[ply:SteamID64()] = SSQL.players[ply:SteamID64()] or {};
	SSQL.LoadPlayerData(ply);
end)

hook.Add("PlayerDisconnected", "SSQL_PlyDisconnect", function(ply)
	local sid = ply:SteamID64();

	SSQL.SavePlayerData(ply);
	SSQL.players[sid] = nil;
end)

/*
hook.Add("Initialize", "SSQL_Initialize", function()
	SSQL.LoadFloatData();
end)
*/