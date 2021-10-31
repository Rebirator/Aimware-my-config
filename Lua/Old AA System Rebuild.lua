--[[--------------------------------------Credits---------------------------------------------------

                       Old Anti-Aim System Rebuild made by GLadiator                             

------------------------------------------Credits-----------------------------------------------]]--

local entities_GetByIndex, globals_CurTime, globals_MaxClients, gui_GetValue, gui_SetValue, gui_Reference, gui_Command
=
      entities.GetByIndex, globals.CurTime, globals.MaxClients, gui.GetValue, gui.SetValue, gui.Reference, gui.Command
;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

gui_Reference( "Ragebot", "Anti-Aim", "Base Direction" ):SetInvisible( true );
gui_Reference( "Ragebot", "Anti-Aim", "Left Direction" ):SetInvisible( true );
gui_Reference( "Ragebot", "Anti-Aim", "Right Direction" ):SetInvisible( true );
gui_Reference( "Ragebot", "Anti-Aim", "Extra" ):SetInvisible( true );
gui_Reference( "Ragebot", "Anti-Aim", "Advanced" ):SetInvisible( true );
gui_Reference( "Ragebot", "Anti-Aim", "Condition" ):SetInvisible( true );

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ANTIAIM_TAB                         = gui_Reference( "Ragebot", "Anti-Aim" );

