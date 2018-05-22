AddCSLuaFile("seriesql_config.lua"); 
include("seriesql_config.lua");

if (SERVER) then
	include("seriesql/mysqloolib.lua");
	include("seriesql/database.lua");
	include("seriesql/events.lua");
	include("seriesql/datahandler.lua");
	include("seriesql/schedule.lua");

	include("seriesql/testcommands.lua");
end