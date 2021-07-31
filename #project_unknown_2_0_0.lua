--https://trello.com/b/f3u4ZSE4/settings-for-each-weapon
 
-- Per Group Elements API made by GLadiator with help from "lennonc1atwit - Per Weapon Gui API" --
local WEAPONID_PISTOLS          = { 2, 3, 4, 30, 32, 36, 61, 63 }
local WEAPONID_HEAVYPISTOLS     = { 1, 64 }
local WEAPONID_SUBMACHINEGUNS   = { 17, 19, 23, 24, 26, 33, 34 }
local WEAPONID_RIFLES           = { 7, 8, 10, 13, 16, 39, 60 }
local WEAPONID_SHOTGUNS         = { 25, 27, 29, 35 }
local WEAPONID_SCOUT            = { 40 }
local WEAPONID_AUTOSNIPERS      = { 11, 38 }
local WEAPONID_SNIPER           = { 9 }
local WEAPONID_LIGHTMACHINEGUNS = { 14, 28 }
local WEAPONID_ALLWEAPONS       = { WEAPONID_PISTOLS, WEAPONID_HEAVYPISTOLS, WEAPONID_SUBMACHINEGUNS, WEAPONID_RIFLES, WEAPONID_SHOTGUNS, WEAPONID_SCOUT, WEAPONID_AUTOSNIPERS, WEAPONID_SNIPER, WEAPONID_LIGHTMACHINEGUNS }
local WEAPON_GROUPS_NAME        = { 'PISTOL', 'HPISTOL', 'SMG', 'RIFLE', 'SHOTGUN', 'SCOUT', 'ASNIPER', 'SNIPER', 'LMG' }
local WEAPON_CURRENT_GROUP      = ''
local PERGROUP_ELEMENTS         = {}

local function lp_weapon_id(WEAPONID)
    for k, v in pairs(WEAPONID) do
        if entities.GetLocalPlayer():GetWeaponID() == WEAPONID[k] then
            return true
        end
    end
end

local function gui_Checkbox(PARENT, VARNAME, NAME, VALUE, DESCRIPTION)
    local ID = #PERGROUP_ELEMENTS + 1
    PERGROUP_ELEMENTS[ID] = {}

    for k, v in pairs(WEAPON_GROUPS_NAME) do
        local WEAPON = string.lower(WEAPON_GROUPS_NAME[k])
        local temp

        if type(PARENT) == 'userdata' then
            temp = gui.Checkbox(PARENT, WEAPON..'.'..VARNAME, NAME, VALUE)
            PERGROUP_ELEMENTS[ID][WEAPON_GROUPS_NAME[k]] = {temp, PARENT}
        else
            temp = gui.Checkbox(PARENT[WEAPON_GROUPS_NAME[k]][1], WEAPON..'.'..VARNAME, NAME, VALUE)
            PERGROUP_ELEMENTS[ID][WEAPON_GROUPS_NAME[k]] = {temp, PARENT[WEAPON_GROUPS_NAME[k]][2]}
        end

        temp:SetDescription(DESCRIPTION)
    end
    return PERGROUP_ELEMENTS[ID]
end
local function gui_Slider(PARENT, VARNAME, NAME, DESCRIPTION, VALUE, MIN, MAX, STEP)
    local ID = #PERGROUP_ELEMENTS + 1
    PERGROUP_ELEMENTS[ID] = {}

    for k, v in pairs(WEAPON_GROUPS_NAME) do
        local WEAPON = string.lower(WEAPON_GROUPS_NAME[k])

        local temp = gui.Slider(PARENT, WEAPON..'.'..VARNAME, NAME, VALUE, MIN, MAX, STEP)
        PERGROUP_ELEMENTS[ID][WEAPON_GROUPS_NAME[k]] = {temp, PARENT}

        temp:SetDescription(DESCRIPTION)
    end
    return PERGROUP_ELEMENTS[ID]
end
local function gui_Combobox(PARENT, VARNAME, NAME, DESCRIPTION, ...)
    local ID = #PERGROUP_ELEMENTS + 1
    PERGROUP_ELEMENTS[ID] = {}

    for k, v in pairs(WEAPON_GROUPS_NAME) do
        local WEAPON = string.lower(WEAPON_GROUPS_NAME[k])

        local temp = gui.Combobox(PARENT, WEAPON..'.'..VARNAME, NAME, ...)
        PERGROUP_ELEMENTS[ID][WEAPON_GROUPS_NAME[k]] = {temp, PARENT}

        temp:SetDescription(DESCRIPTION)
    end
    return PERGROUP_ELEMENTS[ID]
