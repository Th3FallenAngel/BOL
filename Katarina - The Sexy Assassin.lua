if myHero.charName ~= "Swain" then return end

-- Download script
local version = 0.000
local author = "Fallen Angel"
local SCRIPT_NAME = "Katarina - The Sexy Assassin"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Th3FallenAngel/BOL/master/Katarina%20-%20The%20Sexy%20Assassin.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Kataeina:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/Th3FallenAngel/BOL/master/version/Katarina%20TSA.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available "..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version (v"..ServerVersion..") of The Sexy Assassin by " .. author)
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

-- Download Libraries
local REQUIRED_LIBS = {
	["SxOrbWalk"] = "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
	["VPrediction"] = "https://raw.githubusercontent.com/Ralphlol/BoLGit/master/VPrediction.lua"
}


local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0

function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b><font color=\"#6699FF\">Required libraries downloaded successfully, please reload (double F9).</font>")
	end
end

for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		require(DOWNLOAD_LIB_NAME)
	else
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
	end
end

prodictionLoaded = false
if VIP_USER and FileExist(LIB_PATH.."Prodiction.lua") then
	require "Prodiction"
	prodictionLoaded = true
end

function Menu()

	Menu = scriptConfig("Katarina by Fallen Angel", "KatarinaTSA.cfg")

	Menu:addSubMenu("Key Settings", "keys")
	Menu.keys:addParam("combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Menu.keys:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	Menu.keys:addParam("laneclear", "LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("K"))
	Menu.keys:addParam("lasthit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	SxOrb:RegisterHotKey("fight", Menu.keys, "combo") 
	SxOrb:RegisterHotKey("harass", Menu.keys, "harass") 
	SxOrb:RegisterHotKey("laneclear", Menu.keys, "laneclear") 
	SxOrb:RegisterHotKey("lasthit", Menu.keys, "lasthit") 

	-- Combo
	Menu:addSubMenu("Combo", "combo")

	Menu.combo:addParam("comboItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("comboQ", "Use " .. Spells.Q.name .. " (Q)", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("comboW", "Use " .. Spells.W.name .. " (W)", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("comboE", "Use " .. Spells.E.name .. " (E)", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("comboR", "Use " .. Spells.R.name .. " (R)", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("comboRx", "Use R if x amount of people nearby", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
	
	-- Killsteal
	Menu:addSubMenu("KillSteal", "killsteal")
 	Menu.killsteal:addParam("killsteal", "KillSteal", SCRIPT_PARAM_ONOFF, false)
 	Menu.killsteal:addParam("killstealQ", "Use " .. Qspell.name .. " (Q)", SCRIPT_PARAM_ONOFF, true)
 	Menu.killsteal:addParam("killstealW", "Use " .. Wspell.name .. " (W)", SCRIPT_PARAM_ONOFF, true)
 	Menu.killsteal:addParam("killstealE", "Use " .. Espell.name .. " (E)", SCRIPT_PARAM_ONOFF, false)

	 -- Harass
	Menu:addSubMenu("Harass", "harass")
 	Menu.harass:addParam("harassQ", "Use " .. Spells.Q.name .. " (Q)", SCRIPT_PARAM_ONOFF, true)
 	Menu.harass:addParam("harassW", "Use " .. Spells.W.name .. " (W)", SCRIPT_PARAM_ONOFF, false)
 	Menu.harass:addParam("harassE", "Use " .. Spells.E.name .. " (E)", SCRIPT_PARAM_ONOFF, false)

	-- Laneclear
	Menu:addSubMenu("Laneclear", "laneclear")
	Menu.laneclear:addParam("laneclearQ", "LaneClear using Q", SCRIPT_PARAM_ONOFF, false)
	Menu.laneclear:addParam("laneclearW", "Laneclear using W", SCRIPT_PARAM_ONOFF, false)

 	--Drawings
 	Menu:addSubMenu("Drawings", "drawings")
 	Menu.drawings:addParam("draw", "Use Drawings", SCRIPT_PARAM_ONOFF, true)
 	Menu.drawings:addParam("drawQ", "Draw " .. Spells.Q.name .. " (Q)", SCRIPT_PARAM_ONOFF, true)
	Menu.drawings:addParam("drawW", "Draw " .. Spells.Q.name .. " (W)", SCRIPT_PARAM_ONOFF, true)
 	Menu.drawings:addParam("drawE", "Draw " .. Spells.W.name .. " (E)", SCRIPT_PARAM_ONOFF, true)
 	Menu.drawings:addParam("drawR", "Draw " .. Spells.R.name .. " (R)", SCRIPT_PARAM_ONOFF, true)

 	--Items
 	Menu:addSubMenu("Item Settings", "items")
 	DelayAction(function() 
 		if _G.TotallyLib_Loaded then
			MenuMisc(Menu.misc, true)
		end
 	end, 0.5)
 	

	--Orbwalker
	Menu:addSubMenu("OrbWalker", "orbwalker")
	SxOrb:LoadToMenu(Menu.orbwalker, true)

	 -- Always show
	 Menu.keys:permaShow("combo")
	 Menu.keys:permaShow("harass")
	 --Menu.killsteal:permaShow("killsteal")
	 Menu.keys:permaShow("laneclear")
	 Menu.drawings:permaShow("draw")

end 

function CheckOrbWalker()
	if _G.AutoCarry then
	    if _G.AutoCarry.Helper then
	    	SACloaded = true
	     	print("<font color=\"#20b2aa\">Katarina:</font> <font color=\"#FF0000\"> Supported Orbwalker Loaded SAC: Reborn</font>")
	    end
  	elseif _G.Reborn_Loaded then
    	DelayAction(CheckSACMMA, 1) 
	elseif _G.MMA_Loaded then
		MMAloaded = true
		print("<font color=\"#20b2aa\">Katarina:</font> <font color=\"#FF0000\"> Supported Orbwalker Loaded: MMA</font>")
	elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
		SxOrbloaded = true
		print("<font color=\"#20b2aa\">Katarina:</font> <font color=\"#FF0000\"> Supported Orbwalker Loaded: SxOrbWalk</font>")
	end 
end 