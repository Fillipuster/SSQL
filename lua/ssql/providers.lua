function SSQL.RegisterProvider(provider, name)
    if (string.lower(name) == string.lower(SSQL.config.dataProvider)) then
        function provider:Message(msg)
            MsgC(Color(50, 255, 50), string.format("[SSQL-%s] %s\n", name, msg))
        end

        function provider:Error(err)
            MsgC(Color(255, 50, 50), string.format("[SSQL-%s] %s\n%s\n", name, err, debug.traceback()))
        end

        SSQL.provider = provider
    end
end