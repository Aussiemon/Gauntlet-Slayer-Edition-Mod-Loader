local Mods = Mods
Mods.original_require = Mods.original_require or require
 
local original_require = Mods.original_require
local get_file_path = Mods.file.get_file_path
local file_exists = Mods.file.exists
local mod_dofile = Mods.file.dofile

require = function(filepath, ...)
	if file_exists(get_file_path(filepath, nil)) then
		return mod_dofile(filepath)
	end
	
	return original_require(filepath, ...)
end