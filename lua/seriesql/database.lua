SSQL.players = SSQL.players or {};
SSQL.float = SSQL.float or {};

/*---------------------------------------------------------------------------
Utility Functions
---------------------------------------------------------------------------*/
function SSQL.ErrorPrint(origin, error)
	MsgC(Color(255, 100, 100), "SSQL Error from [", origin, "] reads:\n", Color(230, 230, 230), error, "\n");
end

function SSQL.CheckDatabase(origin)
	if (SSQL.database:status() != mysqloo.DATABASE_CONNECTED) then
		MsgC(Color(255, 100, 100), "SSQL Database connection invalid/lost [", origin, "]. Attempting to reconnect.\n");
		SSQL.Connect();
		return false;
	else
		return true;
	end
end

/*---------------------------------------------------------------------------
Database Setup/Preperation
---------------------------------------------------------------------------*/
function SSQL.Connect()
	if (SSQL.database && SSQL.database:status() == mysqloo.DATABASE_CONNECTED) then return; end

	SSQL.database = mysqloo.CreateDatabase(SSQL.config.hostname, SSQL.config.username, SSQL.config.password, SSQL.config.database, SSQL.config.port);
	SSQL.database:wait();

	SSQL.database:RunQuery("CREATE TABLE IF NOT EXISTS seriesql_player (steamid64 VARCHAR(64) UNIQUE, data VARCHAR(255));", function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("seriesql_player table creation", data);
		end
	end);

	SSQL.database:RunQuery("CREATE TABLE IF NOT EXISTS seriesql_float (name VARCHAR(64) UNIQUE, data VARCHAR(255));", function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("seriesql_float table creation", data);
		end
	end);

	SSQL.LoadFloatData();
end

/*---------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------
Player Data (PData)
---------------------------------------------------------------------------*/
function SSQL.CreatePlayer(ply)
	if (!ply:IsValid() || !ply:IsPlayer() || !SSQL.CheckDatabase("SSQL.CreatePlayer")) then return; end

	SSQL.database:PrepareQuery("INSERT INTO seriesql_player (steamid64) VALUES (?);", {ply:SteamID64()}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.CreatePlayer", data);
		else
			SSQL.players[ply:SteamID64()].data = SSQL.players[ply:SteamID64()].data or {};
		end
	end)
end

function SSQL.LoadPlayerData(ply)
	if (!ply:IsValid() || !ply:IsPlayer() || !SSQL.CheckDatabase("SSQL.LoadPlayerData")) then return; end

	SSQL.database:PrepareQuery("SELECT data FROM seriesql_player WHERE steamid64 = ? LIMIT 1;", {ply:SteamID64()}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.LoadPlayerData", data);
		else
			if (data[1]) then
				if (next(data[1]) != nil) then
					SSQL.players[ply:SteamID64()].data = util.JSONToTable(data[1].data) or {};
				end
			else
				SSQL.CreatePlayer(ply);
			end
		end
	end)
end

function SSQL.SavePlayerData(ply)
	if (!ply:IsValid() || !ply:IsPlayer() || !SSQL.CheckDatabase("SSQL.SavePlayerData")) then return; end

	if (SSQL.players[ply:SteamID64()] && SSQL.players[ply:SteamID64()].data && SSQL.players[ply:SteamID64()].queueSave) then
		SSQL.database:PrepareQuery("UPDATE seriesql_player SET data = ? WHERE steamid64 = ?;", {util.TableToJSON(SSQL.players[ply:SteamID64()].data), ply:SteamID64()}, function(_, status, data)
			if (!status) then
				SSQL.ErrorPrint("SSQL.SavePlayerData", data);
			else
				SSQL.players[ply:SteamID64()].queueSave = false;
			end
		end)
	end
end

/*---------------------------------------------------------------------------
Float Data (FData)
---------------------------------------------------------------------------*/
function SSQL.LoadFloatData()
	if (!SSQL.CheckDatabase("SSQL.LoadFloatData")) then return; end

	SSQL.database:PrepareQuery("SELECT * FROM seriesql_float;", {}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.LoadFloatData", data);
		else
			print("\nLoadFloatData Query Return:");
			PrintTable(data);
			print(" ");
			for _,row in pairs(data) do
				if (row.data) then
					SSQL.float[row.name] = SSQL.float[row.name] or {};
					SSQL.float[row.name].data = util.JSONToTable(row.data).json;
				end
			end
		end
	end)
end

function SSQL.SaveFloatData(name)
	if (!SSQL.CheckDatabase("SSQL.SaveFloatData")) then return; end

	if (SSQL.float[name] && SSQL.float[name].queueSave) then
		local json = util.TableToJSON({json = SSQL.float[name].data});

		SSQL.database:PrepareQuery("INSERT INTO seriesql_float (name, data) VALUES(?, ?) ON DUPLICATE KEY UPDATE data = ?;", {name, json, json}, function(_, status, data)
			if (!status) then
				SSQL.ErrorPrint("SSQL.SaveFloatData", data);
			else
				SSQL.float[name].queueSave = false;
			end
		end)
	end
end

SSQL.Connect();