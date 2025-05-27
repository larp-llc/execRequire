local execRequire = {}

-- Variables
local moduleCache = {}

-- Functions

local function verifyFile(filepath: string): boolean
	return isfile(filepath)
end

local function isModule(filepath: string): boolean
	local isLuaFile = select(1, filepath:find(".lua")) ~= nil
	local isLuauFile = select(1, filepath:find(".luau")) ~= nil
	return verifyFile(filepath) and (isLuaFile or isLuauFile)
end

local function splitFilePath(filepath: string): {string}
	return filepath:split("\\")
end

local function loadFile(filepath: string)
	local filepaths = splitFilePath(filepath)
	local currentPath: string = "."

	local requiredFile: any
	local err: string

	for i, path in next, filepaths do
		currentPath ..= "\\" .. path

		if isModule(currentPath) then
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
		local exists = verifyFile(file)
		if not exists then
			error("Attempt to require an invalid file: '" .. file .. "'", 2)
		end

		local isAModule = isModule(file)
		if not isAModule then
			error("Attempt to require a non-module file: '" .. file .. "'", 2)
		end

		local loadedModule, err = loadFile(file)
		if not loadedModule and err then
			error("Failed to load module '" .. file .. "' (" .. err .. ")", 2)
		end

		local returns = loadedModule()

		moduleCache[file] = returns

		return returns
	end
end

getgenv().require = execRequire.require
getgenv().EXEC_REQUIRE_LOADED = true

return execRequire
