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
local WEAPON_GROUPS_NAME        = { 'PISTOL', 'HPISTOL', 'SMG', 'RIFLE', 'SHOTGUN', 'SCOUT', 'ASNIPER', 'SNIPER', 'LMG' }
local WEAPON_CURRENT_GROUP      = ''
local WEAPON_ELEMENT            = {}

local function lp_weapon_id(WEAPONID)
    for k, v in pairs(WEAPONID) do
        if entities.GetLocalPlayer():GetWeaponID() == WEAPONID[k] then
            return true
        end
    end
end
local function perWeapon_Checkbox(varname, PARENT, VARNAME, NAME, VALUE)
    for k, v in pairs(WEAPON_GROUPS_NAME) do
        WEAPON_ELEMENT[v..'_'..varname] = gui.Checkbox(PARENT, string.lower(v)..'.'..VARNAME, NAME, VALUE)
    end
end
local function perWeapon_Combobox(varname, PARENT, VARNAME, NAME, ...)
    for k, v in pairs(WEAPON_GROUPS_NAME) do
        WEAPON_ELEMENT[v..'_'..varname] = gui.Combobox(PARENT, string.lower(v)..'.'..VARNAME, NAME, ...)
    end
end
local function perWeapon_SetValues(PARENTS, VALUES)
    --[[ local WEAPON_GROUPS_ID = {}
    local WEAPON_CURRENT_GROUP_ID
    for k, v in pairs(WEAPON_GROUPS_NAME) do
        WEAPON_GROUPS_ID[k] = k
        if WEAPON_CURRENT_GROUP == WEAPON_GROUPS_NAME[k] then
            WEAPON_CURRENT_GROUP_ID = k
        end
    end
    for k, v in pairs(WEAPON_GROUPS_ID) do
        if WEAPON_CURRENT_GROUP_ID == WEAPON_GROUPS_ID[k] then
            gui.SetValue(PARENT, VALUES[k]:GetValue())
        end
    end ]]
    for k, v in pairs(PARENTS) do
        gui.SetValue(PARENTS[k], VALUES[k]:GetValue())
    end
end
local function perGroup_SetInvisible(PARENTS)
    local WEAPON_GROUPS_ID = {}
    local WEAPON_CURRENT_GROUP_ID
    for k, v in pairs(WEAPON_GROUPS_NAME) do
        WEAPON_GROUPS_ID[k] = k
        if WEAPON_CURRENT_GROUP == WEAPON_GROUPS_NAME[k] then
            WEAPON_CURRENT_GROUP_ID = k
        end
        PARENTS[k]:SetInvisible(true)
    end
    
    for k, v in pairs(WEAPON_GROUPS_ID) do
        if WEAPON_CURRENT_GROUP_ID == WEAPON_GROUPS_ID[k] then
            PARENTS[k]:SetInvisible(false)
        end
    end
end
local function set_weapon_group(PARENT, VARNAME, NAME, WEAPONID)
    if lp_weapon_id(WEAPONID) then
        PARENT:SetText('Current weapon group: ' ..NAME)
        WEAPON_CURRENT_GROUP = VARNAME
    end
end

local MINICORD_TAB                          = gui.Tab(gui.Reference('Ragebot'), 'minicord', '#project_unknown_2_0_0')
local MINICORD_SUBTAB_WEAPONSELECTION       = gui.Groupbox(MINICORD_TAB, 'Weapon selection', 16, 16, 248, 200)
local MINICORD_SUBTAB_DOUBLEFIRE            = gui.Groupbox(MINICORD_TAB, 'Double fire', 280, 16, 340, 200)

local MINICORD_CURRENT_WEAPON               = gui.Text(MINICORD_SUBTAB_WEAPONSELECTION, 'Current weapon group: global')

perWeapon_Combobox('DOUBLEFIREMODE', MINICORD_SUBTAB_DOUBLEFIRE, 'doublefire.mode', 'Double fire mode', 'Off', 'Shift', 'Rapid')

