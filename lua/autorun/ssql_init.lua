if (SERVER) then
	include("ssql_config.lua")
	include("ssql/base.lua")
	include("ssql/providers.lua")

	local providersDir = "ssql/providers/"
	local files = file.Find(providersDir .. "*", "LUA")
	for _,f in pairs(files) do
		if (string.GetExtensionFromFilename(f) == "lua") then include(providersDir .. f) end
	end

	include("ssql/events.lua")
	include("ssql/api.lua")

	hook.Run("ssql_loaded")

	-- include("ssql/testcommands.lua") -- Include this to enable testing commands. Don't mess with this unless you know what you are doing!
end