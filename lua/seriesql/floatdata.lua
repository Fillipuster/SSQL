SSQL.fdata = SSQL.fdata or {};

/*---------------------------------------------------------------------------
Public Functions
---------------------------------------------------------------------------*/
function SSQL.SetFData(name, data)
	local fd = FData:Find(name);
	fd:SetData(data);
end

function SSQL.GetFData(name, default)
	local fd = FData:Find(name);

	local data = fd:GetData();

	// Ensure we don't just return an empty table.
	if (type(data) == "table" and !next(data)) then
		return default;
	end

	return fd:GetData() or default;
end

/*---------------------------------------------------------------------------
Database
---------------------------------------------------------------------------*/
function SSQL.LoadFloatData()
	if (!SSQL.CheckDatabase("SSQL.LoadFloatData")) then return; end

	SSQL.database:PrepareQuery("SELECT * FROM seriesql_float;", {}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.LoadFloatData", data);
		else
			for _,row in pairs(data) do
				if (row.data) then
					FData:Find(row.name):FromJSON(row.data);
				end
			end
		end
	end)
end

function SSQL.SaveFloatData(name)
	if (!SSQL.CheckDatabase("SSQL.SaveFloatData")) then return; end

	local fd = FData:Find(name);
	local json = fd:ToJSON();

	SSQL.database:PrepareQuery("INSERT INTO seriesql_float (name, data) VALUES(?, ?) ON DUPLICATE KEY UPDATE data = ?;", {name, json, json}, function(_, status, data)
		if (!status) then
			SSQL.ErrorPrint("SSQL.SaveFloatData", data);
		end
	end)
end