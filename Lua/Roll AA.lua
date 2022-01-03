------------------------------------------Credits-------------------------------------------
                              print(
                              "-------------------------------",
                              "-- Roll AA made by GLadiator --",
                              "-------------------------------"
                              );
------------------------------------------Credits-------------------------------------------

local math_sqrt, bit_band, entities_GetLocalPlayer = math.sqrt, bit.band, entities.GetLocalPlayer;

local g_bRollAA         = gui.Checkbox( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaa", "◆ Enable Roll AA ◆", false );
g_bRollAA:SetDescription( "Enabling extended desync degree" );
local g_iRollAAValue    = gui.Slider( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaalength", "Roll AA Length", 45, 1, 58 );
g_iRollAAValue:SetDescription( "Length of extended desync degree" );
local g_iRollAAMovValue = gui.Slider( gui.Reference("Ragebot", "Anti-Aim", "Extra" ), "rollaamovlength", "Roll AA Move Length", 1, 1, 58 );
g_iRollAAMovValue:SetDescription( "The higher the value, the more incorrect the movement." )

callbacks.Register( "CreateMove", "RollAA001", function( UserCmd )
    if g_bRollAA:GetValue( ) then
        local local_player = entities.GetLocalPlayer( );
        if math.sqrt( local_player:GetPropFloat( "localdata", "m_vecVelocity[0]" ) ^ 2 + local_player:GetPropFloat( "localdata", "m_vecVelocity[1]" ) ^ 2 ) < 10 then
            UserCmd:SetViewAngles( EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, UserCmd.viewangles.z + g_iRollAAValue:GetValue( ) ) );
        else
            if bit_band( local_player:GetPropInt( "m_fFlags" ), 1 ) == 1 then
                UserCmd:SetViewAngles( EulerAngles( UserCmd.viewangles.x, UserCmd.viewangles.y, UserCmd.viewangles.z + g_iRollAAMovValue:GetValue( ) ) );
            end;
        end;
    end;
end );
