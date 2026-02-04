--[[
    Necrosis 
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)
local L = LibStub("AceLocale-3.0"):GetLocale(NECROSIS_ID, true)

function White(str)
	return "|c00FFFFFF"..str.."|r"
end


------------------------------------------------------------------------------------------------------
-- ANCHOR FOR THE GRAPHICS/TEXT TIMER || ANCRES DES TIMERS GRAPHIQUES ET TEXTUELS
------------------------------------------------------------------------------------------------------

function Necrosis:CreateTimerAnchor()
	local ft = _G[Necrosis.Warlock_Buttons.timer.f]
	if NecrosisConfig.TimerType == 1 then
		-- Create the graphical timer frame || Création de l'ancre invisible des timers graphiques
		local f = _G["NecrosisTimerFrame0"]
		if not f then
			f = CreateFrame("Frame", "NecrosisTimerFrame0", UIParent)
			f:SetWidth(150)
			f:SetHeight(150)
			f:SetMovable(true)
			--f:EnableMouse(true)
			
			f:Show()
			f:ClearAllPoints()
			f:SetPoint(NecrosisConfig.SpellTimerJust, ft, "CENTER", NecrosisConfig.SpellTimerPos * 20, 0)
		
			f:SetScript("OnLoad", function(self)
			self:RegisterForDrag("LeftButton")
			self:RegisterForClicks("RightButtonDown")
			end)
		
		end
	elseif NecrosisConfig.TimerType == 2 then
		-- Create the text timer || Création de la liste des Timers Textes
		local FontString = _G["NecrosisListSpells"]
		if not FontString then
			FontString = ft:CreateFontString(
				"NecrosisListSpells", nil, "GameFontNormalSmall"
			)
		end
		-- Define the attributes || Définition de ses attributs
		FontString:SetJustifyH(NecrosisConfig.SpellTimerJust)
		local anchor = (NecrosisConfig.SensListe == -1)
			and ("BOTTOM" .. NecrosisConfig.SpellTimerJust)
			or ("TOP" .. NecrosisConfig.SpellTimerJust)

		local yOff = (NecrosisConfig.SensListe == -1) and -10 or 10

		FontString:ClearAllPoints()
		FontString:SetPoint(anchor, ft, "CENTER", NecrosisConfig.SpellTimerPos * 23, yOff)

		FontString:SetTextColor(1, 1, 1)
	end
end
function Necrosis:CreateWarlockUI()
------------------------------------------------------------------------------------------------------
-- TIMER BUTTON || BOUTON DU TIMER DES SORTS
------------------------------------------------------------------------------------------------------

	-- Create the timer button || Création du bouton de Timer des sorts
	local f = Necrosis.Warlock_Buttons.timer.f
	local frame = nil
	frame = _G[f]
	if not frame then
		frame = CreateFrame("Button", f, UIParent, "SecureActionButtonTemplate")
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetFrameStrata("MEDIUM")
	frame:SetMovable(true)
	--frame:EnableMouse(true)
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Normal")
	frame:SetPushedTexture("Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Pushed")
	frame:SetHighlightTexture("Interface\\AddOns\\Necrosis\\UI\\SpellTimerButton-Highlight")
	frame:RegisterForClicks("LeftButtonDown", "RightButtonDown")

	-- Create the timer anchor || Création des ancres des timers
	self:CreateTimerAnchor()
	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnLoad", function(self)
		self:RegisterForDrag("MiddleButton")
	frame:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	end)
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	--frame:SetScript("OnEnter", function(self) Necrosis:BuildTooltip(self, "SpellTimer", "ANCHOR_RIGHT", "Timer") end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop",  function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	frame:ClearAllPoints()
	frame:SetPoint(
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][1],
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][2],
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][3],
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][4],
		NecrosisConfig.FramePosition["NecrosisSpellTimerButton"][5]
	)

	frame:Show()