local function doublefire()
    perGroup_SetInvisible({ WEAPON_ELEMENT.PISTOL_DOUBLEFIREMODE, WEAPON_ELEMENT.HPISTOL_DOUBLEFIREMODE, WEAPON_ELEMENT.SMG_DOUBLEFIREMODE, 
                            WEAPON_ELEMENT.RIFLE_DOUBLEFIREMODE, WEAPON_ELEMENT.SHOTGUN_DOUBLEFIREMODE, WEAPON_ELEMENT.SCOUT_DOUBLEFIREMODE,
                            WEAPON_ELEMENT.ASNIPER_DOUBLEFIREMODE, WEAPON_ELEMENT.SNIPER_DOUBLEFIREMODE, WEAPON_ELEMENT.LMG_DOUBLEFIREMODE })


    perWeapon_SetValues({   'rbot.accuracy.weapon.pistol.doublefire', 'rbot.accuracy.weapon.hpistol.doublefire', 'rbot.accuracy.weapon.smg.doublefire',
                            'rbot.accuracy.weapon.rifle.doublefire', 'rbot.accuracy.weapon.shotgun.doublefire', 'rbot.accuracy.weapon.scout.doublefire',
                            'rbot.accuracy.weapon.asniper.doublefire', 'rbot.accuracy.weapon.sniper.doublefire', 'rbot.accuracy.weapon.lmg.doublefire' },
                        {   WEAPON_ELEMENT.PISTOL_DOUBLEFIREMODE, WEAPON_ELEMENT.HPISTOL_DOUBLEFIREMODE, WEAPON_ELEMENT.SMG_DOUBLEFIREMODE,
                            WEAPON_ELEMENT.RIFLE_DOUBLEFIREMODE, WEAPON_ELEMENT.SHOTGUN_DOUBLEFIREMODE, WEAPON_ELEMENT.SCOUT_DOUBLEFIREMODE,
                            WEAPON_ELEMENT.ASNIPER_DOUBLEFIREMODE, WEAPON_ELEMENT.SNIPER_DOUBLEFIREMODE, WEAPON_ELEMENT.LMG_DOUBLEFIREMODE })
    --[[ perWeapon_SetValues(    'rbot.accuracy.weapon.'..string.lower(WEAPON_CURRENT_GROUP)..'.doublefire',
                        {   WEAPON_ELEMENT.PISTOL_DOUBLEFIREMODE, WEAPON_ELEMENT.HPISTOL_DOUBLEFIREMODE, WEAPON_ELEMENT.SMG_DOUBLEFIREMODE,
                            WEAPON_ELEMENT.RIFLE_DOUBLEFIREMODE, WEAPON_ELEMENT.SHOTGUN_DOUBLEFIREMODE, WEAPON_ELEMENT.SCOUT_DOUBLEFIREMODE,
                            WEAPON_ELEMENT.ASNIPER_DOUBLEFIREMODE, WEAPON_ELEMENT.SNIPER_DOUBLEFIREMODE, WEAPON_ELEMENT.LMG_DOUBLEFIREMODE }) ]]
end

local function main()
    if not entities.GetLocalPlayer():IsAlive() then
        return
    end

    if not lp_weapon_id(WEAPONID_PISTOLS, WEAPONID_HEAVYPISTOLS, WEAPONID_SUBMACHINEGUNS, WEAPONID_RIFLES, WEAPONID_SHOTGUNS, WEAPONID_SCOUT, WEAPONID_AUTOSNIPERS, WEAPONID_SNIPER, WEAPONID_LIGHTMACHINEGUNS) then
                      MINICORD_CURRENT_WEAPON:SetText(       'Current weapon group: global');
    end
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'PISTOL',     'pistols',            WEAPONID_PISTOLS          )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'HPISTOL',    'heavy pistols',      WEAPONID_HEAVYPISTOLS     )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'SMG',        'submachine guns',    WEAPONID_SUBMACHINEGUNS   )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'RIFLE',      'rifles',             WEAPONID_RIFLES           )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'SHOTGUN',    'shotguns',           WEAPONID_SHOTGUNS         )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'SCOUT',      'scout',              WEAPONID_SCOUT            )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'ASNIPER',    'auto snipers',       WEAPONID_AUTOSNIPERS      )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'SNIPER',     'sniper',             WEAPONID_SNIPER           )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'LMG',        'light machine guns', WEAPONID_LIGHTMACHINEGUNS )

    doublefire()
end
callbacks.Register('Draw', 'MinicordMain', main)