end
local function gui_Multibox(PARENT, NAME)
    local ID = #PERGROUP_ELEMENTS + 1
    PERGROUP_ELEMENTS[ID] = {}

    for k, v in pairs(WEAPON_GROUPS_NAME) do
        local WEAPON = string.lower(WEAPON_GROUPS_NAME[k])

        local temp = gui.Multibox(PARENT, NAME)
        PERGROUP_ELEMENTS[ID][WEAPON_GROUPS_NAME[k]] = {temp, PARENT}

        temp:SetDescription(DESCRIPTION)
    end
    return PERGROUP_ELEMENTS[ID]
end
-- Per Group Elements API made by GLadiator with help from "lennonc1atwit - Per Weapon Gui API" --


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MINICORD_TAB                          = gui.Tab(gui.Reference('Ragebot'), 'minicord', '#project_unknown_2_0_0')
local MINICORD_SUBTAB_WEAPONSELECTION       = gui.Groupbox(MINICORD_TAB, 'Weapon selection', 16, 16, 296, 200)
local MINICORD_CURRENT_WEAPON               = gui.Text(MINICORD_SUBTAB_WEAPONSELECTION, 'Current weapon group: global')

local MINICORD_SUBTAB_FL_FD                 = gui.Groupbox(MINICORD_TAB, 'Fakelags', 16, 109, 296, 200)
local MINICORD_FAKELAGS_TYPE                = gui.Combobox(MINICORD_SUBTAB_FL_FD, 'fakelags.type', 'Fakelags type', 'Normal', 'Adaptive', 'Custom')
local MINICORD_FAKELAGS_JITTER              = gui.Slider(MINICORD_SUBTAB_FL_FD, 'fakelags.jitter', 'Jitter factor', 0, 0, 4)
local MINICORD_FAKELAGS_CUSTOM_TYPE         = gui.Combobox(MINICORD_SUBTAB_FL_FD, 'fakelags.custom.type', 'Fakelags pattern', 'Normal', 'Adaptive')
local MINICORD_FAKELAGS_CUSTOM_FACTOR_MIN   = gui.Slider(MINICORD_SUBTAB_FL_FD, 'fakelags.custom.factor.min', 'Factor minimum', 16, 3, 61)
local MINICORD_FAKELAGS_CUSTOM_FACTOR_MAX   = gui.Slider(MINICORD_SUBTAB_FL_FD, 'fakelags.custom.factor.max', 'Factor maximum', 16, 3, 61)
local MINICORD_FAKEDUCK_TYPE                = gui.Combobox(MINICORD_SUBTAB_FL_FD, 'fakeduck.type', 'Fakeduck type', 'Accurate, but slow', 'Inaccuracy, but fast')
local MINICORD_FAKEDUCK_SPEED               = gui.Combobox(MINICORD_SUBTAB_FL_FD, 'fakeduck.speed', 'Fakeduck speed', 'Slow', 'Slower', 'Standard', 'Accelerated', 'Custom')
local MINICORD_FAKEDUCK_SPEED_ADJUSTER      = gui.Slider(MINICORD_SUBTAB_FL_FD, 'fakeduck.speed.adjuster', 'Fakeduck speed adjuster', 16, 3, 61)

