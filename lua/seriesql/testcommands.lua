concommand.Add("ssql_ptest_set", function(ply, _, args)
	if (!ply:IsValid() || !ply:IsSuperAdmin()) then return; end

	SSQL.SetPData(ply, args[1], args[2]);
end)

concommand.Add("ssql_ptest_get", function(ply, _, args)
	if (!ply:IsValid() || !ply:IsSuperAdmin()) then return; end
	
	print(SSQL.GetPData(ply, args[1]));
end)

concommand.Add("ssql_ftest_set", function(_, _, args)
	SSQL.SetFData(args[1], args[2]);
end)

concommand.Add("ssql_ftest_get", function(_, _, args)
	print(SSQL.GetFData(args[1]));
end)