concommand.Add("pdata_set", function(ply, _, args)
	SSQL.SetPData(ply, args[1], args[2])
	ply:ChatPrint(string.format("PData field '%s' set to value '%s'.", args[1], args[2]))
end)

concommand.Add("pdata_get", function(ply, _, args)
	local data = SSQL.GetPData(ply, args[1], "DEFAULT VALUE")
	ply:ChatPrint(string.format("PData field '%s' returned value '%s'.", args[1], data))
end)

concommand.Add("gdata_set", function(ply, _, args)
	SSQL.SetGData(args[1], args[2])
	ply:ChatPrint(string.format("GData field '%s' set to value '%s'.", args[1], args[2]))
end)

concommand.Add("gdata_get", function(ply, _, args)
	local data = SSQL.GetGData(args[1], "DEFAULT VALUE")
	ply:ChatPrint(string.format("GData field '%s' returned value '%s'.", args[1], data))
end)