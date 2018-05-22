SSQL.players = SSQL.players or {};

/*---------------------------------------------------------------------------
Utility Functions
---------------------------------------------------------------------------*/
function SSQL.ErrorPrint(origin, error)
	MsgC(Color(255, 100, 100), "SSQL Error from [", origin, "] reads:\n", Color(230, 230, 230), error);
	//print("SSQL Error from [" .. origin .. "] reads:\n" .. error);
end

local function SSQL.CheckDatabase(origin)
	if (SSQL.database:status() != mysqloo.DATABASE_CONNECTED) then
		MsgC(Color(255, 100, 100), "SSQL Database connection invalid/lost [", origin, "]. Attempting to reconnect.");
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
	if (!ply:IsValid() || !ply:IsPlayer() || !SSQL.CheckDatabase("SSQL.SavePlayerData")) then return; end

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
function SSQL.LoadFloatData()
	if (!SSQL.CheckDatabase("SSQL.LoadFloatData")) then return; end

	SSQL.database:PrepareQuery("SELECT * FROM seriesql_float;", {}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.LoadFloatData", data);
		else
			for _,row in pairs(data) do
				SSQL.float[row.name].data = util.JSONToTable(row.data);
			end
		end
	end)
end

function SSQL.SaveFloatData(name)
	if (!SSQL.CheckDatabase("SSQL.SaveFloatData")) then return; end

	if (SSQL.float[name] && SSQL.float[name].queueSave) then
		SSQL.database:PrepareQuery("INSERT INTO seriesql_float (name, data) VALUES(?, ?) ON DUPLICATE KEY UPDATE name = ?, data = ?;", {name, util.TableToJSON(SSQL.float[name].data)}, function(_, status, data)
			if (!status) then
				SSQL.ErrorPrint("SSQL.SaveFloatData", data);
			end
		end)
	end
end

/*
function SSQL.SaveAllFloatData()
	if (!SSQL.CheckDatabase("SSQL.SaveAllFloatData")) then return; end

	SSQL.database:PrepareQuery("SELECT name FROM seriesql_float;", {}, function(_, stauts, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.SaveAllFloatData-00", data);
		else
			local databaseNames = {};
			for _,row in pairs(data) do
				table.insert(databaseNames, row.name);
			end

			for name,tab in pairs(SSQL.float) do
				if (tab.queueSave) then
					if (table.HasValue(databaseNames, name)) then
						SSQL.database:PrepareQuery("UPDATE seriesql_float SET data = ? WHERE name = ?;", {util.TableToJSON(tab.data), name}, function(_, status, data)
							if (!status) then
								SSQL.ErrorPrint("SSQL.SaveAllFloatData-01", data);
							end
						end)
					else
						SSQL.database:PrepareQuery("UPDATE ")
					end
				end
			end
		end
	end)
end
*/