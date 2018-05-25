/*---------------------------------------------------------------------------
Events/Hooks
---------------------------------------------------------------------------*/
hook.Add("PlayerInitialSpawn", "SSQL_InitialSpawn", function(ply)
	SSQL.LoadPlayerData(ply);
end)

hook.Add("PlayerDisconnected", "SSQL_PlyDisconnect", function(ply)
	local pd = PData:Find(ply);

	pd:Save();
	pd:Remove();
end)