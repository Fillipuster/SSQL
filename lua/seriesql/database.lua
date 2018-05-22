SSQL.players = SSQL.players or {};

/*---------------------------------------------------------------------------
Utility Functions
---------------------------------------------------------------------------*/
function SSQL.ErrorPrint(origin, error)
	print("SSQL Error from [" .. origin .. "] reads:\n" .. error);
end

/*---------------------------------------------------------------------------
Database Setup/Preperation
---------------------------------------------------------------------------*/
function SSQL.Connect()
	if (SSQL.database && SSQL.database:status() == mysqloo.DATABASE_CONNECTED) then return; end

	SSQL.database = mysqloo.CreateDatabase(SSQL.config.hostname, SSQL.config.username, SSQL.config.password, SSQL.config.database/*, SSQL.config.port*/);
	SSQL.database:wait();

	SSQL.database:RunQuery("CREATE TABLE IF NOT EXISTS seriesql_player (steamid64 VARCHAR(64), data VARCHAR(255));", function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("seriesql_player table creation", data);
		end
	end);

	SSQL.database:RunQuery("CREATE TABLE IF NOT EXISTS seriesql_float (name VARCHAR(255), data VARCHAR(255));", function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("seriesql_float table creation", data);
		end
	end);
end

/*---------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------*/
function SSQL.CreatePlayer(ply)
	if (!ply:IsValid() || !ply:IsPlayer()) then return; end

	if (SSQL.database:status() != mysqloo.DATABASE_CONNECTED) then
		SSQL.ErrorPrint("SSQL.CreatePlayer", "Database connection invalid/lost. Attempting to reconnect.");
		SSQL.Connect();
		return;
	end

	SSQL.database:PrepareQuery("INSERT INTO seriesql_player (steamid64) VALUES (?);", {ply:SteamID64()}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.CreatePlayer", data);
		else
			SSQL.players[ply:SteamID64()].data = SSQL.players[ply:SteamID64()].data or {};
		end
	end)
end

function SSQL.LoadPlayerData(ply)
	if (!ply:IsValid() || !ply:IsPlayer()) then return; end

	if (SSQL.database:status() != mysqloo.DATABASE_CONNECTED) then
		SSQL.ErrorPrint("SSQL.LoadPlayerData", "Database connection invalid/lost. Attempting to reconnect.");
		SSQL.Connect();
		return;
	end

	SSQL.database:PrepareQuery("SELECT data FROM seriesql_player WHERE steamid64 = ?;", {ply:SteamID64()}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.LoadPlayerData", data);
		else
			if (data[1]) then
				SSQL.players[ply:SteamID64()].data = util.JSONToTable(data[1].data) or {};
			else
				SSQL.CreatePlayer(ply);
			end
		end
	end)
end

function SSQL.SavePlayerData(ply)
	if (!ply:IsValid() || !ply:IsPlayer()) then return; end

	if (SSQL.database:status() != mysqloo.DATABASE_CONNECTED) then
		SSQL.ErrorPrint("SSQL.SavePlayerData", "Database connection invalid/lost. Attempting to reconnect.");
		SSQL.Connect();
		return;
	end

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

// FData //
function SSQL.CreateFloat(name)
	if (SSQL.database:status() != mysqloo.DATABASE_CONNECTED) then
		SSQL.ErrorPrint("SSQL.CreateFloat", "Database connection invalid/lost. Attempting to reconnect.");
		SSQL.Connect();
		return;
	end

	SSQL.database:PrepareQuery("INSERT INTO seriesql_float (name) VALUES (?);", {name}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.CreateFloat", data);
		else
			SSQL.float[name].data = SSQL.float[name].data or {};
		end
	end)
end

function SSQL.LoadFloatData()
	if (SSQL.database:status() != mysqloo.DATABASE_CONNECTED) then
		SSQL.ErrorPrint("SSQL.LoadFloatData", "Database connection invalid/lost. Attempting to reconnect.");
		SSQL.Connect();
		return;
	end

	SSQL.database:PrepareQuery("SELECT * FROM seriesql_float;", {}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.LoadFloatData", data);
		else
			if (data[1]) then
				SSQL.players[ply:SteamID64()].data = util.JSONToTable(data[1].data) or {};
			else
				SSQL.CreatePlayer(ply);
			end
		end
	end)
end