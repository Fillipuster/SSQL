function SSQL.SetPData(ply, name, value)
    if (ply:IsValid() and ply:IsPlayer() and type(value) ~= "function") then
        name = tostring(name)

        ply.ssql_data = ply.ssql_data or {}
        ply.ssql_data[tostring(name)] = value
        
        SSQL.provider:SetPData(ply:SteamID64(), name, value)
    end
end

function SSQL.SetGData(name, value)
    if (type(value) ~= "function") then
        name = tostring(name)

        SSQL.globalData = SSQL.globalData or {}
        SSQL.globalData[name] = value

        SSQL.provider:SetGData(name, value)
    end
end

function SSQL.GetPData(ply, name, default)
    return ply.ssql_data[tostring(name)] or default
end

function SSQL.GetGData(name, default)
    return SSQL.globalData[name] or default
end