SSQL.pdata = SSQL.pdata or {};

/*---------------------------------------------------------------------------
Public Functions
---------------------------------------------------------------------------*/
function SSQL.SetPData(ply, name, data)
	if (!SSQL.CheckPlayer(ply)) then return; end

	local pd = PData:Find(ply);
	pd:SetData(name, data);
end

function SSQL.GetPData(ply, name, default)
	if (!SSQL.CheckPlayer(ply)) then return; end

	local pd = PData:Find(ply);
	return pd:GetData(name) or default;
end

/*---------------------------------------------------------------------------
Database
---------------------------------------------------------------------------*/
function SSQL.CreatePlayer(ply)
	if (!SSQL.CheckPlayerDatabase("SSQL.CreatePlayer", ply)) then return; end

	local sid = ply:SteamID64();

	SSQL.database:PrepareQuery("INSERT INTO seriesql_player (steamid64) VALUES (?);", {sid}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.CreatePlayer", data);
		else
			PData:Create(ply);
		end
	end)
end

function SSQL.LoadPlayerData(ply)
	if (!SSQL.CheckPlayerDatabase("SSQL.LoadPlayerData", ply)) then return; end

	local sid = ply:SteamID64();

	SSQL.database:PrepareQuery("SELECT data FROM seriesql_player WHERE steamid64 = ? LIMIT 1;", {sid}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.LoadPlayerData", data);
		else
			if (data[1]) then
				if (next(data[1]) != nil) then
					PData:Find(ply):FromJSON(data[1].data);
				end
			else
				SSQL.CreatePlayer(ply);
			end
		end
	end)
end

function SSQL.SavePlayerData(ply)
	if (!SSQL.CheckPlayerDatabase("SSQL.SavePlayerData", ply)) then return; end

	local sid = ply:SteamID64();
	local pd = PData:Find(ply);
	local json = pd:ToJSON();

	SSQL.database:PrepareQuery("UPDATE seriesql_player SET data = ? WHERE steamid64 = ?;", {json, sid}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.SavePlayerData", data);
		end
	end)
end