------------------------------------------------------------------------------------------------------
-- SPHERE NECROSIS
------------------------------------------------------------------------------------------------------

	-- Create the main Necrosis button  || Création du bouton principal de Necrosis
	frame = nil
	frame = _G["NecrosisButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisButton", UIParent, "SecureActionButtonTemplate")
		frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Shard")
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetFrameLevel(1)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(58)
	frame:SetHeight(58)
	frame:RegisterForDrag("MiddleButton")
	frame:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	frame:Show()

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	frame:ClearAllPoints()
	frame:SetPoint(
		NecrosisConfig.FramePosition["NecrosisButton"][1],
		NecrosisConfig.FramePosition["NecrosisButton"][2],
		NecrosisConfig.FramePosition["NecrosisButton"][3],
		NecrosisConfig.FramePosition["NecrosisButton"][4],
		NecrosisConfig.FramePosition["NecrosisButton"][5]
	)

	frame:SetScale((NecrosisConfig.NecrosisButtonScale / 100))
	
	-- Create the soulshard counter || Création du compteur de fragments d'âme
	local FontString = _G["NecrosisShardCount"]
	if not FontString then
		FontString = frame:CreateFontString("NecrosisShardCount", nil, "GameFontNormal")
	end

	-- Define its attributes || Définition de ses attributs , le restes des attributs sont dans Attibutes.lua - Necrosis:MainButtonAttribute()
	FontString:SetText("00")
	FontString:SetPoint("CENTER")
	FontString:SetTextColor(1, 1, 1)
end

------------------------------------------------------------------------------------------------------
-- BUTTONS for stones (health / spell / Fire), and the Mount || BOUTON DES PIERRES, DE LA MONTURE
------------------------------------------------------------------------------------------------------

local function CreateStoneButton(stone)
	-- Create the stone button || Création du bouton de la pierre
	local b = stone
	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("Create-StoneButton"
		.." i'"..tostring(stone).."'"
		.." b'"..tostring(b and b.f).."'"
		--.." tn'"..tostring(b.norm).."'"
		--.." th'"..tostring(b.high).."'"
		)
	end

	local frame = CreateFrame("Button", b.f, UIParent, "SecureActionButtonTemplate")

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture(b.norm) --("Interface\\AddOns\\Necrosis\\UI\\"..stone.."Button-01")
	frame:SetHighlightTexture(b.high) --("Interface\\AddOns\\Necrosis\\UI\\"..stone.."Button-0"..num)
	--frame:RegisterForDrag("LeftButton")
  frame:RegisterForClicks("LeftButtonDown", "MiddleButtonDown", "RightButtonDown")
	frame:Show()


	-- Edit the scripts associated with the buttons || Edition des scripts associés au bouton
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
--	frame:SetScript("OnEnter", function(self) Necrosis:BuildTooltip(self, stone, "ANCHOR_LEFT") end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self)
		if not NecrosisConfig.NecrosisLockServ then
			Necrosis:OnDragStart(self)
		end
	end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Attributes specific to the soulstone button || Attributs spécifiques à la pierre d'âme
	-- if there are no restrictions while in combat, then allow the stone to be cast || Ils permettent de caster la pierre sur soi si pas de cible et hors combat
	if stone == Necrosis.Warlock_Buttons.soul_stone.f then
		frame:SetScript("PreClick", function(self)
			if not (InCombatLockdown() or UnitIsFriend("player","target")) then
				self:SetAttribute("unit", "player")
			end
		end)
		frame:SetScript("PostClick", function(self)
			if not InCombatLockdown() then
				self:SetAttribute("unit", "target")
			end
		end)
	end

	-- Create a place for text
	-- Create the soulshard counter || Création du compteur de fragments d'âme
	local FontString = _G[b.f.."Text"]
	if not FontString then
		FontString = frame:CreateFontString(b.f, nil, "GameFontNormal")
	end

	-- Hidden but very useful...
	frame.high_of = stone
	frame.font_string = FontString

	-- Define its attributes || Définition de ses attributs
	FontString:SetText("") -- blank for now
	FontString:SetPoint("CENTER")

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if not NecrosisConfig.NecrosisLockServ then
		frame:ClearAllPoints()
		frame:SetPoint(
			NecrosisConfig.FramePosition[frame:GetName()][1],
			NecrosisConfig.FramePosition[frame:GetName()][2],
			NecrosisConfig.FramePosition[frame:GetName()][3],
			NecrosisConfig.FramePosition[frame:GetName()][4],
			NecrosisConfig.FramePosition[frame:GetName()][5]
		)
	end

	return frame
end


------------------------------------------------------------------------------------------------------
-- MENU BUTTONS || BOUTONS DES MENUS
------------------------------------------------------------------------------------------------------

