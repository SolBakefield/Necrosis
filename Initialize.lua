--[[
    Necrosis
    Copyright (C) - copyright file included in this release
--]]

-- On définit _G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

Necrosis = {}
SAO = {}
NECROSIS_ID = "Necrosis"

Necrosis.Data = {
	Version = C_AddOns.GetAddOnMetadata("Necrosis", "Version"),
	AppName = "Necrosis",
	LastConfig = C_AddOns.GetAddOnMetadata("Necrosis", "Version"),
	Enabled = false,
}

Necrosis.Data.Label = Necrosis.Data.AppName .. " " .. Necrosis.Data.Version

Necrosis.Speech = {}
Necrosis.Unit = {}
Necrosis.Translation = {}

Necrosis.Config = {}

-- SavedVariables table is loaded BEFORE addon Lua runs.
-- Do not overwrite NecrosisConfig; only create if missing, and merge defaults.
local function VersionToNumber(v)
	if type(v) ~= "string" then return 0 end
	local a, b, c = v:match("^(%d+)%.(%d+)%.(%d+)")
	return (tonumber(a) or 0) * 10000 + (tonumber(b) or 0) * 100 + (tonumber(c) or 0)
end

local function MergeDefaults(dst, src)
	for k, v in pairs(src) do
		if type(v) == "table" then
			if type(dst[k]) ~= "table" then dst[k] = {} end
			MergeDefaults(dst[k], v)
		elseif dst[k] == nil then
			dst[k] = v
		end
	end
end

NecrosisConfig = NecrosisConfig or {}


-- Any of these could generate a lot of output
Necrosis.Debug = {
	init_path   = false, -- notable points as Necrosis starts
	events      = false, -- various events tracked, chatty but informative; overlap with spells_cast
	spells_init = false, -- setting spell data and highest and helper tables
	spells_cast = false, -- spells as they are cast and some resulting actions and auras; overlap with events
	timers      = false, -- track as they are created and removed
	buttons     = false, -- buttons and menus as they are created and updated
	bags        = false, -- what is found in bags and shard management - could be very chatty on large, full bags
	tool_tips   = false, -- spell info that goes into tool tips
	speech      = false, -- steps to produce the 'speech' when summoning
}

--local ntooltip = CreateFrame("Frame", "NecrosisTooltip", UIParent, BackdropTemplateMixin and "GameTooltipTemplate");
local nbutton  = CreateFrame("Button", "NecrosisButton", UIParent, "SecureActionButtonTemplate")

-- Edit the scripts associated with the button || Edition des scripts associés au bouton
NecrosisButton:SetScript("OnEvent", function(self, event, ...)
	Necrosis:OnEvent(self, event, ...)
end)

NecrosisButton:RegisterEvent("PLAYER_LOGIN")
NecrosisButton:RegisterEvent("PLAYER_ENTERING_WORLD")


-- Events utilised by Necrosis || Events utilisés dans Necrosis
local Events = {
	"BAG_UPDATE",
	"BAG_UPDATE_COOLDOWN",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_DEAD",
	"PLAYER_ALIVE",
	"PLAYER_UNGHOST",
	"UNIT_PET",
	"UNIT_SPELLCAST_FAILED",
	"UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_SPELLCAST_SENT",
	"UNIT_MANA",
	"UNIT_HEALTH",
	"UNIT_POWER_UPDATE",
	"PLAYER_TARGET_CHANGED",
	"TRADE_REQUEST",
	"TRADE_REQUEST_CANCEL",
	"TRADE_ACCEPT_UPDATE",
	"TRADE_SHOW",
	"TRADE_CLOSED",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"SKILL_LINES_CHANGED",
	"PLAYER_LEAVING_WORLD",
	"SPELLS_CHANGED",
	"SPELL_UPDATE_USABLE",
    "SPELL_UPDATE_COOLDOWN",
    "ACTIONBAR_UPDATE_USABLE",
    "ACTIONBAR_UPDATE_COOLDOWN",

}

------------------------------------------------------------------------------------------------------
-- FONCTION D'INITIALISATION
------------------------------------------------------------------------------------------------------

