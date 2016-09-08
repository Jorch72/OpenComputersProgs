--[[
	
	proxdoorctl.lua - Configuration controller for Brisingr Aerowing's Proximity Door implementation
	
]]

local config = require 'proxdoorconf'
local argparse = require 'argparse'
local util = require 'gryphonlib'

local parser = argparse():name("proxdoorctl"):description("Configuration controller for Brisingr Aerowing's Proximity Door implementation")

local set_open_time_command = parser:command("set-open-time")
set_open_time_command:argument("timeout", "The timeout in seconds"):args(1):convert(tonumber)

local set_is_blacklist_command = parser:command("set-is-blacklist")
set_is_blacklist_command:argument("is_blacklist", "True to make the player list a blacklist, false for a whitelist."):args(1):convert(util.toboolean)

local add_user_command = parser:command("add-player")
add_user_command:argument("player", "The player to add"):args(1)

local remove_user_command = parser:command("remove-player")
remove_user_command:argument("player", "The player to remove"):args(1)

local args = parser.parse()




