local CURRENT_WEAPON_GROUP      = ''
local WEAPONID_PISTOLS          = { 2, 3, 4, 30, 32, 36, 61, 63 }
local WEAPONID_HEAVYPISTOLS     = { 1, 64 }
local WEAPONID_SUBMACHINEGUNS   = { 17, 19, 23, 24, 26, 33, 34 }
local WEAPONID_RIFLES           = { 7, 8, 10, 13, 16, 39, 60 }
local WEAPONID_SHOTGUNS         = { 25, 27, 29, 35 }
local WEAPONID_SCOUT            = { 40 }
local WEAPONID_AUTOSNIPERS      = { 11, 38 }
local WEAPONID_SNIPER           = { 9 }
local WEAPONID_LIGHTMACHINEGUNS = { 14, 28 }
local WEAPON_GROUPS_NAME        = { 'PISTOLS', 'HPISTOLS', 'SMGS', 'RIFLES', 'SHOTGUNS', 'SCOUT', 'AUTOSNIPERS', 'SNIPER', 'LMGS' }
local WEAPON_ELEMENT            = {}

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
local function perWeapon_SetInvisible(PARENTS)
    local WEAPON_GROUPS_TO_ID = {}
    local CURRENT_WEAPON_GROUP_TO_ID
    for k, v in pairs(WEAPON_GROUPS_NAME) do
        WEAPON_GROUPS_TO_ID[k] = k
        if CURRENT_WEAPON_GROUP == WEAPON_GROUPS_NAME[k] then
            CURRENT_WEAPON_GROUP_TO_ID = k
        end
        PARENTS[k]:SetInvisible(true)
    end
    for k, v in pairs(WEAPON_GROUPS_TO_ID) do
        if CURRENT_WEAPON_GROUP_TO_ID == WEAPON_GROUPS_TO_ID[k] then
            PARENTS[k]:SetInvisible(false)
        end
    end
end
local function lp_weapon_id(WEAPONID)
    for k, v in pairs(WEAPONID) do
        if entities.GetLocalPlayer():GetWeaponID() == WEAPONID[k] then
            return true
        end
    end
end
local function set_weapon_group(PARENT, VARNAME, NAME, WEAPONID)
    if lp_weapon_id(WEAPONID) then
        PARENT:SetText('Current weapon group: ' ..NAME)
        CURRENT_WEAPON_GROUP = VARNAME
    end
end

local MINICORD_TAB = gui.Tab(gui.Reference('Ragebot'), 'minicord', '#project_unknown_2_0_0')
local MINICORD_SUBTAB_WEAPONSELECTION = gui.Groupbox(MINICORD_TAB, 'Weapon selection', 16, 16, 248, 200)
local MINICORD_SUBTAB_DOUBLEFIRE = gui.Groupbox(MINICORD_TAB, 'Double fire', 280, 16, 340, 200)

local MINICORD_CURRENT_WEAPON = gui.Text(MINICORD_SUBTAB_WEAPONSELECTION, 'Current weapon group: global')

perWeapon_Checkbox('DOUBLEFIREENABLE', MINICORD_SUBTAB_DOUBLEFIRE, 'doublefire.enable', 'Enable', false)
perWeapon_Combobox('DOUBLEFIREMODE', MINICORD_SUBTAB_DOUBLEFIRE, 'doublefire.mode', 'Double fire mode', 'Off', 'Shift', 'Rapid')

local function main()
    if not entities.GetLocalPlayer():IsAlive() then
        return
    end

    if not lp_weapon_id(WEAPONID_PISTOLS, WEAPONID_HEAVYPISTOLS, WEAPONID_SUBMACHINEGUNS, WEAPONID_RIFLES, WEAPONID_SHOTGUNS, WEAPONID_SCOUT, WEAPONID_AUTOSNIPERS, WEAPONID_SNIPER, WEAPONID_LIGHTMACHINEGUNS) then
        MINICORD_CURRENT_WEAPON:SetText(       'Current weapon group: global');
        WEAPON_GROUP = 'global'
    end
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'PISTOLS',     'pistols',            WEAPONID_PISTOLS          )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'HPISTOLS',    'heavy pistols',      WEAPONID_HEAVYPISTOLS     )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'SMGS',        'submachine guns',    WEAPONID_SUBMACHINEGUNS   )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'RIFLES',      'rifles',             WEAPONID_RIFLES           )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'SHOTGUNS',    'shotguns',           WEAPONID_SHOTGUNS         )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'SCOUT',       'scout',              WEAPONID_SCOUT            )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'AUTOSNIPERS', 'auto snipers',       WEAPONID_AUTOSNIPERS      )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'SNIPER',      'sniper',             WEAPONID_SNIPER           )
    set_weapon_group( MINICORD_CURRENT_WEAPON, 'LMGS',        'light machine guns', WEAPONID_LIGHTMACHINEGUNS )


    perWeapon_SetInvisible({ WEAPON_ELEMENT.PISTOLS_DOUBLEFIREENABLE, WEAPON_ELEMENT.HPISTOLS_DOUBLEFIREENABLE, WEAPON_ELEMENT.SMGS_DOUBLEFIREENABLE, 
                             WEAPON_ELEMENT.RIFLES_DOUBLEFIREENABLE, WEAPON_ELEMENT.SHOTGUNS_DOUBLEFIREENABLE, WEAPON_ELEMENT.SCOUT_DOUBLEFIREENABLE,
                             WEAPON_ELEMENT.AUTOSNIPERS_DOUBLEFIREENABLE, WEAPON_ELEMENT.SNIPER_DOUBLEFIREENABLE, WEAPON_ELEMENT.LMGS_DOUBLEFIREENABLE })
    perWeapon_SetInvisible({ WEAPON_ELEMENT.PISTOLS_DOUBLEFIREMODE, WEAPON_ELEMENT.HPISTOLS_DOUBLEFIREMODE, WEAPON_ELEMENT.SMGS_DOUBLEFIREMODE, 
                             WEAPON_ELEMENT.RIFLES_DOUBLEFIREMODE, WEAPON_ELEMENT.SHOTGUNS_DOUBLEFIREMODE, WEAPON_ELEMENT.SCOUT_DOUBLEFIREMODE,
                             WEAPON_ELEMENT.AUTOSNIPERS_DOUBLEFIREMODE, WEAPON_ELEMENT.SNIPER_DOUBLEFIREMODE, WEAPON_ELEMENT.LMGS_DOUBLEFIREMODE })
end
callbacks.Register('Draw', 'MinicordMain', main)
