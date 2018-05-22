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
end

function SSQL.GetPData(ply, name)
	if (!ply:IsValid() || !ply:IsPlayer()) then return; end

	return SSQL.players[ply:SteamID64()].data[tostring(name)];
end