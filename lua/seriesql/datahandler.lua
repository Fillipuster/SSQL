/*---------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------*/
function SSQL.SetPData(ply, name, data, saveNow)
	if (!ply:IsValid() || !ply:IsPlayer()) then return; end
	if (data == nil) then return; end

	SSQL.players[ply:SteamID64()].data[tostring(name)] = data;
	SSQL.players[ply:SteamID64()].queueSave = true;
	if (SSQL.config.continuousSaving || saveNow) then
		SSQL.SavePlayerData(ply);
	end
end

function SSQL.GetPData(ply, name, default)
	if (!ply:IsValid() || !ply:IsPlayer()) then return; end

	local sid = ply:SteamID64();

	if (SSQL.players[sid] && SSQL.players[sid].data && SSQL.players[sid].data[tostring(name)]) then
		return SSQL.players[sid].data[tostring(name)]
	else
		return default;
	end
end

// FData //
function SSQL.SetFData(name, data, saveNow)
	if (data == nil) then return; end

	SSQL.float[name] = SSQL.float[name] or {};
	SSQL.float[name].data = data;
	SSQL.float[name].queueSave = true;
	if (SSQL.config.continuousSaving || saveNow) then
		SSQL.SaveFloatData(name);
	end
end

function SSQL.GetFData(name, default)
	if (SSQL.float[name]) then
		return SSQL.float[name].data;
	else
		return default;
	end
end