local function CreateMenuButton(button)
	-- Create a Menu (Open/Close) button || Creation du bouton d'ouverture du menu
	local b = button
	local frame = CreateFrame("Button", b.f, UIParent, "SecureHandlerAttributeTemplate SecureHandlerClickTemplate SecureHandlerEnterLeaveTemplate")

	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenuButton"
		.." i'"..tostring(button).."'"
		.." b'"..tostring(b.f).."'"
		--.." tn'"..tostring(b.norm).."'"
		--.." th'"..tostring(b.high).."'"
		)
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	
	frame:SetWidth(34)
	frame:SetHeight(34)
	frame:SetNormalTexture(b.norm) 
	frame:SetHighlightTexture(b.high) 
	frame:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	frame:Show()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self)
		--if not NecrosisConfig.NecrosisLockServ then
			Necrosis:OnDragStart(self)
		--end
	end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if not NecrosisConfig.NecrosisLockServ then
		frame:ClearAllPoints()
		frame:SetPoint(
			NecrosisConfig.FramePosition[frame:GetName()][1],
			NecrosisConfig.FramePosition[frame:GetName()][2],
			NecrosisConfig.FramePosition[frame:GetName()][3],
			NecrosisConfig.FramePosition[frame:GetName()][4],
			NecrosisConfig.FramePosition[frame:GetName()][5]
		)
	end

	return frame
end

function Necrosis:CreateMenuItem(i)
	local b = nil
	
	-- look up the button info
	for idx, v in pairs (Necrosis.Warlock_Buttons) do
		if idx == i.f_ptr then
			b = v
			break
		else
		end
	end
	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateMenuItem"
		.." i'"..tostring(i.f_ptr).."'"
		.." b'"..tostring(b.f).."'"
		.." bt'"..tostring(b.tip).."'"
		.." ih'"..tostring(i.high_of).."'"
		.." s'"..tostring(Necrosis:GetSpellName(i.high_of)).."'"
		)
	end

	-- Create the button || Creation du bouton
	local frame = _G[b.f] 
	if not frame then
		frame = CreateFrame("Button", b.f, UIParent, "SecureActionButtonTemplate")

		-- Définition de ses attributs
		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:SetWidth(40)
		frame:SetHeight(40)
		frame:SetHighlightTexture(b.high) --("Interface\\AddOns\\Necrosis\\UI\\"...)
		frame:RegisterForClicks("LeftButtonDown", "RightButtonDown")

		-- ======  hidden but effective
		-- Add valuable data to the frame for retrieval later
		frame.high_of = i.high_of
		frame.pet = b.pet

		    -- Create a small timer text overlay (used for CDs/buff remaining)
    	if not frame.timer_text then
    	    local fs = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    	    fs:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    	    fs:SetText("")
    	    frame.timer_text = fs
    	end

		
		-- Set the tooltip label to the localized name if not given one already
		
		Necrosis.TooltipData[b.tip].Label = White(Necrosis.GetSpellName(i.high_of)) 
		
	end

	frame:SetNormalTexture(b.norm)
	frame:Hide()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton 
	frame:SetScript("OnEnter", function(self) 
	Necrosis:BuildButtonTooltip(self)
	--Necrosis:OnDragStart(self)
	end)
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetScript("OnLeave", function(self)
	GameTooltip:Hide() 
	--Necrosis:OnDragStop(self)
	end)
	


	--============= Special settings per button
	--
	-- Special attributes for casting certain buffs || Attributs spéciaux pour les buffs castables sur les autres joueurs
	if i == "breath" or i == "invis" then
		frame:SetScript("PreClick", function(self)
			if not (InCombatLockdown() or UnitIsFriend("player","target")) then
				self:SetAttribute("unit", "player")
			end
		end)
		frame:SetScript("PostClick", function(self)
			if not InCombatLockdown() then
				self:SetAttribute("unit", "target")
			end
		end)
	end

	-- Special attribute for the Banish button || Attributes spéciaux pour notre ami le sort de Bannissement
	if i == "banish" then
		frame:SetScale(NecrosisConfig.BanishScale/100)
	end

	return frame
end

------------------------------------------------------------------------------------------------------
-- SPECIAL POPUP BUTTONS || BOUTONS SPECIAUX POPUP
------------------------------------------------------------------------------------------------------