local MINICORD_SUBTAB_DOUBLEFIRE            = gui.Groupbox(MINICORD_TAB, 'Double fire', 328, 16, 296, 200)
local MINICORD_DOUBLEFIRE_MODE              = gui_Combobox(MINICORD_SUBTAB_DOUBLEFIRE, 'doublefire.mode', 'Double fire mode', 'Select the desired double fire mode.', 'Off', 'Chargeable without recharge', 'Rechargeable')
local MINICORD_DOUBLEFIRE_SPEED             = gui_Combobox(MINICORD_SUBTAB_DOUBLEFIRE, 'doublefire.speed', 'Double fire speed', 'Select double fire speed, or leave automatic.', 'Automatic', 'Slow', 'Slower', 'Standard', 'Accelerated', 'Custom')
local MINICORD_DOUBLEFIRE_SPEED_ADJUSTER    = gui_Slider(MINICORD_SUBTAB_DOUBLEFIRE, 'doublefire.speed.adjuster', 'Double fire speed adjuster', 'How much to shift tickbase for double fire.', 16, 3, 24, 1)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MINICORD_FAKELAGS_TYPE:SetDescription('Factor of fakelags is automatic, except for custom mode.')
MINICORD_FAKELAGS_JITTER:SetDescription('You can add jitter to the fakelags as desired.')
MINICORD_FAKELAGS_CUSTOM_TYPE:SetDescription('Choose your preferred fakelag type.')
MINICORD_FAKELAGS_CUSTOM_FACTOR_MIN:SetDescription('How many minimum fakelags ticks will be choked.')
MINICORD_FAKELAGS_CUSTOM_FACTOR_MAX:SetDescription('How many maximum fakelags ticks will be choked.')
MINICORD_FAKEDUCK_TYPE:SetDescription('Choose your preferred fakeduck type, or leave automatic.')
MINICORD_FAKEDUCK_SPEED:SetDescription('This affects the rate of fire and accuracy.')
MINICORD_FAKEDUCK_SPEED_ADJUSTER:SetDescription('Set a custom value for the fakeduck speed.')
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Per Group Elements API made by GLadiator with help from "lennonc1atwit - Per Weapon Gui API" --
callbacks.Register("Draw", 'guiEndSetup', function(guiEndSetup)
    --Set to 0 if you don't want to display the current weapon group. 
    local PARENT = MINICORD_CURRENT_WEAPON
    local TEXT = 'Current weapon group: '

    --Iterate through all weapon groups.
    for k, v in pairs(WEAPON_GROUPS_NAME) do
        --If the ID of the current weapon is not equal to one of the ID table, then set the 'global' group in the menu.
        if not lp_weapon_id(WEAPONID_ALLWEAPONS) then
            if PARENT ~= 0 then PARENT:SetText(TEXT .. 'global'); end
        end
        --Iterate through all weapons id
        for k, v in pairs(WEAPONID_ALLWEAPONS) do
            --If the current weapon ID matches the key from all weapon IDs, then save the current weapon group from the key of all group names.
            if lp_weapon_id(WEAPONID_ALLWEAPONS[k]) then
                WEAPON_CURRENT_GROUP = WEAPON_GROUPS_NAME[k]
                if PARENT ~= 0 and TEXT ~= 0 then PARENT:SetText(TEXT .. string.lower(WEAPON_GROUPS_NAME[k])); end
            end
        end
    end
    
    if gui.Reference("Menu"):IsActive() then
        --Iterate through groups of installed elements.
        for ID, group in pairs(PERGROUP_ELEMENTS) do
            --Iterate through the element group table.
            for key, element in pairs(group) do
                --If the key(name of the weapon element) matches the current group of weapons, then set the display of the element, otherwise invisible.
                if key == WEAPON_CURRENT_GROUP then
                    element[1]:SetInvisible(false)
                else 
                    element[1]:SetInvisible(true)
                end
            end
        end
    end
end)
callbacks.Register("Unload", function(guiEndScene)
    for ID, group in pairs(PERGROUP_ELEMENTS) do 
        for key, element in pairs(group) do
           element[1]:Remove()
        end
    end
end)
-- Per Group Elements API made by GLadiator with help from "lennonc1atwit - Per Weapon Gui API" --



local sv_maxusrcmdprocessticks = gui.Reference('Misc', 'General', 'Server', 'sv_maxusrcmdprocessticks')

local function dtsetup(N)
	gui.SetValue('rbot.accuracy.weapon.pistol.doublefire', N)
	gui.SetValue('rbot.accuracy.weapon.hpistol.doublefire', N)
	gui.SetValue('rbot.accuracy.weapon.smg.doublefire', N)
	gui.SetValue('rbot.accuracy.weapon.rifle.doublefire', N)
	gui.SetValue('rbot.accuracy.weapon.shotgun.doublefire', N)
	gui.SetValue('rbot.accuracy.weapon.scout.doublefire', N)
	gui.SetValue('rbot.accuracy.weapon.asniper.doublefire', N)
	gui.SetValue('rbot.accuracy.weapon.sniper.doublefire', N)
	gui.SetValue('rbot.accuracy.weapon.lmg.doublefire', N)
end

