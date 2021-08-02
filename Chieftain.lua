------------------------------------------Credits-------------------------------------------
--				                Chieftain made by GLadiator
--	          Lag peek DT based on Vis/Invis Damage by Chicken4676 and John.k				
------------------------------------------Credits-------------------------------------------
 
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

local function gui_Checkbox(PARENT, VARNAME, NAME, DESCRIPTION, VALUE)
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
local function gui_Multibox(PARENT, NAME, DESCRIPTION)
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
local CHIEFTAIN_TAB                                   = gui.Tab(gui.Reference('Ragebot'), 'Chieftain', 'Chieftain ➤')

local CHIEFTAIN_SUBTAB_WEAPONSELECTION                = gui.Groupbox(CHIEFTAIN_TAB, 'Selected weapon group', 16, 16, 296, 200)
local CHIEFTAIN_CURRENT_WEAPON                        = gui.Text(CHIEFTAIN_SUBTAB_WEAPONSELECTION, 'Current weapon group: global')

local CHIEFTAIN_SUBTAB_MISC                           = gui.Groupbox(CHIEFTAIN_TAB, 'Misc', 16, 109, 296, 200)
local CHIEFTAIN_MISC_FAKELAGS_TYPE                    = gui.Combobox(CHIEFTAIN_SUBTAB_MISC, 'misc.fakelags.type', 'Fakelags type', 'Normal', 'Adaptive', 'Custom')
local CHIEFTAIN_MISC_FAKELAGS_JITTER                  = gui.Slider(CHIEFTAIN_SUBTAB_MISC, 'misc.fakelags.jitter', 'Jitter factor', 0, 0, 3)
local CHIEFTAIN_MISC_FAKELAGS_CUSTOM_TYPE             = gui.Combobox(CHIEFTAIN_SUBTAB_MISC, 'misc.fakelags.custom.type', 'Fakelags pattern', 'Normal', 'Adaptive', 'Switch')
local CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MIN       = gui.Slider(CHIEFTAIN_SUBTAB_MISC, 'misc.fakelags.custom.factor.min', 'Factor minimum', 16, 3, 61)
local CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MAX       = gui.Slider(CHIEFTAIN_SUBTAB_MISC, 'misc.fakelags.custom.factor.max', 'Factor maximum', 16, 3, 61)
local CHIEFTAIN_MISC_FAKEDUCK_TYPE                    = gui.Combobox(CHIEFTAIN_SUBTAB_MISC, 'misc.fakeduck.type', 'Fakeduck type', 'Accurate, but slow', 'Inaccuracy, but fast')
local CHIEFTAIN_MISC_FAKEDUCK_SPEED                   = gui.Combobox(CHIEFTAIN_SUBTAB_MISC, 'misc.fakeduck.speed', 'Fakeduck speed', 'Automatic', 'Slow', 'Slower', 'Standard', 'Accelerated', 'Custom')
local CHIEFTAIN_MISC_FAKEDUCK_SPEED_ADJUSTER          = gui.Slider(CHIEFTAIN_SUBTAB_MISC, 'misc.fakeduck.speed.adjuster', 'Fakeduck speed adjuster', 16, 3, 61)
local CHIEFTAIN_MISC_FAKELATENCY                      = gui.Combobox(CHIEFTAIN_SUBTAB_MISC, 'misc.fakelatency', 'Fakelatency', 'Off', 'Low', 'Medium', 'High', 'Maximum', 'Custom')
local CHIEFTAIN_MISC_FAKELATENCY_ADJUSTER             = gui.Slider(CHIEFTAIN_SUBTAB_MISC, 'misc.fakelatency.adjuster', 'Fakelatency adjuster', 200, 0, 1000, 5)