function Necrosis:CreateWarlockPopup()

------------------------------------------------------------------------------------------------------
	-- Create the ShadowTrance button || Creation du bouton de ShadowTrance
	local frame = nil
	frame = _G["NecrosisShadowTranceButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisShadowTranceButton", UIParent)
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\ShadowTrance-Icon")
	frame:RegisterForDrag("LeftButton")
	frame:RegisterForClicks("AnyUp")
	frame:Hide()

	-- Edit scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	frame:ClearAllPoints()
	frame:SetPoint(
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][1],
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][2],
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][3],
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][4],
		NecrosisConfig.FramePosition["NecrosisShadowTranceButton"][5]
	)

------------------------------------------------------------------------------------------------------
	-- Create the Backlash button || Creation du bouton de BackLash
	local frame = _G["NecrosisBacklashButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisBacklashButton", UIParent)
	end

	-- Definte its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\Backlash-Icon")
	frame:RegisterForDrag("LeftButton")
	frame:Hide()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnEnter", function(self) Necrosis:BuildButtonTooltip(self) end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	frame:ClearAllPoints()
	frame:SetPoint(
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][1],
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][2],
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][3],
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][4],
		NecrosisConfig.FramePosition["NecrosisBacklashButton"][5]
	)

---------------------------------------------
	-- Create the Elemental & demon alert button || 
---------------------------------------------

	-------------------------------------------------
	-- Creature Alert: range indicator (TBC safe)
	-------------------------------------------------
	local function CA_SetRangeVisual(btn, outOfRange)
		if not btn or not btn.GetNormalTexture then return end
		local tex = btn:GetNormalTexture()
		if not tex then return end

		if outOfRange then
			-- Out of range: grey + red tint
			if tex.SetDesaturated then tex:SetDesaturated(true) end
			tex:SetVertexColor(1, 0.25, 0.25)
		else
			-- In range (or unknown): normal
			if tex.SetDesaturated then tex:SetDesaturated(false) end
			tex:SetVertexColor(1, 1, 1)
		end
	end

	local function CA_EnableRangeCheck(btn, spellName)
		if not btn then return end
		btn._caSpellName = spellName
		btn._caElapsed = 0

		-- Reset visuals when hidden so it never gets "stuck" red
		btn:SetScript("OnHide", function(self)
			CA_SetRangeVisual(self, false)
		end)

		btn:SetScript("OnUpdate", function(self, elapsed)
			-- only do work if visible-ish
			if not self:IsShown() or self:GetAlpha() <= 0 then return end

			self._caElapsed = (self._caElapsed or 0) + (elapsed or 0)
			if self._caElapsed < 0.15 then return end -- throttle
			self._caElapsed = 0

			if not UnitExists("target") or UnitIsDead("target") then
				CA_SetRangeVisual(self, false)
				return
			end

			-- IsSpellInRange returns: 1 in range, 0 out of range, nil if unknown
			local r = IsSpellInRange(self._caSpellName, "target")
			if r == 0 then
				CA_SetRangeVisual(self, true)
			else
				CA_SetRangeVisual(self, false)
			end
		end)
	end


--------
--demon
--------
	frame = nil
	
	frame = _G["NecrosisCreatureAlertButton_demon"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisCreatureAlertButton_demon", UIParent,  "SecureActionButtonTemplate")
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\DemonAlert")
	frame:RegisterForDrag("MiddleButton")
	frame:RegisterForClicks("LeftButtonDown")
	--frame:SetAlpha(0/100)
	frame:Hide()
		-- Range indicator: Enslave Demon (spellID 1098)
	local enslaveName = GetSpellInfo(1098) or "Enslave Demon"
	CA_EnableRangeCheck(frame, enslaveName)

	local high = Necrosis.GetSpellCastName("enslave")
	
	if high == nil then high = "" end -- if the spell is not Know

	--else
	frame:SetAttribute("type1", "macro")
	frame:SetAttribute("macrotext1","/focus\n/cast "..high)
	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnEnter", function(self) 

		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(White(Necrosis.GetSpellName("enslave")))
		GameTooltip:AddDoubleLine(L["BUTTONS_L"], high)
		GameTooltip:Show()
	
	end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if NecrosisConfig.FramePosition then
		if NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_demon"] then
			frame:ClearAllPoints()
			frame:SetPoint(
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_demon"][1],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_demon"][2],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_demon"][3],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_demon"][4],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_demon"][5]
			)
		end
	else
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER", -50, 0)
	end

