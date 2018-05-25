if (SERVER) then
	include("seriesql_config.lua");

	include("seriesql/pdata.lua");
	include("seriesql/fdata.lua");

	include("seriesql/floatdata.lua");
	include("seriesql/playerdata.lua");

	include("seriesql/mysqloolib.lua");
	include("seriesql/database.lua");

	include("seriesql/events.lua");
	include("seriesql/testcommands.lua");
end