function Necrosis:Initialize_Speech()
	self.Localization_Dialog()

	-- Speech could not be done using Ace...
	self.Speech.TP = {}
	local lang = ""
	lang = GetLocale()
	Necrosis.Data.Lang = lang
	if lang == "frFR" then
		self:Localization_Speech_Fr()
	elseif lang == "deDE" then
		self:Localization_Speech_De()
	elseif lang == "zhTW" then
		self:Localization_Speech_Tw()
	elseif lang == "zhCN" then
		self:Localization_Speech_Cn()
	elseif lang == "esES" or lang == "esMX" then
		self:Localization_Speech_Es()
	elseif lang == "ruRU" then
		self:Localization_Speech_Ru()
	else
		Necrosis:Localization_Speech_En()
	end
end

function Necrosis:Initialize(Config)
	local f = Necrosis.Warlock_Buttons.main.f
	if Necrosis.Debug.init_path then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- Initialize"
			.. " f:'" .. (tostring(f) or "nyl") .. "'"
		)
	end

	f = _G[f]
	-- Now ready to activate Necrosis
	f:SetScript("OnUpdate", function(self, arg1) Necrosis:OnUpdate(self, arg1) end)
	f:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	f:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	f:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	f:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Register the events used || Enregistrement des events utilisés
	for i in ipairs(Events) do
		f:RegisterEvent(Events[i])
	end

	Necrosis:Initialize_Speech()
	-- Load (or create) player configuration (SavedVariables).
	-- Never overwrite NecrosisConfig, only merge defaults in.
	NecrosisConfig = NecrosisConfig or {}

	-- Keep existing user values; add any missing defaults
	MergeDefaults(NecrosisConfig, Config)

	local cfgVer = VersionToNumber(NecrosisConfig.Version)
	local schemaVer = VersionToNumber(Necrosis.Data.LastConfig)

	-- If config is new or older than current schema, bump version
	if cfgVer == 0 or cfgVer < schemaVer then
		NecrosisConfig.Version = Necrosis.Data.LastConfig
		self:Msg(self.ChatMessage.Interface.DefaultConfig, "USER")
	else
		self:Msg(self.ChatMessage.Interface.UserConfig, "USER")
	end

	if NecrosisConfig.PetInfo then -- just in case... pet config info was redone for speech
	else
		NecrosisConfig.PetInfo = {}
	end

	if NecrosisConfig.Timers then -- just in case... was added in 7.2
	else
		NecrosisConfig.Timers = Config.Timers
	end
	--  Add new parameter between 2 version
	if NecrosisConfig.NecrosisAlphaBar then
	else
		NecrosisConfig.NecrosisAlphaBar = 85 -- just in case... was added in 7.6
	end

	Necrosis.UpdateSpellTimers(NecrosisConfig.Timers) -- init timers

	-- Création de la liste des sorts disponibles
	self:SpellSetup("Initialize")
	-- Dessine les UI et button Popoup
	self:CreateWarlockUI()
	self:CreateWarlockPopup()
	-----------------------------------------------------------
	-- Exécution des fonctions de démarrage
	-----------------------------------------------------------
	-- Affichage d'un message sur la console
	self:Msg(self.ChatMessage.Interface.Welcome, "USER")

	-- Enregistrement de la commande console
	SlashCmdList["NecrosisCommand"] = Necrosis.SlashHandler
	SLASH_NecrosisCommand1 = "/necrosis"

	-- On règle la taille de la pierre et des boutons suivant les réglages du SavedVariables
	local val = NecrosisConfig.ShadowTranceScale / 100
	--	f:SetScale(val)

	local ft = _G[Necrosis.Warlock_Buttons.trance.f]; ft:SetScale(val)
	local fb = _G[Necrosis.Warlock_Buttons.backlash.f]; fb:SetScale(val)
	local fa = _G[Necrosis.Warlock_Buttons.anti_fear.f]; fa:SetScale(val)
	local fe = _G[Necrosis.Warlock_Buttons.elemental.f]; fe:SetScale(val)

	local ftb = _G[Necrosis.Warlock_Buttons.timer.f]

	-- On définit l'affichage des Timers Graphiques à gauche ou à droite du bouton
	if _G["NecrosisTimerFrame0"] then
		NecrosisTimerFrame0:ClearAllPoints()
		NecrosisTimerFrame0:SetPoint(
			NecrosisConfig.SpellTimerJust,
			ftb,
			"CENTER",
			NecrosisConfig.SpellTimerPos * 20,
			0
		)
	end
	-- On définit l'affichage des Timers Textes à gauche ou à droite du bouton
	if _G["NecrosisListSpells"] then
		NecrosisListSpells:ClearAllPoints()
		NecrosisListSpells:SetJustifyH(NecrosisConfig.SpellTimerJust)
		NecrosisListSpells:SetPoint(
			"TOP" .. NecrosisConfig.SpellTimerJust,
			ftb,
			"CENTER",
			NecrosisConfig.SpellTimerPos * 23,
			10
		)
	end

	--On affiche ou on cache le bouton, d'ailleurs !
	if not NecrosisConfig.ShowSpellTimers then ftb:Hide() end
	-- Le Shard est-il verrouillé sur l'interface ?
	if NecrosisConfig.NoDragAll then
		self:NoDrag()
		f:RegisterForDrag("")
		ftb:RegisterForDrag("")
		ft:RegisterForDrag("")
		fb:RegisterForDrag("")
		fa:RegisterForDrag("")
		fe:RegisterForDrag("")
	else
		self:Drag()
		f:RegisterForDrag("MiddleButton")
		ftb:RegisterForDrag("MiddleButton")
		ft:RegisterForDrag("MiddleButton")
		fb:RegisterForDrag("MiddleButton")
		fa:RegisterForDrag("MiddleButton")
		fe:RegisterForDrag("MiddleButton")
	end

	-- Initialize just case the player has updated from an older version
	if NecrosisConfig.PlayerSummons == nil then
		NecrosisConfig.PlayerSummons = NecrosisConfig.ChatMsg
		NecrosisConfig.PlayerSummonsSM = false
		NecrosisConfig.PlayerSS = NecrosisConfig.ChatMsg
		NecrosisConfig.PlayerSSSM = false
	else
	end

	-- Request the localized strings - this may need events and time...
	Necrosis.UpdatePouches()

	-- If the sphere must indicate life or mana, we go there || Si la sphere doit indiquer la vie ou la mana, on y va
	Necrosis:UpdateHealth()
	Necrosis:UpdateMana()
	Necrosis:ButtonSetup()

	-- We check that the fragments are in the bag defined by the Warlock || On vérifie que les fragments sont dans le sac défini par le Démoniste
	if NecrosisConfig.SoulshardSort then
		--self:SoulshardSwitch("CHECK")
	end
