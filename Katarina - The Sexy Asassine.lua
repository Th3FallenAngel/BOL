local version = "0.001"

if myHero.charName ~= "Katarina" then return end

local lib_Required = {
	["SOW"]			= "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua",
	["VPrediction"]	= "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua"
}

local lib_downloadNeeded, lib_downloadCount = false, 0

function AfterDownload()
	lib_downloadCount = lib_downloadCount - 1
	if lib_downloadCount == 0 then
		lib_downloadNeeded = false
		print("<font color=\"#FF0000\">Katarina - The Sexy Asassine:</font> <font color=\"#FFFFFF\">Required libraries downloaded successfully, please reload (double F9).</font>")
	end
end

for lib_downloadName, lib_downloadUrl in pairs(lib_Required) do
	local lib_fileName = LIB_PATH .. lib_downloadName .. ".lua"

	if FileExist(lib_fileName) then
		require(lib_downloadName)
	else
		lib_downloadNeeded = true
		lib_downloadCount = lib_downloadCount and lib_downloadCount + 1 or 1
		DownloadFile(lib_downloadUrl, lib_fileName, function() AfterDownload() end)
	end
end

if lib_downloadNeeded then return end
 

local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Th3FallenAngel/B0L/master/Katarina%20-%20The%20Sexy%20Asassine.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH .. GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Katarina :</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end

local ServerData = GetWebResult(UPDATE_HOST, "/Th3FallenAngel/B0L/master/Katarina%20TSA.version")

if ServerData then
	ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
	if ServerVersion then
		if tonumber(version) < ServerVersion then
			AutoupdaterMsg("New version available :o ("..ServerVersion..")")
			AutoupdaterMsg("Updating, please don't press F9")
			DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
		else
			AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
		end
	end
else
	AutoupdaterMsg("Error downloading version info")
end