---------------
-- Elemental --
---------------

	frame = _G["NecrosisCreatureAlertButton_elemental"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisCreatureAlertButton_elemental", UIParent,  "SecureActionButtonTemplate")
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	frame:EnableMouse(true)
	--frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\ElemAlert")
	frame:RegisterForDrag("MiddleButton")
	frame:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	--frame:SetAlpha(0/100)
	frame:Hide()
		-- Range indicator: Banish (spellID 710)
	local banishName = GetSpellInfo(710) or "Banish"
	CA_EnableRangeCheck(frame, banishName)

	local hight_rank = Necrosis.GetSpellCastName("banish")
	
	local derank = ""
	
	if hight_rank == nil then 
	derank = ""
	hight_rank = ""
	else
	derank = string.gsub(hight_rank, 2, 1)
	end
	

	frame:SetAttribute("type1", "macro")
	frame:SetAttribute("type2", "macro")
	frame:SetAttribute("macrotext1","/focus\n/cast "..hight_rank)
	frame:SetAttribute("macrotext2","/focus\n/cast "..derank)
	
	

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnEnter", function(self) 
		--Necrosis:BuildButtonTooltip("ElementalToolTip")
		

		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(White(Necrosis.GetSpellName("banish")))
		GameTooltip:AddDoubleLine(L["BUTTONS_L"], hight_rank)
		GameTooltip:AddDoubleLine(L["BUTTONS_R"], derank)
		GameTooltip:Show()


	end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)


	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if NecrosisConfig.FramePosition then
		if NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_elemental"] then
			frame:ClearAllPoints()
			frame:SetPoint(
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_elemental"][1],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_elemental"][2],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_elemental"][3],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_elemental"][4],
				NecrosisConfig.FramePosition["NecrosisCreatureAlertButton_elemental"][5]
			)
		end
	else
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER", -50, 0)
	end

	
	-- TTIP
		
------------------------------------------------------------------------------------------------------
	-- Create the AntiFear button || Creation du bouton de détection des cibles protégées contre la peur
	local frame = _G["NecrosisAntiFearButton"]
	if not frame then
		frame = CreateFrame("Button", "NecrosisAntiFearButton", UIParent)
	end

	-- Define its attributes || Définition de ses attributs
	frame:SetMovable(true)
	--frame:EnableMouse(true)
	frame:SetFrameStrata("HIGH")
	frame:SetWidth(40)
	frame:SetHeight(40)
	frame:SetNormalTexture("Interface\\AddOns\\Necrosis\\UI\\AntiFear-01")
	frame:RegisterForDrag("MiddleButton")
	frame:Hide()

	-- Edit the scripts associated with the button || Edition des scripts associés au bouton
	frame:SetScript("OnMouseUp", function(self) Necrosis:OnDragStop(self) end)
	frame:SetScript("OnDragStart", function(self) Necrosis:OnDragStart(self) end)
	frame:SetScript("OnDragStop", function(self) Necrosis:OnDragStop(self) end)

	-- Place the button window at its saved location || Placement de la fenêtre à l'endroit sauvegardé ou à l'emplacement par défaut
	if NecrosisConfig.FramePosition then
		if NecrosisConfig.FramePosition["NecrosisAntiFearButton"] then
			frame:ClearAllPoints()
			frame:SetPoint(
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][1],
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][2],
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][3],
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][4],
				NecrosisConfig.FramePosition["NecrosisAntiFearButton"][5]
			)
		end
	else
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER", 50, 0)
	end
end


------------------------------------------------------------------------------------------------------
-- CREATE BUTTONS ON DEMAND || CREATION DES BOUTONS A LA DEMANDE
------------------------------------------------------------------------------------------------------
function Necrosis:CreateSphereButtons(button_info)
	if Necrosis.Debug.buttons then
		_G["DEFAULT_CHAT_FRAME"]:AddMessage("CreateSphereButtons"
		.." f'"..tostring(button_info.f).."'"
		)
	end
	if button_info.menu then
		return CreateMenuButton(button_info)
	else
		return CreateStoneButton(button_info)
	end
end

