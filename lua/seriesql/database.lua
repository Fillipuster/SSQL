/*---------------------------------------------------------------------------
Database Utility Functions
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

function SSQL.CheckPlayer(ply)
	return ply:IsValid() and ply:IsPlayer();
end

function SSQL.CheckPlayerDatabase(origin, ply)
	return SSQL.CheckDatabase(origin) and SSQL.CheckPlayer(ply);
end

/*---------------------------------------------------------------------------
Database
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
Execution
---------------------------------------------------------------------------*/
SSQL.Connect();