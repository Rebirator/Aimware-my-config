------------------------------------------Credits-------------------------------------------
                              print(
                              "-------------------------------",
                              "-- Roll AA made by GLadiator --",
                              "-------------------------------"
                              );
------------------------------------------Credits-------------------------------------------

local math_sqrt, bit_band, entities_GetLocalPlayer, gui_GetValue = math.sqrt, bit.band, entities.GetLocalPlayer, gui.GetValue;
local WEAPONID_KNIFES = { 41, 42, 59, 69, 74, 75, 76, 78, 500, 503, 505, 506, 507, 508, 509, 512, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 525 };
local function LPWeaponID( weapon_id )
    for k, v in pairs( weapon_id ) do
        if entities_GetLocalPlayer( ):GetWeaponID( ) == weapon_id[ k ] then
            return true;
        end;
    end;
end;

local g_bRollAA         = gui.Checkbox( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaa", "◆ Enable Roll AA ◆", false );
g_bRollAA:SetDescription( "Enabling extended desync degree" );
local g_iRollAAValue    = gui.Slider( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaalength", "Roll AA Length", 45, 1, 45 );
g_iRollAAValue:SetDescription( "Length of extended desync degree" );
local g_iRollAAMovValue = gui.Slider( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaamovlength", "Roll AA Move Length", 0, 0, 45 );
g_iRollAAMovValue:SetDescription( "The higher the value, the more incorrect the movement." );

callbacks.Register( "CreateMove", "RollAA001", function( UserCmd )
    if LPWeaponID( WEAPONID_KNIFES ) then 
        UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, 0 );
    end;
    
    if g_bRollAA:GetValue( ) then
        local local_player = entities.GetLocalPlayer( );
        if math.sqrt( local_player:GetPropFloat( "localdata", "m_vecVelocity[0]" ) ^ 2 + local_player:GetPropFloat( "localdata", "m_vecVelocity[1]" ) ^ 2 ) < 10 then
            if gui_GetValue( "rbot.antiaim.base.rotation" ) > 0 then
                UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, g_iRollAAValue:GetValue( ) );
            else
                UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, -g_iRollAAValue:GetValue( ) );
            end;
        else
            if g_iRollAAMovValue:GetValue( ) > 0 and bit_band( local_player:GetPropInt( "m_fFlags" ), 1 ) == 1 then
                if gui_GetValue( "rbot.antiaim.base.rotation" ) > 0 then
                    UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, g_iRollAAMovValue:GetValue( ) );
                else
                    UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, -g_iRollAAMovValue:GetValue( ) );
                end;
            end;
        end;
    end;
    print(UserCmd.viewangles)
end );
