local MINICORD_TAB = gui.Tab(gui.Reference('Ragebot'), 'minicord', '#project_unknown_2_0_0')
local MINICORD_SUBTAB_WEAPSELECTION = gui.Groupbox(MINICORD_TAB, 'Weapon selection', 16, 16, 248, 200)

local MINICORD_CURRENT_WEAPON = gui.Text(MINICORD_SUBTAB_WEAPSELECTION, 'Current weapon group: global')

local WEAPONID_PISTOLS = { 2, 3, 4, 30, 32, 36, 61, 63 }
local WEAPONID_HEAVYPISTOLS = { 1, 64 }
local WEAPONID_SUBMACHINEGUNS = { 17, 19, 23, 24, 26, 33, 34 }
local WEAPONID_RIFLES = { 7, 8, 10, 13, 16, 39, 60 }
local WEAPONID_SHOTGUNS = { 25, 27, 29, 35 }
local WEAPONID_SCOUT = { 40 }
local WEAPONID_AUTOSNIPERS = { 11, 38 }
local WEAPONID_SNIPER = { 9 }
local WEAPONID_LIGHTMACHINEGUNS = { 14, 28 }

local function get_weapon_id(WEAPONID)
    for k, v in pairs(WEAPONID) do
        if entities.GetLocalPlayer():GetWeaponID() == WEAPONID[k] then
            return true
        end
    end
end
local function weapId_set_text(PARENT, TEXT, WEAPONID)
    if get_weapon_id(WEAPONID) then
        PARENT:SetText(TEXT)
    end
end

local function set_weapon_group()
    if not entities.GetLocalPlayer():IsAlive() then
        return
    end

    if not get_weapon_id(WEAPONID_PISTOLS, WEAPONID_HEAVYPISTOLS, WEAPONID_SUBMACHINEGUNS, WEAPONID_RIFLES, WEAPONID_SHOTGUNS, WEAPONID_SCOUT, WEAPONID_AUTOSNIPERS, WEAPONID_SNIPER, WEAPONID_LIGHTMACHINEGUNS) then
        MINICORD_CURRENT_WEAPON:SetText(     'Current weapon group: global'); end
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: pistol',              WEAPONID_PISTOLS)
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: heavy pistol',        WEAPONID_HEAVYPISTOLS)
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: submachine Gun',      WEAPONID_SUBMACHINEGUNS)
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: rifle',               WEAPONID_RIFLES)
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: shotgun',             WEAPONID_SHOTGUNS)
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: scout',               WEAPONID_SCOUT)
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: auto sniper',         WEAPONID_AUTOSNIPERS)
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: sniper',              WEAPONID_SNIPER)
    weapId_set_text(MINICORD_CURRENT_WEAPON, 'Current weapon group: light machine gun',   WEAPONID_LIGHTMACHINEGUNS)
end
callbacks.Register('Draw', '##test', set_weapon_group)
