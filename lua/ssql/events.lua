local function go()
	local provider = SSQL.provider
	if (provider) then
		provider:Connect(SSQL.config.providerConfig, function(failed)
			if (failed) then
				SSQL.Error("Failed to connect to provider. Retrying...")
				go()
			else
				SSQL.Message("Provider connection established.")
				provider:Initialize(SSQL.config.providerConfig, function(failed)
					if (failed) then
						SSQL.Error("Failed to initialize provider!")
					else
						SSQL.Message("Provider setup successful. SSQL ready.")
						hook.Run("ssql_ready")
					end
				end)
			end
		end)
	end
end

hook.Add("ssql_loaded", "ssql_loaded", go)

hook.Add("PlayerInitialSpawn", "ssql_playerload", function(ply)
	SSQL.provider:LoadPData(ply:SteamID64(), function(failed, data)
		if (failed) then
			SSQL.Error(string.format("Failed to load data for player %s (%s)", ply:Name(), ply:SteamID64()))
		else
			ply.ssql_data = data
		end
	end)
end)

hook.Add("PostGamemodeLoaded", "ssql_globalload", function()
	SSQL.provider:LoadGData(function(failed, data)
		if (failed) then
			SSQL.Error("Failed to load global data.")
		else
			SSQL.globalData = data
		end
	end)
end)

-- /*---------------------------------------------------------------------------
-- Events/Hooks
-- ---------------------------------------------------------------------------*/
-- hook.Add("PlayerInitialSpawn", "SSQL_InitialSpawn", function(ply)
-- 	SSQL.LoadPlayerData(ply);
-- end)

-- hook.Add("PlayerDisconnected", "SSQL_PlyDisconnect", function(ply)
-- 	local pd = PData:Find(ply);

-- 	pd:Save();
-- 	pd:Remove();
-- end)