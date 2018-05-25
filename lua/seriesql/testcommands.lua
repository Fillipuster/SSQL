/*---------------------------------------------------------------------------
Testing Commands
---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
PData
---------------------------------------------------------------------------*/
concommand.Add("ssql_ptest_set", function(ply, _, args)
	SSQL.SetPData(ply, args[1], args[2]);
end)

concommand.Add("ssql_ptest_get", function(ply, _, args)
	local result = SSQL.GetPData(ply, args[1], args[2]);
	ply:ChatPrint(result);
	print(result);
end)

concommand.Add("ssql_ptest_instances", function(ply, _, args)
	PrintTable(PData.instances);
end)

concommand.Add("ssql_ptest_runtest", function(ply)
	local function test(name, data)
		print("Setting PData `" .. tostring(name) .. "` to value `" .. tostring(data) .. "` of type `" .. type(data) .. "`...");
		SSQL.SetPData(ply, name, data);
		local result = SSQL.GetPData(ply, name, "DEFAULT_VALUE_RETURNED");
		if (type(result) == "table") then
			print("Getting PData `" .. name .. "`. Result (TABLE): ");
			PrintTable(result)
		else
			print("Getting PData `" .. name .. "`. Result: " .. tostring(result));
		end
	end

	print("Running PTest for player: " .. ply:Name());
	test("ptest0", 100);
	test("ptest1", "hello_world");
	test("ptest2", {hello = "world", num = 5});
end)

/*---------------------------------------------------------------------------
FData
---------------------------------------------------------------------------*/
concommand.Add("ssql_ftest_set", function(_, _, args)
	SSQL.SetFData(args[1], args[2]);
end)

concommand.Add("ssql_ftest_get", function(_, _, args)
	//print(SSQL.GetFData(args[1], args[2]));
	PrintTable(SSQL.GetFData(args[1], args[2]));
end)

concommand.Add("ssql_ftest_instances", function()
	PrintTable(FData.instances);
end)