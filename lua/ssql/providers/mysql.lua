MySQL = MySQL or {}

function MySQL:Connect(config, callback)
    require("mysqloo")
    
    self.db = mysqloo.connect(config.hostname, config.username, config.password, config.database, config.port or 3306)

    function self.db.onConnected()
        callback(false, string.format("%s:%i", config.hostname, config.port or 3306))
    end

    function self.db.onConnectionFailed(err)
        callback(true)
        self:Error(err)
    end

    self.db:connect()
    -- self.db:wait()
end

function MySQL:Initialize(config, callback)
    self:query([[
        CREATE TABLE IF NOT EXISTS ssql_player (
            steamid64 VARCHAR(64),
            name VARCHAR(255),
            data VARCHAR(255),
            PRIMARY KEY (steamid64, name)
        )
    ]], nil, function(err)
        if (err) then
            callback(true)
        else
            self:query([[
                CREATE TABLE IF NOT EXISTS ssql_global (
                    name VARCHAR(64) PRIMARY KEY,
                    data VARCHAR(255)
                )
            ]], nil, function(err)
                if (err) then
                    callback(true)
                else
                    callback(false)
                end
            end)
        end
    end)
end

function MySQL:SavePData(steamid64, name, data)
    if (type(data) ~= "table") then
        data = {data}
    end

    data = util.TableToJSON(data)

    self:query([[
        INSERT INTO ssql_player VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE data = ?
    ]], {steamid64, name, data, data})
end

function MySQL:SaveGData(name, data)
    if (type(data) ~= "table") then
        data = {data}
    end
    
    data = util.TableToJSON(data)

    self:query([[
        INSERT INTO ssql_global VALUES (?, ?)
        ON DUPLICATE KEY UPDATE data = ?
    ]], {name, data, data})
end

function MySQL:LoadPData(steamid64, callback)
    self:query([[
        SELECT name, data FROM ssql_player
        WHERE steamid64 = ?
    ]], {steamid64}, function(err, data)
        if (err) then
            callback(true)
        else
            local tab = {}
            for _,row in pairs(data) do
                local data = util.JSONToTable(row.data)
                tab[row.name] = #data > 1 and data or data[1]
            end

            callback(false, tab)
        end
    end)
end

function MySQL:LoadGData(callback)
    self:query([[
        SELECT * FROM ssql_global
    ]], nil, function(err, data)
        if (err) then
            callback(true)
        else
            local tab = {}
            for _,row in pairs(data) do
                local data = util.JSONToTable(row.data)
                tab[row.name] = #data > 1 and data or data[1]
            end

            callback(false, tab)
        end
    end)
end

// Based on mysqloolib by FredyH (https://github.com/FredyH/MySQLOO)
function MySQL:query(str, args, callback)
    local query = self.db:prepare(str)
    callback = callback or function() end

    local typeFunctions = {
		["string"] = function(query, index, value) query:setString(index, value) end,
		["number"] = function(query, index, value) query:setNumber(index, value) end,
		["boolean"] = function(query, index, value) query:setBoolean(index, value) end,
	}

    if (args) then
        for index,arg in pairs(args) do
            local t = type(arg)
            if (typeFunctions[t]) then
                typeFunctions[t](query, index, arg)
            else
                query:setString(index, tostring(arg))
            end
        end
    end

    function query:onAborted()
        callback("aborted")
    end

    function query:onError(err)
        callback(err)
        MySQL:Error(err)
    end

    function query:onSuccess(data)
        callback(false, data)
    end

    query:start()

    return query
end

SSQL.RegisterProvider(MySQL, "mysql")