local function menuсontroler()
    if MINICORD_FAKELAGS_TYPE:GetValue() == 2 then
        MINICORD_FAKELAGS_JITTER:SetInvisible(true)
        MINICORD_FAKELAGS_CUSTOM_TYPE:SetInvisible(false)
        MINICORD_FAKELAGS_CUSTOM_FACTOR_MIN:SetInvisible(false)
        MINICORD_FAKELAGS_CUSTOM_FACTOR_MAX:SetInvisible(false)
    else
        MINICORD_FAKELAGS_JITTER:SetInvisible(false)
        MINICORD_FAKELAGS_CUSTOM_TYPE:SetInvisible(true)
        MINICORD_FAKELAGS_CUSTOM_FACTOR_MIN:SetInvisible(true)
        MINICORD_FAKELAGS_CUSTOM_FACTOR_MAX:SetInvisible(true)
    end

    if MINICORD_FAKEDUCK_SPEED:GetValue() == 4 then
        MINICORD_FAKEDUCK_SPEED_ADJUSTER:SetInvisible(false)
    else
        MINICORD_FAKEDUCK_SPEED_ADJUSTER:SetInvisible(true)
    end

    if MINICORD_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue() ~= 0 then
        MINICORD_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
        if MINICORD_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:GetValue() == 5 then
            MINICORD_DOUBLEFIRE_SPEED_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
        else
            MINICORD_DOUBLEFIRE_SPEED_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        end
    else
        MINICORD_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        MINICORD_DOUBLEFIRE_SPEED_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
    end
end

local function fakelags()
    local getmaxprocessticks = client.GetConVar('sv_maxusrcmdprocessticks')
    local FL_TYPE = { 0, 1 }

	gui.SetValue('misc.fakelag.enable', 1)
    if MINICORD_FAKELAGS_TYPE:GetValue() <= 1 then
		gui.SetValue('misc.fakelag.type', FL_TYPE[MINICORD_FAKELAGS_TYPE:GetValue() + 1])
		gui.SetValue('misc.fakelag.factor', math.random(getmaxprocessticks - MINICORD_FAKELAGS_JITTER:GetValue(), getmaxprocessticks))
	elseif MINICORD_FAKELAGS_TYPE:GetValue() == 2 then
		gui.SetValue('misc.fakelag.type', FL_TYPE[MINICORD_FAKELAGS_CUSTOM_TYPE:GetValue() + 1])
		gui.SetValue('misc.fakelag.factor', math.random(MINICORD_FAKELAGS_CUSTOM_FACTOR_MIN:GetValue(), MINICORD_FAKELAGS_CUSTOM_FACTOR_MAX:GetValue()))
    end
    sv_maxusrcmdprocessticks:SetValue(client.GetConVar('sv_maxusrcmdprocessticks'))
end

local function fakeduck()
    if gui.GetValue('rbot.antiaim.extra.fakecrouchkey') == 0 then
		return
	end

    local getmaxprocessticks = client.GetConVar('sv_maxusrcmdprocessticks')
    local FD_TYPE = { 0, 1 }
    local FD_SPEED = { getmaxprocessticks - 2, getmaxprocessticks - 1, getmaxprocessticks, getmaxprocessticks + 1, MINICORD_FAKEDUCK_SPEED_ADJUSTER:GetValue() }

    gui.SetValue('rbot.antiaim.extra.fakecrouchstyle', FD_TYPE[MINICORD_FAKEDUCK_TYPE:GetValue()])
    if input.IsButtonDown(gui.Reference('Ragebot', 'Anti-Aim', 'Extra', 'Fake Duck'):GetValue()) then 
        sv_maxusrcmdprocessticks:SetValue(FD_SPEED[MINICORD_FAKEDUCK_SPEED:GetValue() + 1])
    end
end

local function doublefire()
    dtsetup(MINICORD_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue())

    if MINICORD_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue() == 0 then
        return
    end

    local getmaxprocessticks = client.GetConVar('sv_maxusrcmdprocessticks')
    local ping = entities.GetPlayerResources():GetPropInt("m_iPing", entities.GetLocalPlayer():GetIndex())
	local DT_SPEED = {getmaxprocessticks - 2, getmaxprocessticks - 1, getmaxprocessticks, getmaxprocessticks + 1, MINICORD_DOUBLEFIRE_SPEED_ADJUSTER[WEAPON_CURRENT_GROUP][1]:GetValue()}

    if MINICORD_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:GetValue() == 0 then
        if gui.GetValue('misc.fakelatency.enable') then
            sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks)
        else
            if ping <= 25 then
                sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks)
            elseif ping <= 50 then
                sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks - 1)
            elseif ping <= 80 then
                sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks - 2)
            elseif ping > 80 then
                sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks - 3)
            end	
        end
    else
        sv_maxusrcmdprocessticks:SetValue(DT_SPEED[MINICORD_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:GetValue()])
    end
end

local function main()
    if not entities.GetLocalPlayer():IsAlive() then
        return
    end

    menuсontroler()
    fakelags()
    fakeduck()
    doublefire()

    return true
end
callbacks.Register('Draw', 'MinicordMain', main)
