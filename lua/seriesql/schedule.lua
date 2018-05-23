/*---------------------------------------------------------------------------
Data Saving Scheduling
---------------------------------------------------------------------------*/
if (!SSQL.config.continuousSaving && SSQL.config.autosaveInterval > 0) then
	timer.Create("SSQL_Autosave", SSQL.config.autosaveInterval, 0, function()
		MsgC(Color(255, 100, 100), "SSQL autosaving...\n")
		
		for _,pl in pairs(player.GetAll()) do
			SSQL.SavePlayerData(pl);
		end

		for name,_ in pairs(SSQL.float) do
			SSQL.SaveFloatData(name);
		end
		
		MsgC(Color(255, 100, 100), "SSQL autosave completed.\n")
	end)
end