local ANTIAIM_ANTIAIM_SUBTAB                = gui.Groupbox( ANTIAIM_TAB, "Anti-Aim", 16, 16, 296, 1 )
local ANTIAIM_ANTIAIM_ENABLED               = gui.Checkbox( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.enabled", "Enable", false )
local ANTIAIM_ANTIAIM_PITCH                 = gui.Combobox( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.pitch", "Pitch Angle", "Off", "Down", "180° (Untrusted)" );
local ANTIAIM_ANTIAIM_REAL                  = gui.Combobox( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.realyaw", "Real Yaw", "Off", "Left", "Right", "Backward" );
local ANTIAIM_ANTIAIM_REAL_ADD              = gui.Slider( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.realyaw.add", "Real Yaw Angle Modifer", 0, -180, 180 );
local ANTIAIM_ANTIAIM_FAKE                  = gui.Combobox( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.fakeyaw", "Fake Yaw", "Off", "Default", "Opposite" );
local ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE    = gui.Slider( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.fakeyaw.default.value", "Maximum Desync", 0, -58, 58 );
local ANTIAIM_ANTIAIM_FAKE_AUTODIR_LEFT     = gui.Slider( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.fakeyaw.autodir.left", "Maximum Desync Left", 0, 0, 58 );
local ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT    = gui.Slider( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.fakeyaw.autodir.right", "Maximum Desync Right", 0, 0, 58 );
local ANTIAIM_ANTIAIM_ATTARGETS             = gui.Combobox( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.attargets", "At Targets", "Off", "FOV Based", "Distance Based" );
local ANTIAIM_ANTIAIM_FAKE_AUTODIR          = gui.Checkbox( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.fakeyaw.autodir", "Auto Direction", false );
local ANTIAIM_ANTIAIM_FAKE_AUTODIR_MODE     = gui.Combobox( ANTIAIM_ANTIAIM_SUBTAB, "antiaim.fakeyaw.autodir.mode", "Auto Direction Mode", "Peek Real", "Peek Fake" );

local ANTIAIM_EXTRA_SUBTAB                  = gui.Groupbox( ANTIAIM_TAB, "Extra", 328, 16, 296, 1 );
local ANTIAIM_EXTRA_FAKEDUCK                = gui.Keybox( ANTIAIM_EXTRA_SUBTAB, "extra.fakeduck", "Fake Duck", nil );
local ANTIAIM_EXTRA_FAKEDUCK_STYLE          = gui.Combobox( ANTIAIM_EXTRA_SUBTAB, "extra.fakeduck.style", "Fake Duck Style", "Duck", "Unduck" );
local ANTIAIM_EXTRA_STATICLEGS              = gui.Checkbox( ANTIAIM_EXTRA_SUBTAB, "extra.staticlegs", "Static Legs", false );
local ANTIAIM_EXTRA_CONDITIONS              = gui.Multibox( ANTIAIM_EXTRA_SUBTAB, "Conditions" );
local ANTIAIM_EXTRA_CONDITIONS_ONUSE        = gui.Checkbox( ANTIAIM_EXTRA_CONDITIONS, "extra.conditions.onuse", "Disable On Use", false );
local ANTIAIM_EXTRA_CONDITIONS_ONKNIFE      = gui.Checkbox( ANTIAIM_EXTRA_CONDITIONS, "extra.conditions.onknife", "Disable On Knife", false );
local ANTIAIM_EXTRA_CONDITIONS_ONGRENADE    = gui.Checkbox( ANTIAIM_EXTRA_CONDITIONS, "extra.conditions.ongrenade", "Disable On Grenade", false );
local ANTIAIM_EXTRA_CONDITIONS_FREEZETIME   = gui.Checkbox( ANTIAIM_EXTRA_CONDITIONS, "extra.conditions.freezetime", "During Freeze Time", false );
local ANTIAIM_EXTRA_SHIFTONSHOT             = gui.Checkbox( ANTIAIM_EXTRA_SUBTAB, "extra.shiftonshot", "Shift On Shot", false );
local ANTIAIM_EXTRA_FAKEEXPOSE              = gui.Keybox( ANTIAIM_EXTRA_SUBTAB, "extra.fakeexpose", "Fake Expose Toggle", nil );
local ANTIAIM_EXTRA_FAKEEXPOSE_TYPE         = gui.Combobox( ANTIAIM_EXTRA_SUBTAB, "extra.fakeexpose.type", "Fake Expose Type", "1s", "1.5s" );
local ANTIAIM_EXTRA_ANTIRESOLVER            = gui.Checkbox( ANTIAIM_EXTRA_SUBTAB, "extra.antiresolver", "Anti-Resolver", false );

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ANTIAIM_ANTIAIM_ATTARGETS:SetDescription( "Auto rotate towards enemies to hide head.");
ANTIAIM_ANTIAIM_FAKE_AUTODIR_MODE:SetDescription( "Counter edge-based resolvers." );
ANTIAIM_EXTRA_FAKEDUCK:SetDescription( "Allows you to shoot higher while crouching." );
ANTIAIM_EXTRA_STATICLEGS:SetDescription( "Makes your legs static when slow walking." );
ANTIAIM_EXTRA_SHIFTONSHOT:SetDescription( "Prevent your on shot model from getting hit." );
ANTIAIM_EXTRA_FAKEEXPOSE:SetDescription( "Flick fake head on edge when enabled." );
ANTIAIM_EXTRA_FAKEEXPOSE_TYPE:SetDescription( "Method of fake expose." );
ANTIAIM_EXTRA_ANTIRESOLVER:SetDescription( "Makes continous shots harder to hit." );

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local g_last_curtime                = nil;

local g_cache_pitch                 = nil;
local g_cache_realyaw               = nil;
local g_cache_realyaw_add           = nil;
local g_cache_desync_side           = nil;
local g_cache_fakeyaw               = nil;
local g_cache_fakeyaw_def_value     = nil;
local g_cache_fakeyaw_autodir_left  = nil;
local g_cache_fakeyaw_autodir_right = nil;
local g_cache_fakeyaw_autodir       = nil;
local g_cache_fakeyaw_autodir_mode  = nil;
local g_cache_attargets             = nil;
local g_cache_fakeduckkey           = nil;
local g_cache_fakeduck_style        = nil;
local g_cache_staticlegs            = nil;
local g_cache_conditions_onuse      = nil;
local g_cache_conditions_onknife    = nil;
local g_cache_conditions_ongrenade  = nil;
local g_cache_conditions_freezetime = nil;
local g_cache_shiftonshot           = nil;
local g_cache_fakeexpose            = nil;
local g_cache_fakeexpose_type       = nil;
local g_cache_antiresolver          = nil;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function ClampYaw( angle )
    while angle < -180 do
        return angle + 360;
    end
    while angle > 180 do
        return angle + -360;
    end
    return angle;
end;

local function MenuController( )
    if ANTIAIM_ANTIAIM_REAL:GetValue( ) ~= 0 then
        ANTIAIM_ANTIAIM_REAL_ADD:SetInvisible( false );
        ANTIAIM_ANTIAIM_ATTARGETS:SetInvisible( false );
    else
        ANTIAIM_ANTIAIM_REAL_ADD:SetInvisible( true );
        ANTIAIM_ANTIAIM_ATTARGETS:SetInvisible( true );
    end;

    if ANTIAIM_ANTIAIM_FAKE:GetValue( ) ~= 0 then
        ANTIAIM_ANTIAIM_FAKE_AUTODIR:SetInvisible( false );
        ANTIAIM_ANTIAIM_FAKE_AUTODIR_MODE:SetInvisible( false );
        if ANTIAIM_ANTIAIM_FAKE_AUTODIR:GetValue( ) then
            ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE:SetInvisible( true );
            ANTIAIM_ANTIAIM_FAKE_AUTODIR_LEFT:SetInvisible( false );
            ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT:SetInvisible( false );
        else
            ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE:SetInvisible( false );
            ANTIAIM_ANTIAIM_FAKE_AUTODIR_LEFT:SetInvisible( true );
            ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT:SetInvisible( true );
        end;
    else
        ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE:SetInvisible( true );
        ANTIAIM_ANTIAIM_FAKE_AUTODIR_LEFT:SetInvisible( true );
        ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT:SetInvisible( true );
        ANTIAIM_ANTIAIM_FAKE_AUTODIR:SetInvisible( true );
        ANTIAIM_ANTIAIM_FAKE_AUTODIR_MODE:SetInvisible( true );
    end
end;

local function Pitch( )
    if g_cache_pitch == ANTIAIM_ANTIAIM_PITCH:GetValue( ) then
        return;
    end;
    
    if ANTIAIM_ANTIAIM_PITCH:GetValue( ) == 1 then
        gui_SetValue( "rbot.antiaim.advanced.pitch", 1 );
    elseif ANTIAIM_ANTIAIM_PITCH:GetValue( ) == 2 then
        gui_SetValue( "rbot.antiaim.advanced.pitch", 2 );
    else
        gui_SetValue( "rbot.antiaim.advanced.pitch", 0 );
    end;

    g_cache_pitch = ANTIAIM_ANTIAIM_PITCH:GetValue( );
end;

local function RealYaw( )
    if g_cache_realyaw == ANTIAIM_ANTIAIM_REAL:GetValue( ) and g_cache_realyaw_add == ANTIAIM_ANTIAIM_REAL_ADD:GetValue( ) then
        return;
    end;

    if ANTIAIM_ANTIAIM_REAL:GetValue( ) == 1 then
        local yaw_left = ClampYaw( 100 + ANTIAIM_ANTIAIM_REAL_ADD:GetValue( ) );
        gui_Command( "rbot.antiaim.base " .. yaw_left .. " \"Desync\"" );
        gui_Command( "rbot.antiaim.left " .. yaw_left .. " \"Desync\"" );
        gui_Command( "rbot.antiaim.right " .. yaw_left .. " \"Desync\"" );
    elseif ANTIAIM_ANTIAIM_REAL:GetValue( ) == 2 then
        local yaw_right = ClampYaw( -100     + ANTIAIM_ANTIAIM_REAL_ADD:GetValue( ) );
        gui_Command( "rbot.antiaim.base " .. yaw_right .. " \"Desync\"" );
        gui_Command( "rbot.antiaim.left " .. yaw_right .. " \"Desync\"" );
        gui_Command( "rbot.antiaim.right " .. yaw_right .. " \"Desync\"" );
    elseif ANTIAIM_ANTIAIM_REAL:GetValue( ) == 3 then
        local yaw_backward = ClampYaw( -180 + ANTIAIM_ANTIAIM_REAL_ADD:GetValue( ) );
        gui_Command( "rbot.antiaim.base " .. yaw_backward .. " \"Desync\"" );
        gui_Command( "rbot.antiaim.left " .. yaw_backward .. " \"Desync\"" );
        gui_Command( "rbot.antiaim.right " .. yaw_backward .. " \"Desync\"" );
    else
        gui_Command( "rbot.antiaim.base 0 \"Desync\"" );
        gui_SetValue( "rbot.antiaim.advanced.autodir.edges", 0 );
        gui_SetValue( "rbot.antiaim.advanced.autodir.targets", 0 );
    end;

    g_cache_realyaw      = ANTIAIM_ANTIAIM_REAL:GetValue( );
    g_cache_realyaw_add  = ANTIAIM_ANTIAIM_REAL_ADD:GetValue( );
end;

local function FakeYaw( )
    if ANTIAIM_ANTIAIM_FAKE:GetValue( ) == 0 then
        gui_SetValue( "rbot.antiaim.base.rotation", 0 );
        g_cache_fakeyaw = ANTIAIM_ANTIAIM_FAKE:GetValue( );
        return;
    end

    if ANTIAIM_ANTIAIM_FAKE_AUTODIR:GetValue( ) then
        if g_cache_fakeyaw == ANTIAIM_ANTIAIM_FAKE:GetValue( ) and g_cache_fakeyaw_autodir == ANTIAIM_ANTIAIM_FAKE_AUTODIR:GetValue( )
        and g_cache_fakeyaw_autodir_left == ANTIAIM_ANTIAIM_FAKE_AUTODIR_LEFT:GetValue( ) and g_cache_fakeyaw_autodir_right == ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT:GetValue( )
        and g_cache_fakeyaw_autodir_mode == ANTIAIM_ANTIAIM_FAKE_AUTODIR_MODE:GetValue( ) then
            return;
        end;

        gui_SetValue( "rbot.antiaim.base.rotation", -ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT:GetValue( ) );
        gui_SetValue( "rbot.antiaim.base.lby", 120 );
        gui_SetValue( "rbot.antiaim.advanced.autodir.edges", 1 );

        if ANTIAIM_ANTIAIM_FAKE:GetValue( ) == 1 then
            gui_SetValue( "rbot.antiaim.advanced.antialign", 1 );
        elseif ANTIAIM_ANTIAIM_FAKE:GetValue( ) == 2 then
            gui_SetValue( "rbot.antiaim.advanced.antialign", 0 );
        end;

        if ANTIAIM_ANTIAIM_FAKE_AUTODIR_MODE:GetValue( ) == 0 then
            gui_SetValue( "rbot.antiaim.left.rotation", ANTIAIM_ANTIAIM_FAKE_AUTODIR_LEFT:GetValue( ) );
            gui_SetValue( "rbot.antiaim.right.rotation", -ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT:GetValue( ) );
            gui_SetValue( "rbot.antiaim.left.lby", -120 );
            gui_SetValue( "rbot.antiaim.right.lby", 120 );
        elseif ANTIAIM_ANTIAIM_FAKE_AUTODIR_MODE:GetValue( ) == 1 then
            gui_SetValue( "rbot.antiaim.left.rotation", -ANTIAIM_ANTIAIM_FAKE_AUTODIR_LEFT:GetValue( ) );
            gui_SetValue( "rbot.antiaim.right.rotation", ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT:GetValue( ) );
            gui_SetValue( "rbot.antiaim.left.lby", 120 );
            gui_SetValue( "rbot.antiaim.right.lby", -120 );
        end

        g_cache_fakeyaw = ANTIAIM_ANTIAIM_FAKE:GetValue( );
        g_cache_fakeyaw_autodir = ANTIAIM_ANTIAIM_FAKE_AUTODIR:GetValue( );
        g_cache_fakeyaw_autodir_left = ANTIAIM_ANTIAIM_FAKE_AUTODIR_LEFT:GetValue( );
        g_cache_fakeyaw_autodir_right = ANTIAIM_ANTIAIM_FAKE_AUTODIR_RIGHT:GetValue( );
        g_cache_fakeyaw_autodir_mode = ANTIAIM_ANTIAIM_FAKE_AUTODIR_MODE:GetValue( );
    else
        if g_cache_fakeyaw == ANTIAIM_ANTIAIM_FAKE:GetValue( ) and g_cache_fakeyaw_def_value == ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE:GetValue( ) then
            return;
        end;

        gui_SetValue( "rbot.antiaim.advanced.autodir.edges", 0 );

        if ANTIAIM_ANTIAIM_FAKE:GetValue( ) == 1 then
            gui_SetValue( "rbot.antiaim.advanced.antialign", 1 );
        elseif ANTIAIM_ANTIAIM_FAKE:GetValue( ) == 2 then
            gui_SetValue( "rbot.antiaim.advanced.antialign", 0 );
        end;

        gui_SetValue( "rbot.antiaim.base.rotation", ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE:GetValue( ) );

        if ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE:GetValue( ) >= 0 then
            gui_SetValue( "rbot.antiaim.base.lby", -120 );
        elseif ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE:GetValue( ) < 0 then
            gui_SetValue( "rbot.antiaim.base.lby", 120 );
        end

        g_cache_fakeyaw             = ANTIAIM_ANTIAIM_FAKE:GetValue( );
        g_cache_fakeyaw_def_value   = ANTIAIM_ANTIAIM_FAKE_DEFAULT_VALUE:GetValue( );
    end;
end;

local function AtTargets( )
    if g_cache_attargets == ANTIAIM_ANTIAIM_ATTARGETS:GetValue( ) then
        return;
    end;

    if ANTIAIM_ANTIAIM_ATTARGETS:GetValue( ) == 0 then
        gui_SetValue( "rbot.antiaim.advanced.autodir.targets", 0 );
    elseif ANTIAIM_ANTIAIM_ATTARGETS:GetValue( ) == 1 then
        gui_SetValue( "rbot.antiaim.advanced.autodir.targets", 1 );
        gui_SetValue( "rbot.antiaim.advanced.autodirstyle", 1 );
    elseif ANTIAIM_ANTIAIM_ATTARGETS:GetValue( ) == 2 then
        gui_SetValue( "rbot.antiaim.advanced.autodir.targets", 1 );
        gui_SetValue( "rbot.antiaim.advanced.autodirstyle", 2 );
    end;

    g_cache_attargets = ANTIAIM_ANTIAIM_ATTARGETS:GetValue( );
end;

local function FakeDuckAndStaticLegs( )
    if g_cache_fakeduckkey == ANTIAIM_EXTRA_FAKEDUCK:GetValue( ) and g_cache_fakeduck_style == ANTIAIM_EXTRA_FAKEDUCK_STYLE:GetValue( ) and g_cache_staticlegs == ANTIAIM_EXTRA_STATICLEGS:GetValue( ) then
        return;
    end

    gui_SetValue( "rbot.antiaim.extra.fakecrouchkey", ANTIAIM_EXTRA_FAKEDUCK:GetValue( ) );
    gui_SetValue( "rbot.antiaim.extra.fakecrouchstyle", ANTIAIM_EXTRA_FAKEDUCK_STYLE:GetValue( ) );
    gui_SetValue( "rbot.antiaim.extra.staticlegs", ANTIAIM_EXTRA_STATICLEGS:GetValue( ) );

    g_cache_fakeduckkey     = ANTIAIM_EXTRA_FAKEDUCK:GetValue( );
    g_cache_fakeduck_style  = ANTIAIM_EXTRA_FAKEDUCK_STYLE:GetValue( );
    g_cache_staticlegs      = ANTIAIM_EXTRA_STATICLEGS:GetValue( );
end;

local function ConditionsAndShiftOnShot( )
    if g_cache_conditions_onuse == ANTIAIM_EXTRA_CONDITIONS_ONUSE:GetValue( ) and g_cache_conditions_onknife == ANTIAIM_EXTRA_CONDITIONS_ONKNIFE:GetValue( )
    and g_cache_conditions_ongrenade == ANTIAIM_EXTRA_CONDITIONS_ONGRENADE:GetValue( ) and g_cache_conditions_freezetime == ANTIAIM_EXTRA_CONDITIONS_FREEZETIME:GetValue( )
    and g_cache_shiftonshot == ANTIAIM_EXTRA_SHIFTONSHOT:GetValue( ) then
        return;
    end;

    gui_SetValue( "rbot.antiaim.condition.use", ANTIAIM_EXTRA_CONDITIONS_ONUSE:GetValue( ) );
    gui_SetValue( "rbot.antiaim.condition.knife", ANTIAIM_EXTRA_CONDITIONS_ONKNIFE:GetValue( ) );
    gui_SetValue( "rbot.antiaim.condition.grenade", ANTIAIM_EXTRA_CONDITIONS_ONGRENADE:GetValue( ) );
    gui_SetValue( "rbot.antiaim.condition.freezetime", ANTIAIM_EXTRA_CONDITIONS_FREEZETIME:GetValue( ) );
    gui_SetValue( "rbot.antiaim.condition.shiftonshot", ANTIAIM_EXTRA_SHIFTONSHOT:GetValue( ) );

    g_cache_conditions_onuse        = ANTIAIM_EXTRA_CONDITIONS_ONUSE:GetValue( );
    g_cache_conditions_onknife      = ANTIAIM_EXTRA_CONDITIONS_ONKNIFE:GetValue( );
    g_cache_conditions_ongrenade    = ANTIAIM_EXTRA_CONDITIONS_ONGRENADE:GetValue( );
    g_cache_conditions_freezetime   = ANTIAIM_EXTRA_CONDITIONS_FREEZETIME:GetValue( );
    g_cache_shiftonshot             = ANTIAIM_EXTRA_SHIFTONSHOT:GetValue( );
end;

local function FakeExposeAndAntiResolver( )
    if g_cache_fakeexpose == ANTIAIM_EXTRA_FAKEEXPOSE:GetValue( ) and g_cache_fakeexpose_type == ANTIAIM_EXTRA_FAKEEXPOSE_TYPE:GetValue( )
    and g_cache_antiresolver == ANTIAIM_EXTRA_ANTIRESOLVER:GetValue( ) then
        return;
    end;

    gui_SetValue( "rbot.antiaim.advanced.exposefake", ANTIAIM_EXTRA_FAKEEXPOSE:GetValue( ) );
    gui_SetValue( "rbot.antiaim.advanced.exposetype", ANTIAIM_EXTRA_FAKEEXPOSE_TYPE:GetValue( ) );
    gui_SetValue( "rbot.antiaim.advanced.antiresolver", ANTIAIM_EXTRA_ANTIRESOLVER:GetValue( ) );

    g_cache_fakeexpose      = ANTIAIM_EXTRA_FAKEEXPOSE:GetValue( );
    g_cache_fakeexpose_type = ANTIAIM_EXTRA_FAKEEXPOSE_TYPE:GetValue( );
    g_cache_antiresolver    = ANTIAIM_EXTRA_ANTIRESOLVER:GetValue( );
end;

callbacks.Register( "Draw", "AntiAimSystemRebuildMain", function( )
    if globals_CurTime( ) > g_last_curtime then
        MenuController( )

        if not ANTIAIM_ANTIAIM_ENABLED:GetValue( ) then
            gui_Command( "rbot.antiaim.base 0 \"Off\"" );
            gui_SetValue( "rbot.antiaim.advanced.autodir.edges", 0 );
            gui_SetValue( "rbot.antiaim.advanced.autodir.targets", 0 );
            return;
        end

        Pitch( );
        RealYaw( );
        FakeYaw( );
        AtTargets( );
        FakeDuckAndStaticLegs( );
        ConditionsAndShiftOnShot( )
        FakeExposeAndAntiResolver( );

        g_last_curtime = globals_CurTime( ) + 0.05;
    end;
end );

local OnResetCache = gui.Button( ANTIAIM_EXTRA_SUBTAB, "Reset cache", function( )
    g_last_curtime                  = nil;

    g_cache_pitch                   = nil;
    g_cache_realyaw                 = nil;
    g_cache_realyaw_add             = nil;
    g_cache_fakeyaw                 = nil;
    g_cache_fakeyaw_def_value       = nil;
    g_cache_fakeyaw_autodir_mode    = nil;
    g_cache_fakeyaw_autodir_left    = nil;
    g_cache_fakeyaw_autodir_right   = nil;
    g_cache_fakeyaw_autodir         = nil;
    g_cache_fakeyaw_autodir_mode    = nil;
    g_cache_attargets               = nil;
    g_cache_fakeduckkey             = nil;
    g_cache_fakeduck_style          = nil;
    g_cache_staticlegs              = nil;
    g_cache_conditions_onuse        = nil;
    g_cache_conditions_onknife      = nil;
    g_cache_conditions_ongrenade    = nil;
    g_cache_conditions_freezetime   = nil;
    g_cache_shiftonshot             = nil;
    g_cache_fakeexpose              = nil;
    g_cache_fakeexpose_type         = nil;
    g_cache_antiresolver            = nil;
end );

callbacks.Register( "Unload", "AntiAimSystemRebuildOnUnload", function( )
    gui_Reference( "Ragebot", "Anti-Aim", "Base Direction" ):SetInvisible( false );
    gui_Reference( "Ragebot", "Anti-Aim", "Left Direction" ):SetInvisible( false );
    gui_Reference( "Ragebot", "Anti-Aim", "Right Direction" ):SetInvisible( false );
    gui_Reference( "Ragebot", "Anti-Aim", "Extra" ):SetInvisible( false );
    gui_Reference( "Ragebot", "Anti-Aim", "Advanced" ):SetInvisible( false );
    gui_Reference( "Ragebot", "Anti-Aim", "Condition" ):SetInvisible( false );
end );
