/*---------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------*/
function SSQL.SetPData(ply, name, data, saveNow)
	if (!ply:IsValid() || !ply:IsPlayer()) then return; end

	SSQL.players[ply:SteamID64()].data[tostring(name)] = data;
	SSQL.players[ply:SteamID64()].queueSave = true;
	if (SSQL.config.continuousSaving || saveNow) then
		SSQL.SavePlayerData(ply);
	end

	if (SSQL.config.pDataBackup) then
		ply:SetPData(name, data);
	end
end

function SSQL.GetPData(ply, name)
	if (!ply:IsValid() || !ply:IsPlayer()) then return; end

	return SSQL.players[ply:SteamID64()].data[tostring(name)];
end

// FData //
function SSQL.SetFData(name, data, saveNow)
	SSQL.float[name].data = data;
	SSQL.float[name].queueSave = true;
	if (SSQL.config.continuousSaving || saveNow) then
		SSQL.SaveFloatData(name);
	end

	if (SSQL.config.pDataBackup) then
		util.SetPData("ssql_floatdata", name, data);
	end
end