--[[

	proxdoorconf.lua - Common configuration code for Brisingr Aerowing's Proximity Door implementation

]]

local serialization = require 'serialization'
local filesystem = require 'filesystem'

local config_file = "/etc/proxdoor.conf"
local configuration = {}

local default_config = {
	open_time = 3,
	user_list_is_blacklist = false,
	user_list = {}
}

local config_table = nil

function configuration.load()
	if not filesystem.exists(config_file) then
		config_table = default_config
		return true
	end
	config_table = serialization.unserialize(io.open(config_file, "r"):read())
	return true
end

function configuration.save()
io.open(config_file, "w"):write(serialization.serialize(config_table))
return true
end

function configuration.get(key)
return config_table[key]
end

local function is_valid(key, value)

if key == 'open_time' then
if not type(value) ~= 'number' then
return false, 'key open_time requires a number'
end
else
if key == user_list_is_blacklist then
if not type(value) ~= "boolean" then
return false, 'key user_list_is_blacklist requires a boolean'
end
else
if key == 'user_list' then
if type(value) ~= "table" and type(value) ~= 'string' then
return false, "key user_list requires either a table or a string"
end
else
return false, "invalid key " .. key
end
end
end
return true
end

function configuration.set(key, value)
	if config_table == nil then
		error ("config is not initialized")
	end
	local valid_key_value, msg = is_valid(key, value)
	if not valid_key_value then
		return nil, msg
	end
config_table[key] = value
end

function configuration.list()
	if config_table == nil then
		error ("config is not initialized")
	end
	for k, v in ipairs(config_table) do
		print(k .. " = " .. v)
	end
end

return configuration