local CHIEFTAIN_SUBTAB_DOUBLEFIRE                     = gui.Groupbox(CHIEFTAIN_TAB, 'Double fire', 328, 16, 296, 200)
local CHIEFTAIN_DOUBLEFIRE_MODE                       = gui_Combobox(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'doublefire.mode', 'Double fire mode', 'Select the desired double fire mode. Don\'t forget to bind.', 'Off', 'Chargeable without recharge', 'Rechargeable')
local CHIEFTAIN_DOUBLEFIRE_SPEED                      = gui_Combobox(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'doublefire.speed', 'Double fire speed', 'Select double fire speed, or leave automatic.', 'Automatic', 'Slow', 'Slower', 'Standard', 'Accelerated', 'Custom')
local CHIEFTAIN_DOUBLEFIRE_SPEED_ADJUSTER             = gui_Slider(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'doublefire.speed.adjuster', 'Double fire speed adjuster', 'How much to shift tickbase for double fire.', 16, 3, 24, 1)
local CHIEFTAIN_DOUBLEFIRE_PERF                       = gui_Multibox(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'Double fire performance options', 'Using performance options increase double fire efficiency.')
local CHIEFTAIN_DOUBLEFIRE_PERF_LAGPEEK               = gui_Checkbox(CHIEFTAIN_DOUBLEFIRE_PERF, 'doublefire.perf.lagpeek', 'Lag on peek', 'Lag before the peek forces the enemy to delay.', false)
local CHIEFTAIN_DOUBLEFIRE_PERF_DISLBY                = gui_Checkbox(CHIEFTAIN_DOUBLEFIRE_PERF, 'doublefire.perf.dislby', 'Disable LBY', 'Disabling LBY greatly improves double fire efficiency.', false)
local CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE          = gui_Combobox(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'doublefire.perf.lagpeek.fakelatency', 'Fakelatency', 'Using fakelatency will make lag on peek more efficient.', 'Off', 'Low', 'Medium', 'High', 'Maximum', 'Custom')
local CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE_ADJUSTER = gui_Slider(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'doublefire.perf.lagpeek.fakelatency.adjuster', 'Fakelatency adjuster', 'By default, servers only support up to 200ms.', 200, 0, 1000, 5)
local CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN               = gui_Combobox(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'doublefire.perf.lagpeek.hitboxscan', 'Prediction velocity hitboxes scanning', 'The number and scale of hitboxes to scan. Affects FPS.', 'Medium', 'High', 'Maximum')
local CHIEFTAIN_DOUBLEFIRE_LAGPEEK_VALUE              = gui_Slider(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'dobulefire.perf.lagpeek.value', 'Prediction velocity amount', 'A high value activates lag earlier.', 0.140, 0.100, 0.180, 0.005)
local CHIEFTAIN_DOUBLEFIRE_LAGPEEK_DEBUG              = gui_Checkbox(CHIEFTAIN_SUBTAB_DOUBLEFIRE, 'doublefire.perf.lagpeek.debugmode', 'Debug mode', '', false)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CHIEFTAIN_MISC_FAKELAGS_TYPE:SetDescription('Factor of fakelags is automatic, except for custom mode.')
CHIEFTAIN_MISC_FAKELAGS_JITTER:SetDescription('You can add jitter to the fakelags as desired.')
CHIEFTAIN_MISC_FAKELAGS_CUSTOM_TYPE:SetDescription('Choose your preferred fakelag type.')
CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MIN:SetDescription('How many minimum fakelags ticks will be choked.')
CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MAX:SetDescription('How many maximum fakelags ticks will be choked.')
CHIEFTAIN_MISC_FAKELATENCY:SetDescription('Using fakelatency makes the backtrack of enemies longer.')
CHIEFTAIN_MISC_FAKELATENCY_ADJUSTER:SetDescription('By default, servers only support up to 200ms.')
CHIEFTAIN_MISC_FAKEDUCK_TYPE:SetDescription('Choose your preferred fakeduck type.')
CHIEFTAIN_MISC_FAKEDUCK_SPEED:SetDescription('Affects height, speed, and shooting accuracy.')
CHIEFTAIN_MISC_FAKEDUCK_SPEED_ADJUSTER:SetDescription('Set a custom value for the fakeduck speed.')
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Per Group Elements API made by GLadiator with help from "lennonc1atwit - Per Weapon Gui API" --
callbacks.Register("Draw", 'guiEndSetup', function(guiEndSetup)
    --Set to 0 if you don't want to display the current weapon group. 
    local PARENT = CHIEFTAIN_CURRENT_WEAPON
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

local function to_int(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end
local function dt_setup(N)
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
    if CHIEFTAIN_MISC_FAKELAGS_TYPE:GetValue() == 2 then
        CHIEFTAIN_MISC_FAKELAGS_JITTER:SetInvisible(true)
        CHIEFTAIN_MISC_FAKELAGS_CUSTOM_TYPE:SetInvisible(false)
        CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MIN:SetInvisible(false)
        CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MAX:SetInvisible(false)
    else
        CHIEFTAIN_MISC_FAKELAGS_JITTER:SetInvisible(false)
        CHIEFTAIN_MISC_FAKELAGS_CUSTOM_TYPE:SetInvisible(true)
        CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MIN:SetInvisible(true)
        CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MAX:SetInvisible(true)
    end

    if CHIEFTAIN_MISC_FAKEDUCK_SPEED:GetValue() == 5 then
        CHIEFTAIN_MISC_FAKEDUCK_SPEED_ADJUSTER:SetInvisible(false)
    else
        CHIEFTAIN_MISC_FAKEDUCK_SPEED_ADJUSTER:SetInvisible(true)
    end

    if CHIEFTAIN_MISC_FAKELATENCY:GetValue() == 5 then
        CHIEFTAIN_MISC_FAKELATENCY_ADJUSTER:SetInvisible(false)
    else
        CHIEFTAIN_MISC_FAKELATENCY_ADJUSTER:SetInvisible(true)
    end

    if CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue() ~= 0 then
        CHIEFTAIN_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
        CHIEFTAIN_DOUBLEFIRE_PERF[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)

        if CHIEFTAIN_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:GetValue() == 5 then
            CHIEFTAIN_DOUBLEFIRE_SPEED_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
        else
            CHIEFTAIN_DOUBLEFIRE_SPEED_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        end

        if CHIEFTAIN_DOUBLEFIRE_PERF_LAGPEEK[WEAPON_CURRENT_GROUP][1]:GetValue() then
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
            if CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE[WEAPON_CURRENT_GROUP][1]:GetValue() == 5 then
                CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
            else
                CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
            end
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_VALUE[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_DEBUG[WEAPON_CURRENT_GROUP][1]:SetInvisible(false)
        else
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_VALUE[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
            CHIEFTAIN_DOUBLEFIRE_LAGPEEK_DEBUG[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        end

        if not CHIEFTAIN_DOUBLEFIRE_PERF_DISLBY[WEAPON_CURRENT_GROUP][1]:GetValue() and gui.GetValue('rbot.antiaim.advanced.antialign') == 1 then
            CHIEFTAIN_DOUBLEFIRE_PERF_DISLBY[WEAPON_CURRENT_GROUP][1]:SetDisabled(true)
            CHIEFTAIN_DOUBLEFIRE_PERF_DISLBY[WEAPON_CURRENT_GROUP][1]:SetValue(false)
        else
            CHIEFTAIN_DOUBLEFIRE_PERF_DISLBY[WEAPON_CURRENT_GROUP][1]:SetDisabled(false)
        end
    else
        CHIEFTAIN_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        CHIEFTAIN_DOUBLEFIRE_SPEED_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        CHIEFTAIN_DOUBLEFIRE_PERF[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE_ADJUSTER[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        CHIEFTAIN_DOUBLEFIRE_LAGPEEK_VALUE[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
        CHIEFTAIN_DOUBLEFIRE_LAGPEEK_DEBUG[WEAPON_CURRENT_GROUP][1]:SetInvisible(true)
    end
end

local function fakelags()
    local getmaxprocessticks = client.GetConVar('sv_maxusrcmdprocessticks')
    local FL_TYPE = { 0, 1, 3 }

	gui.SetValue('misc.fakelag.enable', 1)
    if CHIEFTAIN_MISC_FAKELAGS_TYPE:GetValue() <= 1 then
		gui.SetValue('misc.fakelag.type', FL_TYPE[CHIEFTAIN_MISC_FAKELAGS_TYPE:GetValue() + 1])
		gui.SetValue('misc.fakelag.factor', math.random(getmaxprocessticks - CHIEFTAIN_MISC_FAKELAGS_JITTER:GetValue(), getmaxprocessticks))
	elseif CHIEFTAIN_MISC_FAKELAGS_TYPE:GetValue() == 2 then
		gui.SetValue('misc.fakelag.type', FL_TYPE[CHIEFTAIN_MISC_FAKELAGS_CUSTOM_TYPE:GetValue() + 1])
		gui.SetValue('misc.fakelag.factor', math.random(CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MIN:GetValue(), CHIEFTAIN_MISC_FAKELAGS_CUSTOM_FACTOR_MAX:GetValue()))
    end
    sv_maxusrcmdprocessticks:SetValue(client.GetConVar('sv_maxusrcmdprocessticks'))
end

local function fakeduck()
    if gui.GetValue('rbot.antiaim.extra.fakecrouchkey') == 0 then
		return
	end

    local getmaxprocessticks = client.GetConVar('sv_maxusrcmdprocessticks')
    local FD_TYPE = { 0, 1 }
    local FD_SPEED = { getmaxprocessticks - 2, getmaxprocessticks - 1, getmaxprocessticks, getmaxprocessticks + 1, CHIEFTAIN_MISC_FAKEDUCK_SPEED_ADJUSTER:GetValue() }

    gui.SetValue('rbot.antiaim.extra.fakecrouchstyle', FD_TYPE[CHIEFTAIN_MISC_FAKEDUCK_TYPE:GetValue() + 1])
    if input.IsButtonDown(gui.Reference('Ragebot', 'Anti-Aim', 'Extra', 'Fake Duck'):GetValue()) then 
        if CHIEFTAIN_MISC_FAKEDUCK_SPEED:GetValue() == 0 then
            if CHIEFTAIN_MISC_FAKEDUCK_TYPE:GetValue() == 0 then
                if getmaxprocessticks == '6' or getmaxprocessticks == '8' then
                    sv_maxusrcmdprocessticks:SetValue(7)
                else
                    sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks)
                end
            elseif CHIEFTAIN_MISC_FAKEDUCK_TYPE:GetValue() ~= 0 then
                if getmaxprocessticks == '6' or getmaxprocessticks == '8' then
                    sv_maxusrcmdprocessticks:SetValue(7)
                else
                    sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks - 1)
                end
            end
        else
            sv_maxusrcmdprocessticks:SetValue(FD_SPEED[CHIEFTAIN_MISC_FAKEDUCK_SPEED:GetValue()])
        end
    end
end

local function fakelatency()
    FL_AMOUNT = { 80, 120, 160, 200, CHIEFTAIN_MISC_FAKELATENCY_ADJUSTER:GetValue() }
    FL_DT_AMOUNT = { 80, 120, 160, 200, CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE_ADJUSTER[WEAPON_CURRENT_GROUP][1]:GetValue() }

    if CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE[WEAPON_CURRENT_GROUP][1]:GetValue() ~= 0 then
        if CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue() ~= 0 then
            gui.SetValue('misc.fakelatency.enable', 1)
            gui.SetValue('misc.fakelatency.key', 'None')
            gui.SetValue('misc.fakelatency.amount', FL_DT_AMOUNT[CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE[WEAPON_CURRENT_GROUP][1]:GetValue()])
        elseif CHIEFTAIN_MISC_FAKELATENCY:GetValue() == 0 then
            gui.SetValue('misc.fakelatency.enable', 0)
        end
    end
    
    if CHIEFTAIN_MISC_FAKELATENCY:GetValue() ~= 0 then
        if CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue() == 0 then
            gui.SetValue('misc.fakelatency.enable', 1)
            gui.SetValue('misc.fakelatency.key', 'None')
            gui.SetValue('misc.fakelatency.amount', FL_AMOUNT[CHIEFTAIN_MISC_FAKELATENCY:GetValue()])
        elseif CHIEFTAIN_DOUBLEFIRE_LAGPEEK_PINGSPIKE[WEAPON_CURRENT_GROUP][1]:GetValue() == 0 then
            gui.SetValue('misc.fakelatency.enable', 0)
        end
    end
end

local function doublefire()
    dt_setup(CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue())

    local getmaxprocessticks = client.GetConVar('sv_maxusrcmdprocessticks')
    local lp_ping = entities.GetPlayerResources():GetPropInt("m_iPing", entities.GetLocalPlayer():GetIndex())
	local DT_SPEED = {getmaxprocessticks - 2, getmaxprocessticks - 1, getmaxprocessticks, getmaxprocessticks + 1, CHIEFTAIN_DOUBLEFIRE_SPEED_ADJUSTER[WEAPON_CURRENT_GROUP][1]:GetValue()}

    if CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue() ~= 0 then
        if CHIEFTAIN_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:GetValue() == 0 then
            if gui.GetValue('misc.fakelatency.enable') then
                sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks)
            else
                if lp_ping <= 40 then
                    sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks)
                elseif lp_ping <= 80 then
                    sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks - 1)
                elseif lp_ping > 80 then
                    sv_maxusrcmdprocessticks:SetValue(getmaxprocessticks - 2)
                end	
            end
        else
            sv_maxusrcmdprocessticks:SetValue(DT_SPEED[CHIEFTAIN_DOUBLEFIRE_SPEED[WEAPON_CURRENT_GROUP][1]:GetValue()])
        end

        if CHIEFTAIN_DOUBLEFIRE_PERF_DISLBY[WEAPON_CURRENT_GROUP][1]:GetValue() then
            if CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue() ~= 0 then
                gui.SetValue('rbot.antiaim.advanced.antialign', 1)
            else
                gui.SetValue('rbot.antiaim.advanced.antialign', 0)
            end
        end
    end
end

local function entities_check()
    local LocalPlayer = entities.GetLocalPlayer();
    local Player
    if LocalPlayer ~= nil then
        Player = LocalPlayer:GetAbsOrigin()
        if (math.floor((entities.GetLocalPlayer():GetPropInt("m_fFlags") % 4) / 2) == 1) then
            z = 46
        else
            z = 64
        end
        Player.z = Player.z + LocalPlayer:GetPropVector("localdata", "m_vecViewOffset[0]").z
        return Player, LocalPlayer
    end
end
function predict_velocity(entity, prediction_amount)
	local VelocityX = entity:GetPropFloat( "localdata", "m_vecVelocity[0]" );
	local VelocityY = entity:GetPropFloat( "localdata", "m_vecVelocity[1]" );
	local VelocityZ = entity:GetPropFloat( "localdata", "m_vecVelocity[2]" );
	
	absVelocity = {VelocityX, VelocityY, VelocityZ}
	
	pos_ = {entity:GetAbsOrigin()}
	
	modifed_velocity = {vector.Multiply(absVelocity, prediction_amount)}
	
	
	return {vector.Subtract({vector.Add(pos_, modifed_velocity)}, {0,0,0})}
end
local function is_vis(LocalPlayerPos)
    local is_vis = false
    local players = entities.FindByClass("CCSPlayer")

    local hitboxes_scale
	if CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() == 0 then
		hitboxes_scale = 3
	elseif CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 1 then
		hitboxes_scale = 4
	end

    for i, player in pairs(players) do
        if player:GetTeamNumber() ~= entities.GetLocalPlayer():GetTeamNumber() and player:IsPlayer() and entities_check() ~= nil and player:IsAlive() then			
            for hitbox = 0, 18 do
				if 	hitbox == 0  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 0 or
--					hitbox == 1  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= N or
					hitbox == 2  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 0 or
					hitbox == 3  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 2 or
					hitbox == 4  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 2 or
					hitbox == 5  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 0 or
					hitbox == 6  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 2 or
					hitbox == 7  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 2 or
					hitbox == 8  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 2 or
					hitbox == 9  and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 0 or
					hitbox == 10 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 0 or
					hitbox == 11 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 1 or
					hitbox == 12 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 1 or
--					hitbox == 13 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= N or
--					hitbox == 14 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= N or
					hitbox == 15 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 1 or
					hitbox == 16 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 1 or
					hitbox == 17 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 1 or
					hitbox == 18 and CHIEFTAIN_DOUBLEFIRE_LAGPEEK_SCAN[WEAPON_CURRENT_GROUP][1]:GetValue() >= 1 then
					for x = 0, hitboxes_scale do
						local HitboxPos = player:GetHitboxPosition(hitbox)

						if x == 0 then
							HitboxPos.x = HitboxPos.x
							HitboxPos.y = HitboxPos.y
						elseif x == 1 then
							HitboxPos.x = HitboxPos.x
							HitboxPos.y = HitboxPos.y + 4
						elseif x == 2 then
							HitboxPos.x = HitboxPos.x
							HitboxPos.y = HitboxPos.y - 4
						elseif x == 3 then
							HitboxPos.x = HitboxPos.x + 4
							HitboxPos.y = HitboxPos.y
						elseif x == 4 then
							HitboxPos.x = HitboxPos.x - 4
							HitboxPos.y = HitboxPos.y
						end

						local c = (engine.TraceLine(LocalPlayerPos, HitboxPos, 0x1)).contents
							
						local x,y = client.WorldToScreen(LocalPlayerPos)
						local x2,y2 = client.WorldToScreen(HitboxPos)
							
						--Debug
						--[[ if c == 0 then draw.Color(0,255,0) else draw.Color(225,0,0) end
						if x and x2 then
							draw.Line(x,y,x2,y2)
						end ]]
						--Debug
							
						if c == 0 then
							is_vis = true
								break
						end
					end
				end
            end
        end
	end

    return is_vis
end
local function lag_on_peek()
	local Player, LocalPlayer = entities_check()

    if CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue() == 0 or CHIEFTAIN_DOUBLEFIRE_PERF_LAGPEEK[WEAPON_CURRENT_GROUP][1]:GetValue() == 0 then
        return
    end
    
	
    local velocity = math.sqrt(entities.GetLocalPlayer():GetPropFloat( "localdata", "m_vecVelocity[0]" ) ^ 2 + entities.GetLocalPlayer():GetPropFloat( "localdata", "m_vecVelocity[1]" ) ^ 2)
    
    if LocalPlayer then
        local perfect_prediction_velocity = CHIEFTAIN_DOUBLEFIRE_LAGPEEK_VALUE[WEAPON_CURRENT_GROUP][1]:GetValue() + 0.270 + (velocity / 10000)

        local prediction = predict_velocity(LocalPlayer, perfect_prediction_velocity)
        local my_pos = LocalPlayer:GetAbsOrigin()
        
        local x,y,z = vector.Add(
            {my_pos.x, my_pos.y, my_pos.z},
            {prediction[1], prediction[2], prediction[3]}
        )
    
        local LocalPlayer_predicted_pos = Vector3(x,y,z)
        LocalPlayer_predicted_pos.z = LocalPlayer_predicted_pos.z + LocalPlayer:GetPropVector("localdata", "m_vecViewOffset[0]").z
    
        if is_vis(LocalPlayer_predicted_pos) then
            gui.SetValue("misc.speedburst.enable", 1)
            dt_setup(0)
        else
            dt_setup(CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue())
            gui.SetValue("misc.speedburst.enable", 0)
        end
    end
    if LocalPlayer then
        local perfect_prediction_velocity = CHIEFTAIN_DOUBLEFIRE_LAGPEEK_VALUE[WEAPON_CURRENT_GROUP][1]:GetValue() + (velocity / 10000)

        if CHIEFTAIN_DOUBLEFIRE_LAGPEEK_DEBUG[WEAPON_CURRENT_GROUP][1]:GetValue() then
            local x, y = draw.GetScreenSize()
            draw.TextShadow(to_int(x / 2 + 20), to_int(y / 2 + 20), string.format("%.3f", perfect_prediction_velocity) .. ' prediction', 255, 255, 255, 255)
        end

        local prediction = predict_velocity(LocalPlayer, perfect_prediction_velocity)
        local my_pos = LocalPlayer:GetAbsOrigin()
        
        local x,y,z = vector.Add(
            {my_pos.x, my_pos.y, my_pos.z},
            {prediction[1], prediction[2], prediction[3]}
        )
    
        local LocalPlayer_predicted_pos = Vector3(x,y,z)
        LocalPlayer_predicted_pos.z = LocalPlayer_predicted_pos.z + LocalPlayer:GetPropVector("localdata", "m_vecViewOffset[0]").z
    
        if is_vis(LocalPlayer_predicted_pos) then
            dt_setup(CHIEFTAIN_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue())
            gui.SetValue("misc.speedburst.enable", 0)
        end
    end
end

local function main()
    menuсontroler()

    if not entities.GetLocalPlayer():IsAlive() then
        return
    end

    fakelags()
    fakeduck()
    fakelatency()
    doublefire()
    lag_on_peek()

    return true
end
callbacks.Register('Draw', 'ChieftainMain', main)
