function SSQL.Message(msg)
    MsgC(Color(50, 255, 50), string.format("[SSQL] %s\n", msg))
end

function SSQL.Error(err)
    MsgC(Color(255, 50, 50), string.format("[SSQL] %s\n", err))
end