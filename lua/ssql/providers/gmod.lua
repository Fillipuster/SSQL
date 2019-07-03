local SQLite = SQLite or {}

function SQLite:Connect(config, callback)
    callback(false)
end

function SQLite:Initialize(config, callback)
    local function pData()
        local q = sql.Query([[
            CREATE TABLE IF NOT EXISTS ssql_player (
                steamid64 VARCHAR(64),
                name VARCHAR(255),
                data VARCHAR(255),
                PRIMARY KEY (steamid64, name)
            )
        ]])

        if (q == false) then
            self:Error(sql.LastError())
            
            return false
        end

        return true
    end

    local function gData()
        local q = sql.Query([[
            CREATE TABLE IF NOT EXISTS ssql_global (
                name VARCHAR(255) PRIMARY KEY,
                data VARCHAR(255)
            )
        ]])

        if (q == false) then
            self:Error(sql.LastError())

            return false
        end

        return true
    end

    if (pData() and gData()) then callback(false) else callback(true) end
end

function SQLite:SavePData(steamid64, name, data)
    if (type(data) ~= "table") then
        data = {data}
    end

    data = util.TableToJSON(data)
    data = sql.SQLStr(data)

    local q = sql.Query(string.format([[
        REPLACE INTO ssql_player VALUES ('%s', '%s', '%s')
    ]], steamid64, name, data))

    if (q == false) then
        self:Error(sql.LastError())
    end
end

function SQLite:SaveGData(name, data)
    if (type(data) ~= "table") then
        data = {data}
    end

    data = util.TableToJSON(data)
    data = sql.SQLStr(data)

    local q = sql.Query(string.format([[
        REPLACE INTO ssql_global VALUES ('%s', '%s')
    ]], name, data))

    if (q == false) then
        self:Error(sql.LastError())
    end
end

function SQLite:LoadPData(steamid64, callback)
    local q = sql.Query(string.format([[
        SELECT name, data FROM ssql_player
        WHERE steamid64 = '%s'
    ]], steamid64))

    if (q == false) then
        callback(true)
        self:Error(sql.LastError())
    else
        if (q ~= nil) then
            local tab = {}
            for _,row in pairs(q) do
                tab[row.name] = util.JSONToTable(row.data)
            end

            callback(false, tab)
        end
    end
end

function SQLite:LoadGData(callback)
    local q = sql.Query([[SELECT name, data FROM ssql_global]])

    if (q == false) then
        callback(true)
        self:Error(sql.LastError())
    else
        if (q ~= nil) then
            local tab = {}
            for _,row in pairs(q) do
                tab[row.name] = util.JSONToTable(row.data)
            end

            callback(false, tab)
        end
    end
end

SSQL.RegisterProvider(SQLite, "gmod")