end

------------------------------------------------------------------------------------------------------
-- FONCTION GERANT LA COMMANDE CONSOLE /NECRO
------------------------------------------------------------------------------------------------------

function Necrosis.SlashHandler(arg1)
	arg1 = (arg1 or ""):lower()

	if arg1:find("recall") then
		Necrosis:Recall()

	elseif arg1:find("reset") and not InCombatLockdown() then
		NecrosisConfig = {}
		ReloadUI()

	elseif arg1:find("glasofruix") then
		NecrosisConfig.Smooth = not NecrosisConfig.Smooth
		Necrosis:Msg("SpellTimer smoothing  : <lightBlue>Toggled", "USER")
		self:CreateWarlockUI()

	-- NEW: open directly to Timers panel, page 1
	elseif arg1:find("timer") and not arg1:find("timer2") then
		Necrosis:OpenConfigPanel()
		Necrosis:SetPanel(5)

		if _G["NecrosisTimersConfig1"] then NecrosisTimersConfig1:Show() end
		if _G["NecrosisTimersConfig2"] then NecrosisTimersConfig2:Hide() end
		if GameTooltip then GameTooltip:Hide() end

	-- NEW: open directly to Timers panel, page 2
	elseif arg1:find("timer2") then
		Necrosis:OpenConfigPanel()
		Necrosis:SetPanel(5)

		if _G["NecrosisTimersConfig1"] then NecrosisTimersConfig1:Hide() end
		if _G["NecrosisTimersConfig2"] then NecrosisTimersConfig2:Show() end
		if GameTooltip then GameTooltip:Hide() end

	else
		Necrosis:OpenConfigPanel()
	end
end

--_G["DEFAULT_CHAT_FRAME"]:AddMessage("Necrosis- init")
