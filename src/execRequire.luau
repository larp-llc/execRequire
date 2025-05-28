local execRequire = {}

-- Variables
local moduleCache = {}

-- Functions

local function splitFilePath(filepath: string): {string}
	return filepath:split(".")
end

local function isModule(filepath: string): boolean
	local sysFilepath = filepath:gsub("%.", "\\")
	local isLuaFile = isfile(sysFilepath .. ".lua")
	local isLuauFile = isfile(sysFilepath .. ".luau")

	return isLuaFile or isLuauFile
end

local function getModuleFileExtension(filepath): string?
	if isfile(filepath .. ".lua") then
		return ".lua"
	elseif isfile(filepath .. ".luau") then
		return ".luau"
	end
end

local function loadModule(filepath: string)
	local filepaths = splitFilePath(filepath)
	local currentPath: string = ""

	local requiredFile: any
	local err: string

	for i, path in next, filepaths do
		currentPath ..= path .. (i < #filepaths and "\\" or "")

		if isModule(currentPath) then
			currentPath ..= getModuleFileExtension(currentPath)
			requiredFile, err = loadfile(currentPath)
			return requiredFile, err
		end
	end
end

local robloxRequire = require

function execRequire.require(file: string | any): any
	-- maintain compatibility with robloxs require
	local rbxRequired, result = pcall(robloxRequire, file)
	if rbxRequired then
		return result
	end

	-- custom loader
	if moduleCache[file] then
		return moduleCache[file]
	else
		local filepath = file

		print("file paths nigger")
		print("exists: " .. tostring(isModule(file)), "file: " .. file)
		print("exists: " .. tostring(isModule(file .. ".init")), "file: " .. file .. ".init")

		local isAModule = isModule(file) or isModule(file .. ".init")
		if not isAModule then
			error("Attempt to require a non-module file: '" .. file .. "'", 2)
		end

		if not isModule(filepath) and isModule(filepath .. ".init") then -- insane work
			filepath = filepath .. ".init"
		end

		local loadedModule, err = loadModule(filepath)
		if not loadedModule and err then
			error("Failed to load module '" .. filepath .. "' (" .. err .. ")", 2)
		end

		local returns = loadedModule()

		moduleCache[file] = returns

		return returns
	end
end

getgenv().require = execRequire.require
getgenv().EXEC_REQUIRE_LOADED = true

return execRequire
