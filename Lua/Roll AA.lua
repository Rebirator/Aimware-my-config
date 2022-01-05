------------------------------------------Credits-------------------------------------------
                              print(
                              "-------------------------------",
                              "-- Roll AA made by GLadiator --",
                              "-------------------------------"
                              );
------------------------------------------Credits-------------------------------------------

local math_sqrt, bit_band, entities_GetLocalPlayer, gui_GetValue = math.sqrt, bit.band, entities.GetLocalPlayer, gui.GetValue;

local g_bRollAA         = gui.Checkbox( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaa", "◆ Enable Roll AA ◆", false );
g_bRollAA:SetDescription( "Enabling extended desync degree" );
local g_iRollAAValue    = gui.Slider( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaalength", "Roll AA Length", 45, 1, 45 );
g_iRollAAValue:SetDescription( "Length standing of extended desync degree." );
local g_iRollAAMovValue = gui.Slider( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaamovlength", "Roll AA Move Length", 0, 0, 45 );
g_iRollAAMovValue:SetDescription( "The higher the value, the more incorrect the movement." );

callbacks.Register( "CreateMove", "RollAA001", function( UserCmd )
    if g_bRollAA:GetValue( ) then
        local local_player = entities.GetLocalPlayer( );
        if math.sqrt( local_player:GetPropFloat( "localdata", "m_vecVelocity[0]" ) ^ 2 + local_player:GetPropFloat( "localdata", "m_vecVelocity[1]" ) ^ 2 ) < 5 then
            if gui_GetValue( "rbot.antiaim.base.rotation" ) > 0 then
                UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, g_iRollAAValue:GetValue( ) );
            else
                UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, -g_iRollAAValue:GetValue( ) );
            end;
        elseif math.sqrt( local_player:GetPropFloat( "localdata", "m_vecVelocity[0]" ) ^ 2 + local_player:GetPropFloat( "localdata", "m_vecVelocity[1]" ) ^ 2 ) > 5 and g_iRollAAMovValue:GetValue( ) > 0 and bit_band( local_player:GetPropInt( "m_fFlags" ), 1 ) == 1 then
            if gui_GetValue( "rbot.antiaim.base.rotation" ) > 0 then
                UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, g_iRollAAValue:GetValue( ) );
            else
                UserCmd.viewangles = EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, -g_iRollAAValue:GetValue( ) );
            end;
        end;
    end
end );
