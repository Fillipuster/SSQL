concommand.Add("ssql_test_set", function(ply, _, args)
	if (!ply:IsValid() || !ply:IsSuperAdmin()) then return; end

	SSQL.SetPData(ply, args[1], args[2]);
end)

concommand.Add("ssql_test_get", function(ply, _, args)
	if (!ply:IsValid() || !ply:IsSuperAdmin()) then return; end
	
	print(SSQL.GetPData(ply, args[1]));
end)