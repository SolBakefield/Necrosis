--[[
    Necrosis
    Copyright (C) - copyright file included in this release
--]]

-- On définit G comme étant le tableau contenant toutes les frames existantes.
local _G = getfenv(0)

local NECROSIS_COMPANIONS_PER_PAGE = 12;
local NECROSIS_PAGE_NUMBER = "Page %s of %s";

-- Hack due to an unkown bug. THIS IS TO BE FIXED
function CompanionButton_OnLoad(self)
	self:RegisterForDrag("LeftButton");
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

------------------------------------------------------------------------------------------------------
-- CREATION DE LA FRAME DES OPTIONS
------------------------------------------------------------------------------------------------------

-- On crée ou on affiche le panneau de configuration de la sphere
function Necrosis:SetButtonsConfig()
	local frame = _G["NecrosisButtonsConfig"]
	if not frame then
		-- Création de la fenêtre
		frame = CreateFrame("Frame", "NecrosisButtonsConfig", NecrosisGeneralFrame)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT")

		-- Création de la sous-fenêtre 1
		frame = CreateFrame("Frame", "NecrosisButtonsConfig1", NecrosisButtonsConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetAllPoints(NecrosisButtonsConfig)

		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 90, 95)
		FontString:SetText("1 / 2")

		FontString = frame:CreateFontString("NecrosisButtonsConfig1Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("TOP", frame, "TOP", 85, -25)

		-- Boutons
		frame = CreateFrame("Button", nil, NecrosisButtonsConfig1, "UIPanelButtonTemplate")
		frame:SetSize(80, 22)
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisButtonsConfig1, "BOTTOMRIGHT", 120, 100)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig2:Show()
			NecrosisButtonsConfig1:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisButtonsConfig1, "UIPanelButtonTemplate")
		frame:SetSize(80, 22)
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig1, "BOTTOMLEFT", 40, 100)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig2:Show()
			NecrosisButtonsConfig1:Hide()
		end)

		-- Création de la sous-fenêtre 2
		frame = CreateFrame("Frame", "NecrosisButtonsConfig2", NecrosisButtonsConfig)
		frame:SetFrameStrata("DIALOG")
		frame:SetMovable(false)
		frame:EnableMouse(true)
		frame:SetWidth(350)
		frame:SetHeight(452)
		frame:Hide()
		frame:ClearAllPoints()
		frame:SetAllPoints(NecrosisButtonsConfig)

		local FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", frame, "BOTTOM", 90, 95)
		FontString:SetText("2 / 2")

		FontString = frame:CreateFontString("NecrosisButtonsConfig2Text", nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("TOP", frame, "TOP", 90, -60)

		-- Boutons de navigation
		frame = CreateFrame("Button", nil, NecrosisButtonsConfig2, "UIPanelButtonTemplate")
		frame:SetSize(80, 22)
		frame:SetText(">>>")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("RIGHT", NecrosisButtonsConfig2, "BOTTOMRIGHT", 120, 100)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig1:Show()
			NecrosisButtonsConfig2:Hide()
		end)

		frame = CreateFrame("Button", nil, NecrosisButtonsConfig2, "UIPanelButtonTemplate")
		frame:SetSize(80, 22)
		frame:SetText("<<<")
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig2, "BOTTOMLEFT", 40, 100)

		frame:SetScript("OnClick", function()
			NecrosisButtonsConfig1:Show()
			NecrosisButtonsConfig2:Hide()
		end)

		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Sub Menu 1
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Attach or detach the necrosis buttons || Attache ou détache les boutons de Necrosis
		frame = CreateFrame("CheckButton", "NecrosisLockButtons", NecrosisButtonsConfig1, "UICheckButtonTemplate")
		frame:EnableMouse(true)
		frame:SetWidth(24)
		frame:SetHeight(24)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", NecrosisButtonsConfig1, "BOTTOMLEFT", 40, 400)

		frame:SetScript("OnClick", function(self)
			if (self:GetChecked()) then
				NecrosisConfig.NecrosisLockServ = true
				Necrosis:ClearAllPoints()
				Necrosis:ButtonSetup()
				Necrosis:NoDrag()
				if not NecrosisConfig.NoDragAll then
					NecrosisButton:RegisterForDrag("MiddleButton")
					NecrosisSpellTimerButton:RegisterForDrag("MiddleButton")
				end
			else
				NecrosisConfig.NecrosisLockServ = false
				Necrosis:ClearAllPoints()
				local ButtonName = {
					Necrosis.Warlock_Buttons.fire_stone.f, --"NecrosisFirestoneButton",
					Necrosis.Warlock_Buttons.spell_stone.f, --"NecrosisSpellstoneButton",
					Necrosis.Warlock_Buttons.health_stone.f, --"NecrosisHealthstoneButton",
					Necrosis.Warlock_Buttons.soul_stone.f, --"NecrosisSoulstoneButton",
					Necrosis.Warlock_Buttons.buffs.f, --"NecrosisBuffMenuButton",
					Necrosis.Warlock_Buttons.mounts.f, --"NecrosisMountButton",
					Necrosis.Warlock_Buttons.pets.f, --"NecrosisPetMenuButton",
					Necrosis.Warlock_Buttons.curses.f, --"NecrosisCurseMenuButton"
					Necrosis.Warlock_Buttons.destroy_shards.f, --"NecrosisDestroyShardsButton"
				}
				local loc = { -168, -126, -84, -42, 0, 42, 84, 126, 168 }
				for i in ipairs(ButtonName) do
					if _G[ButtonName[i]] then
						_G[ButtonName[i]]:SetPoint("CENTER", "UIParent", "CENTER", loc[i], -90)
						NecrosisConfig.FramePosition[ButtonName[i]] = {
							"CENTER",
							"UIParent",
							"CENTER",
							loc[i],
							-90
						}
					end
				end
				Necrosis:Drag()
				NecrosisConfig.NoDragAll = false
				NecrosisButton:RegisterForDrag("MiddleButton")
				NecrosisSpellTimerButton:RegisterForDrag("MiddleButton")
			end
		end)

		FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
		FontString:SetTextColor(1, 1, 1)
		frame:SetFontString(FontString)

		-- Affiche ou cache les boutons autour de Necrosis
		local boutons = { "Firestone", "Spellstone", "HealthStone", "Soulstone", "BuffMenu", "Mount", "PetMenu",
			"CurseMenu", "DestroyShards" }
		local initY = 380
		for i in ipairs(boutons) do
			frame = CreateFrame("CheckButton", "NecrosisShow" .. boutons[i], NecrosisButtonsConfig1,
				"UICheckButtonTemplate")
			frame:EnableMouse(true)
			frame:SetWidth(24)
			frame:SetHeight(24)
			frame:Show()
			frame:ClearAllPoints()
			frame:SetPoint("LEFT", NecrosisButtonsConfig1, "BOTTOMLEFT", 40, initY - (25 * i))

			frame:SetScript("OnClick", function(self)
				if (self:GetChecked()) then
					NecrosisConfig.StonePosition[i] = math.abs(NecrosisConfig.StonePosition[i])
				else
					NecrosisConfig.StonePosition[i] = -math.abs(NecrosisConfig.StonePosition[i])
				end
				--print (boutons[i])
				Necrosis:ButtonSetup()
			end)

			FontString = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
			FontString:Show()
			FontString:ClearAllPoints()
			FontString:SetPoint("LEFT", frame, "RIGHT", 5, 1)
			FontString:SetTextColor(1, 1, 1)
			frame:SetFontString(FontString)
		end

		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Sub Menu 2
		-- lets create a hidden frame container for the mount selection buttons

		frame = CreateFrame("Frame", "NecrosisMountsSelectionFrame", NecrosisButtonsConfig2, "BackdropTemplate")
		frame:SetWidth(222);
		frame:SetHeight(75);
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", NecrosisGeneralFrame, "CENTER", 0, -25)

		-- frame:SetBackdrop({
		-- 	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		-- 	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		-- 	tile = true,
		-- 	tileSize = 16,
		-- 	edgeSize = 16,
		-- 	insets = { left = 4, right = 4, top = 4, bottom = 4 }
		-- });
		-- frame:SetBackdropColor(0, 0, 0, 1);

		-- create the left/right mount containers which will hold the selected mounts
		frame = CreateFrame("CheckButton", "NecrosisSelectedMountLeft", NecrosisMountsSelectionFrame,
			"UIPanelButtonTemplate")
		frame:SetSize(32, 22)
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", -25, 25)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
		frame:SetScript("OnClick", NecrosisSelectedMountButton_OnClick)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)

		frame = CreateFrame("CheckButton", "NecrosisSelectedMountRight", NecrosisMountsSelectionFrame,
			"UIPanelButtonTemplate")
		frame:SetSize(32, 22)
		frame:EnableMouse(true)
		frame:Show()
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", 25, 25)
		frame:SetScript("OnEnter", NecrosisCompanionButton_OnEnter)
		frame:SetScript("OnClick", NecrosisSelectedMountButton_OnClick)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnReceiveDrag", NecrosisSelectedMountButton_OnReceiveDrag)

		local FontString = frame:CreateFontString("NecrosisChooseMountsText", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("BOTTOM", NecrosisMountsSelectionFrame, "TOP", 0, 70)
		FontString:SetTextColor(1, 1, 1)
		--TODO: translate this
		FontString:SetText("Drag a mount item|spell onto the buttons below to set your preferred mounts.");

		local FontString = frame:CreateFontString("NecrosisLeftMountText", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("RIGHT", NecrosisSelectedMountLeft, "LEFT", -10, 0)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(self.Config.Buttons["Monture - Clic gauche"])

		local FontString = frame:CreateFontString("NecrosisRightMountText", "OVERLAY", "GameFontNormalSmall")
		FontString:Show()
		FontString:ClearAllPoints()
		FontString:SetPoint("LEFT", NecrosisSelectedMountRight, "RIGHT", 10, 0)
		FontString:SetTextColor(1, 1, 1)
		FontString:SetText(self.Config.Buttons["Monture - Clic droit"])
	end

	-- the frame is created, so set some defaults
	NecrosisMountsSelectionFrame.idMount = GetCompanionInfo("MOUNT", 1);

	-- set to 1st page
	Necrosis:SetCompanionPage(0)

	-- make sure our mount buttons are updated
	Necrosis:UpdateMountButtons()

	-- the spellID's (not creatureID's) for the selected left & right mounts are stored in savedvariables
	-- if nothing is specified (empty / reset config) then use felsteed (5784) and dreadsteed (23161) as the default spellids
	if (NecrosisConfig.LeftMount) then
		NecrosisInitSelectedMountButton(NecrosisSelectedMountLeft, NecrosisConfig.LeftMount);
	else
		NecrosisInitSelectedMountButton(NecrosisSelectedMountLeft, 5784);
	end

	if (NecrosisConfig.RightMount) then
		NecrosisInitSelectedMountButton(NecrosisSelectedMountRight, NecrosisConfig.RightMount);
	else
		NecrosisInitSelectedMountButton(NecrosisSelectedMountRight, 23161);
	end



	NecrosisLockButtons:SetChecked(NecrosisConfig.NecrosisLockServ)

	local boutons = { "Firestone", "Spellstone", "HealthStone", "Soulstone", "BuffMenu", "Mount", "PetMenu", "CurseMenu",
		"DestroyShards" }
	for i in ipairs(boutons) do
		_G["NecrosisShow" .. boutons[i]]:SetChecked(NecrosisConfig.StonePosition[i] > 0)
		_G["NecrosisShow" .. boutons[i]]:SetText(self.Config.Buttons.Name[i])
	end

	NecrosisButtonsConfig1Text:SetText(self.Config.Buttons["Choix des boutons a afficher"])
	NecrosisButtonsConfig2Text:SetText(self.Config.Buttons["Utiliser mes propres montures"])

	NecrosisLockButtons:SetText(self.Config.Buttons["Fixer les boutons autour de la sphere"])

	local frame = _G["NecrosisButtonsConfig"]
	frame:Show()
end

------------------------------------------------------------------------------------------------------
-- MOUNT FUNCTIONS
------------------------------------------------------------------------------------------------------
function Necrosis:SetCompanionPage(num)
	NecrosisMountsSelectionFrame.pageMount = num;

	num = num + 1; --For easier usage
	--local maxpage = ceil(GetNumCompanions("MOUNT")/NECROSIS_COMPANIONS_PER_PAGE);
	C_MountJournal.SetAllTypeFilters(true)
	C_MountJournal.SetCollectedFilterSetting(1, true)
	C_MountJournal.SetCollectedFilterSetting(2, false)

	local maxpage = ceil(C_MountJournal.GetNumDisplayedMounts() / NECROSIS_COMPANIONS_PER_PAGE);




	

	Necrosis:UpdateMountButtons();
	--PetPaperDollFrame_UpdateCompanionCooldowns();
end

function Necrosis:UpdateMountButtons()
	-- TBC Anniversary has no mount journal / companion mount data
	if not self.Data or not self.Data.Mounts then
		-- Hide all companion buttons safely
		for i = 1, NECROSIS_COMPANIONS_PER_PAGE do
			button = _G["NecrosisCompanionButton" .. i];
			if button then
				id = i + (offset or 0);

				-- All the existing logic remains inside this block.
				-- Example:
				button.creatureID = name;
				button.spellID = spellID;

				if icon then
					button:SetNormalTexture(icon);
					button:Enable();
				else
					button:Disable();
				end

				local activeTex = _G["NecrosisCompanionButton" .. i .. "ActiveTexture"]
				if activeTex then
					if isCollected then
						activeTex:Show();
					else
						activeTex:Hide();
					end
				end
			end
		end

		return
	end
	local button, iconTexture, id;
	local creatureID, creatureName, spellID, icon, active;
	local offset, selected;

	offset = (NecrosisMountsSelectionFrame.pageMount or 0) * NECROSIS_COMPANIONS_PER_PAGE;
	--offset = 0;
	selected = FindCompanionIndex(NecrosisMountsSelectionFrame.idMount);
	--selected = 0;

	for i = 1, NECROSIS_COMPANIONS_PER_PAGE do
		button = _G["NecrosisCompanionButton" .. i];
		if button then
			id = i + (offset or 0);
			name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID =
			C_MountJournal.GetDisplayedMountInfo(id);

			button.creatureID = name;
			button.spellID = spellID;
			button.active = isCollected;

			if name then
				button:SetNormalTexture(icon);
				button:Enable();
			else
				button:Disable();
			end

			local activeTex = _G["NecrosisCompanionButton" .. i .. "ActiveTexture"];
			if activeTex then
				if isCollected then
					activeTex:Show();
				else
					activeTex:Hide();
				end
			end
		end
	end


	if (selected > 0) then
		--creatureID, creatureName, spellID, icon, active = GetCompanionInfo("MOUNT", selected);
		creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID =
		C_MountJournal.GetMountInfoByID(selected)
		creatureID = creatureName;
	end
	if (active and creatureID) then
		--			CompanionSummonButton:SetText(PetPaperDollFrameCompanionFrame.mode == "MOUNT" and BINDING_NAME_DISMOUNT or PET_DISMISS);
		--		else
		--			CompanionSummonButton:SetText(PetPaperDollFrameCompanionFrame.mode == "MOUNT" and MOUNT or SUMMON);
		--		end
	end
end

function FindCompanionIndex(creatureID, mode)
	--[[
	if ( not mode ) then
		mode = NecrosisMountsSelectionFrame.mode;
	end
	if (not creatureID ) then
		creatureID = (NecrosisMountsSelectionFrame.mode=="MOUNT") and NecrosisMountsSelectionFrame.idMount or NecrosisMountsSelectionFrame.idCritter;
	end
--]]
	--for i=1,GetNumCompanions("MOUNT") do
	for i = 1, C_MountJournal.GetNumDisplayedMounts() do
		if (GetCompanionInfo("MOUNT", i) == creatureID) then
			return i;
		end
	end
	return 0
end

function NecrosisCompanionButton_OnDrag(self)
	local offset = (NecrosisMountsSelectionFrame.pageMount or 0) * NECROSIS_COMPANIONS_PER_PAGE;
	local dragged = self:GetID() + offset;
	PickupCompanion("MOUNT", dragged);
end

function NecrosisCompanionButton_OnEnter(self)
	if (GetCVar("UberTooltips") == "1") then
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	end

	if (self.spellID) then
		if (GameTooltip:SetHyperlink("spell:" .. self.spellID)) then
			self.UpdateTooltip = NecrosisCompanionButton_OnEnter;
		else
			self.UpdateTooltip = nil;
		end
	end
	GameTooltip:Show()
end

function NecrosisSelectedMountButton_OnClick(self, mouseButton)
	-- Left-click = hint, Right-click = clear
	if mouseButton == "RightButton" then
		if self == NecrosisSelectedMountLeft then
			NecrosisConfig.LeftMount = nil
		elseif self == NecrosisSelectedMountRight then
			NecrosisConfig.RightMount = nil
		elseif self == NecrosisSelectedMountCtrlLeft then
			NecrosisConfig.CtrlLeftMount = nil
		elseif self == NecrosisSelectedMountCtrlRight then
			NecrosisConfig.CtrlRightMount = nil
		end

		NecrosisInitSelectedMountButton(self, nil)
		Necrosis:StoneAttribute("Own")
		return
	end

	-- Left click hint
	if UIErrorsFrame then
		UIErrorsFrame:AddMessage(
		"Drag a mount spell (Spellbook) or mount item (bags) onto this button. Right-click to clear.", 1, 1, 0)
	end
end

function NecrosisSelectedMountButton_OnReceiveDrag(self)
	local infoType, info1 = GetCursorInfo()

	local saveId
	local spellID
	local icon
	local icon2

	-- Most common in TBC: dragging from spellbook -> type "spell", info1 = spellID
	if infoType == "spell" then
		-- In TBC/Classic, info1 is the spellbook SLOT, not a spellID.
		local slot = info1
		local bookType = info2 or BOOKTYPE_SPELL

		local spellType, realSpellID = GetSpellBookItemInfo(slot, bookType)
		if not realSpellID then
			ClearCursor()
			return
		end

		spellID = realSpellID
		icon = GetSpellTexture(slot, bookType) or GetSpellTexture(spellID)
		saveId = spellID

		if not (spellID == 5784 or spellID == 23161) then
			UIErrorsFrame:AddMessage(
				"Drag a mount spell (Spellbook) or mount item (bags) onto this button. Right-click to clear.", 1, 1, 0)
			return
		end

		-- Some mounts are items -> type "item", info1 = itemID
	elseif infoType == "item" then
		local itemID = info1
		local itemLink = info2 -- often present for bag drags

		local isItemMount = select(7, GetItemInfo(itemID)) == "Mount"
			or (C_Item.GetItemType and C_Item.GetItemType(itemID) == "Mount")

		if not isItemMount then
			UIErrorsFrame:AddMessage(
				"Drag a mount spell (Spellbook) or mount item (bags) onto this button. Right-click to clear.", 1, 1, 0)
			return
		end

		-- Icon: prefer classic-safe sources
		icon = (GetItemIcon and GetItemIcon(itemID)) or select(10, GetItemInfo(itemID)) or (C_Item.GetItemIcon and C_Item.GetItemIcon(itemID)) or select(10, C_Item.GetItemInfo(itemID))

		-- Mount items: GetItemSpell is most reliable with itemLink when available
		local _, itemSpellID = GetItemSpell(itemLink or itemID) or C_Item.GetItemSpell(itemLink or itemID)
		spellID = itemSpellID

		-- Save the ITEM id (Attributes.lua detects item vs spell via GetSpellInfo vs GetItemInfo)
		saveId = itemID
	else
		ClearCursor()
		return
	end

	if not saveId or not icon then
		ClearCursor()
		return
	end

	-- Save into the correct slot
	if self == NecrosisSelectedMountLeft then
		NecrosisConfig.LeftMount = saveId
	elseif self == NecrosisSelectedMountRight then
		NecrosisConfig.RightMount = saveId
	elseif self == NecrosisSelectedMountCtrlLeft then
		NecrosisConfig.CtrlLeftMount = saveId
	elseif self == NecrosisSelectedMountCtrlRight then
		NecrosisConfig.CtrlRightMount = saveId
	end

	-- Update the button visuals immediately
	self.mountID = saveId
	self.spellID = spellID
	self:SetNormalTexture(icon)
	self:Enable()

	-- Apply to the actual necrosis mount button attributes
	Necrosis:StoneAttribute("Own")

	ClearCursor()
end

function NecrosisInitSelectedMountButton(button, id)
	if not button then return end

	if not id then
		button.mountID = nil
		button.spellID = nil
		button:SetNormalTexture(132238) -- question mark
		return
	end

	local icon
	local spellID

	-- If id is a spellID
	if GetSpellInfo(id) then
		spellID = id
		icon = GetSpellTexture(id)
	else
		-- Otherwise treat id as itemID
		icon = GetItemIcon(id)
		local _, itemSpellID = GetItemSpell(id)
		spellID = itemSpellID
	end

	button.mountID = id
	button.spellID = spellID
	button:SetNormalTexture(icon or 132238)
	button:Enable()
end
