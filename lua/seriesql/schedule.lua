/*---------------------------------------------------------------------------
Data Saving Scheduling
---------------------------------------------------------------------------*/
if (!SSQL.config.continuousSaving) then
	timer.Create("SSQL_Autosave", SSQL.config.autosaveInterval, 0, function()
		MsgC(Color(255, 100, 100), "SSQL autosaving...")
		for _,pl in pairs(player.GetAll()) do
			SSQL.SavePlayerData(pl);
		end
		MsgC(Color(255, 100, 100), "SSQL autosave completed.")
	end)
end