/*---------------------------------------------------------------------------
Testing Commands
---------------------------------------------------------------------------*/
// PTest //
concommand.Add("ssql_ptest_table", function(ply, _, args)
	PrintTable(SSQL.players[ply:SteamID64()]);
end)

concommand.Add("ssql_ptest_get", function(ply, _, args)
	if (!ply:IsValid() || !ply:IsSuperAdmin()) then return; end
	
	print(SSQL.GetPData(ply, args[1]));
end)

concommand.Add("ssql_ptest_set", function(ply, _, args)
	if (!ply:IsValid() || !ply:IsSuperAdmin()) then return; end

	SSQL.SetPData(ply, args[1], args[2]);
end)

concommand.Add("ssql_ptest_settable", function(ply, _, args)
	if (!ply:IsValid() || !ply:IsSuperAdmin()) then return; end

	SSQL.SetPData(ply, args[1], {
		lots = 420,
		["of"] = "69",
		[1337] = "test",
		data = {yay = 7913}
	});
end)

concommand.Add("ssql_ptest_reload", function(ply)
	SSQL.LoadPlayerData(ply);
end)

// FTest //
concommand.Add("ssql_ftest_table", function()
	PrintTable(SSQL.float);
end)

concommand.Add("ssql_ftest_get", function(_, _, args)
	print(SSQL.GetFData(args[1]));
end)

concommand.Add("ssql_ftest_set", function(_, _, args)
	SSQL.SetFData(args[1], args[2]);
end)

concommand.Add("ssql_ftest_settable", function(ply, _, args)
	SSQL.SetFData(args[1], {
		lots = 420,
		["of"] = "69",
		[1337] = "test",
		data = {yay = 7913}
	});
end)

concommand.Add("ssql_ftest_reload", function()
	SSQL.LoadFloatData();
end)