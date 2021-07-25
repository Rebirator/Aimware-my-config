--https://trello.com/b/f3u4ZSE4/settings-for-each-weapon

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
local function perGroup_Checkbox(PARENT, VARNAME, NAME, VALUE, DESCRIPTION)
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
local function perGroup_Combobox(PARENT, VARNAME, NAME, DESCRIPTION, ...)
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
local function perGroup_Multibox(PARENT, NAME)
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

local sv_maxusrcmdprocessticks = gui.Reference('Misc', 'General', 'Server', 'sv_maxusrcmdprocessticks')

local MINICORD_TAB                          = gui.Tab(gui.Reference('Ragebot'), 'minicord', '#project_unknown_2_0_0')
local MINICORD_SUBTAB_WEAPONSELECTION       = gui.Groupbox(MINICORD_TAB, 'Weapon selection', 16, 16, 296, 200)
local MINICORD_SUBTAB_DOUBLEFIRE            = gui.Groupbox(MINICORD_TAB, 'Double fire', 328, 16, 296, 200)

local MINICORD_CURRENT_WEAPON               = gui.Text(MINICORD_SUBTAB_WEAPONSELECTION, 'Current weapon group: global')

local MINICORD_DOUBLEFIRE_MODE = perGroup_Combobox(MINICORD_SUBTAB_DOUBLEFIRE, 'doublefire.mode', 'Double fire mode', '', 'Off', '1', '2')

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
    callbacks.Unregister(guiEndSetup)
    for ID, group in pairs(PERGROUP_ELEMENTS) do 
        for key, element in pairs(group) do
           element[1]:Remove()
        end
    end
end)

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

local function doublefire()
    dtsetup(MINICORD_DOUBLEFIRE_MODE[WEAPON_CURRENT_GROUP][1]:GetValue())

    return
end

local function main()
    if not entities.GetLocalPlayer():IsAlive() then
        return
    end

    doublefire()
end
callbacks.Register('Draw', 'MinicordMain', main)
