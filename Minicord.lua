------------------------------------------Credits-------------------------------------------
--				Minicord made by GLadiator
--it was originally a script "DT Changer" by Intranets, but it has almost completely changed
------------------------------------------Credits-------------------------------------------

------------------------------------------------------------------------------------------------------
local function time_to_ticks(a)
    return 
    math.floor(1 + a / globals.TickInterval())
end
local function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
local sv_maxusrcmdprocessticks = gui.Reference('Misc', 'General', 'Server', 'sv_maxusrcmdprocessticks')
local Fakeduck = gui.Reference('Ragebot', 'Anti-Aim', 'Extra', 'Fake Duck')
local AutosniperHitchance = 'rbot.accuracy.weapon.asniper.hitchance'
local AutosniperDTHitchance = 'rbot.accuracy.weapon.asniper.doublefirehc'
local AutoPeek = gui.Reference('Ragebot', 'Accuracy', 'Movement', 'Auto Peek Key')
------------------------------------------------------------------------------------------------------
--local font = draw.CreateFont('Andre V', 17)
--draw.SetFont(font)
--local x, y = draw.GetScreenSize()
--local w, h = draw.GetTextSize('16 TICKS')
--local DrawingOverRapidfireX = toint(x / 2 - (w / 2))
--local DrawingOverRapidfireY = toint(y / 1.073 - (h / 2))

local Curtime = globals.CurTime()
local State = true
------------------------------------------------------------------------------------------------------
local MinicordTab = gui.Tab(gui.Reference('Ragebot'), 'minicord.tab', 'Minicord')
local MinicordGroupboxRagebotDTFD = gui.Groupbox(MinicordTab, 'Ragebot | General', 16, 16, 296, 200)
local MinicordGroupboxRagebotFL = gui.Groupbox(MinicordTab, 'Ragebot | Fakelags', 328, 16, 296, 200)
local MinicordGroupboxRagebotAutoNoscope = gui.Groupbox(MinicordTab, 'Ragebot | Autosniper noscope/scope hitchance', 328, 220, 296, 200)
local MinicordGroupboxMisc = gui.Groupbox(MinicordTab, 'Misc', 16, 458, 296, 200)
local MinicordGroupboxVisuals = gui.Groupbox(MinicordTab, 'Visuals', 328, 530, 296, 200)
------------------------------------------------------------------------------------------------------

local doublefire_mode = gui.Combobox(MinicordGroupboxRagebotDTFD, 'minicord.rbot.doublefire.mode', 'Double fire mode', 'Standard', 'Shifting on peek');
local doublefire_bind = gui.Checkbox(MinicordGroupboxRagebotDTFD, 'minicord.rbot.doublefire.forcekey', 'Double fire bind', false);
local doublefire_bind_desc = gui.Text(MinicordGroupboxRagebotDTFD, 'Be sure to bind double fire so you can full disable double fire when standard mode, or force standard mode when using shifting mode.')
local doublefire_combo = gui.Combobox(MinicordGroupboxRagebotDTFD, 'minicord.rbot.doublefire.speed', 'Double fire speed', 'Automatic',
						'Slow (for ping in tab 80+)', 'Delayed (for ping in tab 50 - 79)', 
						'Slightly delayed (stable, for ping in tab 11 - 49)', 'Standard (for ping in tab 1 - 29)', 
						'Accelerated (unstable, for ping in tab 1 - 10)', '[VALVE] Slightly delayed (for ping in tab 80+)', 
						'[VALVE] Standard (stable, for ping in tab 21 - 79)', '[VALVE] Accelerated (unstable, for ping 1 - 20)', 'Use the "Maximum process ticks" value');
						

local fakeduck_combo = gui.Combobox(MinicordGroupboxRagebotDTFD, 'minicord.rbot.fakeduck.speed', 'Fakeduck type', 'Off',
						'Elevated (14 ticks)', 'Variable-elevated (15 ticks)', 
						'Standard (16 ticks)', 'Variable-reduced (maybe unstable, 18 ticks)', 
						'Reduced (unstable, 19 ticks)', '[VALVE] Standard(p)', 'Use the "Maximum process ticks" value');
						
local maxprocessticks_combo = gui.Combobox(MinicordGroupboxRagebotDTFD, 'minicord.rbot.sv_maxusrcmdprocessticks_combo', 'sv_maxusrcmdprocessticks', 'Standard', 'Valve servers', 'Custom');
local maxprocessticks_slider = gui.Slider(MinicordGroupboxRagebotDTFD, 'minicord.rbot.sv_maxusrcmdprocessticks_slider', 'Maximum process ticks adjuster', 16, 3, 61);

local fakelags_type = gui.Combobox(MinicordGroupboxRagebotFL, 'minicord.rbot.fakelags.type', 'Fakelags mode', 'Automatic', 'Static', 'Jitter');
local fakelags_factor = gui.Slider(MinicordGroupboxRagebotFL, 'minicord.rbot.fakelags.factor', 'Fakelags factor', 16, 3, 61);
																								
local revolver_check = gui.Checkbox(MinicordGroupboxRagebotFL, 'minicord.rbot.revolver', 'Limiting on Revolver R8', false);

local nonescopehc_check = gui.Checkbox(MinicordGroupboxRagebotAutoNoscope, 'minicord.rbot.noscopehc.check', 'Enable', true);
local nonescopehc_scope = gui.Slider(MinicordGroupboxRagebotAutoNoscope, 'minicord.rbot.noscopehc.scopevalue', 'Scope hitchance', gui.GetValue(AutosniperHitchance), 0, 100);
local nonescopehc_dt_scope = gui.Slider(MinicordGroupboxRagebotAutoNoscope, 'minicord.rbot.noscopehc.scopefdvalue', 'Scope double fire hitchance', gui.GetValue(AutosniperDTHitchance), 0, 100);
local nonescopehc_regular = gui.Slider(MinicordGroupboxRagebotAutoNoscope, 'minicord.rbot.noscopehc.noscopevalue', 'Noscope hitchance', gui.GetValue(AutosniperHitchance) / 2.5, 0, 100);
local nonescopehc_dt_regular = gui.Slider(MinicordGroupboxRagebotAutoNoscope, 'minicord.rbot.noscopehc.noscopefdvalue', 'Noscope double fire hitchance', gui.GetValue(AutosniperDTHitchance) / 5, 0, 100);

local legshaking_check = gui.Checkbox(MinicordGroupboxMisc, 'minicord.other.legbreaker.checkbox', 'Legshaking', false);
local legshaking_combo = gui.Combobox(MinicordGroupboxMisc, 'minicord.other.legbreaker.combo', 'Legshaking speed', 'Maximum speed', 'Fast', 'Normal', 'Slow', 'Very slow');

local dt_on_autopeek = gui.Checkbox(MinicordGroupboxMisc, 'minicord.other.dtautopeek', 'Always use double fire with autopeek', false);
local DtOnPeekSettings = gui.Multibox(MinicordGroupboxMisc, 'Autopeek settings');
local dt_on_autopeek_pingspike = gui.Checkbox(DtOnPeekSettings, 'minicord.other.dtautopeek.pingspike', 'Use fakelatency (200)', false);
local dt_on_autopeek_freestanding = gui.Checkbox(DtOnPeekSettings, 'minicord.other.dtautopeek.freestanding', 'Use freestanding', false);
local dt_on_autopeek_16ticks = gui.Checkbox(DtOnPeekSettings, 'minicord.other.dtautopeek.16ticks', 'Use force 16 ticks', false);

local ticks_draw_check = gui.Checkbox(MinicordGroupboxVisuals, 'minicord.draw.check', 'Draw ticks on screen', false);
local ticks_draw_circle = gui.Checkbox(MinicordGroupboxVisuals, 'minicord.draw.circle', 'Draw choke indicator on the crosshair', false);
local ticks_draw_color = gui.ColorPicker(MinicordGroupboxVisuals, 'minicord.draw.color', 'Draw color', 0, 220, 83, 255);
--local ticks_draw_x = gui.Slider(MinicordGroupboxVisuals, 'minicord.draw.x', 'Draw width', DrawingOverRapidfireX, 0, x); --927
--local ticks_draw_y = gui.Slider(MinicordGroupboxVisuals, 'minicord.draw.y', 'Draw height', DrawingOverRapidfireY, 0, y); --1002

local aspect_ratio = gui.Slider(MinicordGroupboxVisuals, "minicord.other.aspectratio", "Aspect ratio", 100, 75, 160)
local night_mode = gui.Slider(MinicordGroupboxVisuals, 'minicord.other.exposure.slider', 'World exposure', 100, 1, 100);

------------------------------------------------------------------------------------------------------
--local ref_maxprocessticks_slider = gui.Reference( "Ragebot", "Minicord", "Ragebot | Double fire and Fakeduck", "Maximum process ticks adjuster")
--local ref_fakelags_factor = gui.Reference("Ragebot", "Minicord", "Ragebot | Fakelags", "Fakelags factor")
--local ref_nonescopehc_scope = gui.Reference( "Ragebot", "Minicord", "Ragebot | Autosniper noscope/scope hitchance", "Scope hitchance")
--local ref_nonescopehc_dt_scope = gui.Reference( "Ragebot", "Minicord", "Ragebot | Autosniper noscope/scope hitchance", "Scope double fire hitchance")
--local ref_nonescopehc_regular = gui.Reference( "Ragebot", "Minicord", "Ragebot | Autosniper noscope/scope hitchance", "Noscope hitchance")
--local ref_nonescopehc_dt_regular = gui.Reference( "Ragebot", "Minicord", "Ragebot | Autosniper noscope/scope hitchance", "Noscope double fire hitchance")
--local ref_legshaking_combo = gui.Reference( "Ragebot", "Minicord", "Misc", "Legshaking speed")
--local ref_ticks_draw_color = gui.Reference( "Ragebot", "Minicord", "Visuals", "Draw color")
--local ref_ticks_draw_x = gui.Reference( "Ragebot", "Minicord", "Visuals", "Draw width")
--local ref_ticks_draw_y = gui.Reference( "Ragebot", "Minicord", "Visuals", "Draw height")
------------------------------------------------------------------------------------------------------
doublefire_mode:SetDescription('Select the desired double fire mode.')
nonescopehc_check:SetDescription('Disable is not available at this time.')
dt_on_autopeek_16ticks:SetDescription('Currently unavailable.')
------------------------------------------------------------------------------------------------------

--Main
local function handlemain()
	if maxprocessticks_combo:GetValue() == 0 then
		sv_maxusrcmdprocessticks:SetValue(16)
		maxprocessticks_slider:SetDisabled(true)
	elseif maxprocessticks_combo:GetValue() == 1 then
		sv_maxusrcmdprocessticks:SetValue(6)
		maxprocessticks_slider:SetDisabled(true)
	elseif maxprocessticks_combo:GetValue() == 2 then
		sv_maxusrcmdprocessticks:SetValue(maxprocessticks_slider:GetValue())
		maxprocessticks_slider:SetDisabled(false)
	end
	
	if doublefire_combo:GetValue() == 9 then
		maxprocessticks_slider:SetDisabled(false)
	end
	
	if fakeduck_combo:GetValue() == 7 then
		maxprocessticks_slider:SetDisabled(false)
	end
	
	if fakelags_type:GetValue() == 0 then
		fakelags_factor:SetDisabled(true)
	else
		fakelags_factor:SetDisabled(false)
	end
	
	if not nonescopehc_check:GetValue() then
		nonescopehc_scope:SetDisabled(true)
		nonescopehc_dt_scope:SetDisabled(true)
		nonescopehc_regular:SetDisabled(true)
		nonescopehc_dt_regular:SetDisabled(true)
	else
		nonescopehc_scope:SetDisabled(false)
		nonescopehc_dt_scope:SetDisabled(false)
		nonescopehc_regular:SetDisabled(false)
		nonescopehc_dt_regular:SetDisabled(false)
	end
	
	if not legshaking_check:GetValue() then
		legshaking_combo:SetDisabled(true)
	else
		legshaking_combo:SetDisabled(false)
	end
	
	if not dt_on_autopeek:GetValue() then
		dt_on_autopeek_16ticks:SetDisabled(true)
		dt_on_autopeek_16ticks:SetValue(false)
	else
		dt_on_autopeek_16ticks:SetDisabled(false)
	end
	
	if ticks_draw_check:GetValue() or ticks_draw_circle:GetValue() then
		ticks_draw_color:SetDisabled(false)
--		ticks_draw_x:SetDisabled(true)
--		ticks_draw_y:SetDisabled(true)
	else
		ticks_draw_color:SetDisabled(true)
--		ticks_draw_x:SetDisabled(false)
--		ticks_draw_y:SetDisabled(false)
	end
	
	dt_on_autopeek_16ticks:SetDisabled(true)
	nonescopehc_check:SetDisabled(true)
end
callbacks.Register('Draw', handlemain)

--------------------------------

--Double Fire bind
local function dtbind()
	if not engine.GetServerIP() then
		return
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	
	if doublefire_bind:GetValue() then
		gui.SetValue('rbot.accuracy.weapon.asniper.doublefire', 2)
		gui.SetValue('rbot.accuracy.weapon.scout.doublefire', 2)
		gui.SetValue('rbot.accuracy.weapon.sniper.doublefire', 2)
		gui.SetValue('rbot.accuracy.weapon.hpistol.doublefire', 2)
	else
		gui.SetValue('rbot.accuracy.weapon.asniper.doublefire', 0)
		gui.SetValue('rbot.accuracy.weapon.scout.doublefire', 0)
		gui.SetValue('rbot.accuracy.weapon.sniper.doublefire', 0)
		gui.SetValue('rbot.accuracy.weapon.hpistol.doublefire', 0)
	end
end
callbacks.Register('Draw', dtbind)

--------------------------------

--Double Fire speed
local function handledt()
	if not engine.GetServerIP() then
		return
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	
	local df_speed = {13, 14, 15, 16, 17, 5, 6, 7, maxprocessticks_slider:GetValue()}
	local ping = entities.GetPlayerResources():GetPropInt("m_iPing", entities.GetLocalPlayer():GetIndex())
	
	if gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2
	or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2
	or gui.GetValue('rbot.accuracy.weapon.scout.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2
	or gui.GetValue('rbot.accuracy.weapon.sniper.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2
	or gui.GetValue('rbot.accuracy.weapon.hpistol.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2 then
		if entities.GetLocalPlayer():GetWeaponID() == 38 or entities.GetLocalPlayer():GetWeaponID() == 11 
		or entities.GetLocalPlayer():GetWeaponID() == 40 or entities.GetLocalPlayer():GetWeaponID() == 9 
		or entities.GetLocalPlayer():GetWeaponID() == 1 then
			if doublefire_combo:GetValue() == 0 then
				if maxprocessticks_combo:GetValue() == 0 then
					if ping <= 5 then
						sv_maxusrcmdprocessticks:SetValue(17)
					elseif ping <= 20 then
						sv_maxusrcmdprocessticks:SetValue(16)
					elseif ping <= 50 then
						sv_maxusrcmdprocessticks:SetValue(15)
					elseif ping <= 80 then
						sv_maxusrcmdprocessticks:SetValue(14)
					elseif ping > 80 then
						sv_maxusrcmdprocessticks:SetValue(13)
					end
				elseif maxprocessticks_combo:GetValue() == 1 then
					if ping <= 15 then
						sv_maxusrcmdprocessticks:SetValue(7)
					elseif ping >= 16 then
						sv_maxusrcmdprocessticks:SetValue(6)
					elseif ping > 80 then
						sv_maxusrcmdprocessticks:SetValue(5)
					end
				end	
			elseif doublefire_combo:GetValue() >= 1 then
				sv_maxusrcmdprocessticks:SetValue(df_speed[doublefire_combo:GetValue()])
			end
		else
			return
		end
	else
		return
	end
end
callbacks.Register('Draw', handledt)

--------------------------------

--Fakeduck speed
local function fakeduck_speed()
	if fakeduck_combo:GetValue() == 0 then
		return
	end
	if not engine.GetServerIP() then
		return
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	
	local fd_speed = {14, 15, 16, 18, 19, 7, maxprocessticks_slider:GetValue()}
	
	if input.IsButtonDown(Fakeduck:GetValue()) then 
		if fakeduck_combo:GetValue() >= 1 then
			sv_maxusrcmdprocessticks:SetValue(fd_speed[fakeduck_combo:GetValue()])
		end
	else
		return
	end
end
callbacks.Register('Draw', fakeduck_speed)

--------------------------------

local function fakelags()
	if not engine.GetServerIP() then
		return	
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	
	gui.SetValue('misc.fakelag.enable', 1)
	gui.SetValue('misc.fakelag.type', 0)
	
	if fakelags_type:GetValue() == 0 then
		if maxprocessticks_combo:GetValue() == 0 then
			gui.SetValue('misc.fakelag.factor', 16)
		elseif maxprocessticks_combo:GetValue() == 1 then
			gui.SetValue('misc.fakelag.factor', 6)
		elseif maxprocessticks_combo:GetValue() == 2 then
			gui.SetValue('misc.fakelag.factor', maxprocessticks_slider:GetValue())
		end
	elseif fakelags_type:GetValue() == 1 then
		gui.SetValue('misc.fakelag.factor', fakelags_factor:GetValue())
	elseif fakelags_type:GetValue() == 2 then
		local jitter = math.random(fakelags_factor:GetValue() - 1, fakelags_factor:GetValue())
		gui.SetValue('misc.fakelag.factor', jitter)
	end
end
callbacks.Register('Draw', fakelags)

--------------------------------

--New IMBA
--Based on Chicken4676 and John.k scripts (https://aimware.net/forum/thread/148350, https://aimware.net/forum/thread/101070)
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
    local fps = 4
    for i, player in pairs(players) do
        if player:GetTeamNumber() ~= entities.GetLocalPlayer():GetTeamNumber() and player:IsPlayer() and entities_check() ~= nil and player:IsAlive() then			
            for i = 0, 4 do
                for x = 0, fps do
                    local HitboxPos = player:GetHitboxPosition(i)

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
                    if c == 0 then
                        is_vis = true
                        break
                    end
                end
            end
        end
    end
    return is_vis
end
local function defensive_dt_part1()
	if not engine.GetServerIP() then
		return
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	if input.IsButtonDown('Space') then
		return
	end

	if doublefire_mode:GetValue() == 0 then
		if entities.GetLocalPlayer():GetWeaponID() == 38
		or entities.GetLocalPlayer():GetWeaponID() == 11
		or entities.GetLocalPlayer():GetWeaponID() == 1 then 
			gui.SetValue("rbot.antiaim.condition.shiftonshot", 0)
		end
		return
	end
	if doublefire_bind:GetValue() then
		if entities.GetLocalPlayer():GetWeaponID() == 38
		or entities.GetLocalPlayer():GetWeaponID() == 11
		or entities.GetLocalPlayer():GetWeaponID() == 1 then 
			gui.SetValue("rbot.antiaim.condition.shiftonshot", 0)
		end
		return
	end 
	
	if entities.GetLocalPlayer():GetWeaponID() == 38
	or entities.GetLocalPlayer():GetWeaponID() == 11
	or entities.GetLocalPlayer():GetWeaponID() == 1 then 
		gui.SetValue('misc.fakelag.factor', 6)
	
		local Player, LocalPlayer = entities_check()
--		if LocalPlayer then
--			local prediction = predict_velocity(LocalPlayer, 0.550)
--			local my_pos = LocalPlayer:GetAbsOrigin()
			
--			local x,y,z = vector.Add(
--				{my_pos.x, my_pos.y, my_pos.z},
--				{prediction[1], prediction[2], prediction[3]}
--			)
		
--			local LocalPlayer_predicted_pos = Vector3(x,y,z)
--			LocalPlayer_predicted_pos.z = LocalPlayer_predicted_pos.z + LocalPlayer:GetPropVector("localdata", "m_vecViewOffset[0]").z
		
--			if is_vis(LocalPlayer_predicted_pos) then
--				gui.SetValue("rbot.antiaim.condition.shiftonshot", 0)
--			else
--				gui.SetValue("rbot.antiaim.condition.shiftonshot",1)
--			end
--		end
		if LocalPlayer then
			local prediction = predict_velocity(LocalPlayer, 0.225) -- 0.225/0.250/0.300
			local my_pos = LocalPlayer:GetAbsOrigin()
			
			local x,y,z = vector.Add(
				{my_pos.x, my_pos.y, my_pos.z},
				{prediction[1], prediction[2], prediction[3]}
			)
		
			local LocalPlayer_predicted_pos = Vector3(x,y,z)
			LocalPlayer_predicted_pos.z = LocalPlayer_predicted_pos.z + LocalPlayer:GetPropVector("localdata", "m_vecViewOffset[0]").z
		
			if is_vis(LocalPlayer_predicted_pos) then
				gui.SetValue("rbot.accuracy.weapon.asniper.doublefire", 1)
				gui.SetValue("rbot.accuracy.weapon.hpistol.doublefire", 1)
			else
				gui.SetValue("rbot.accuracy.weapon.asniper.doublefire", 0)
				gui.SetValue("rbot.accuracy.weapon.hpistol.doublefire", 0)
			end
		end
	end
end
callbacks.Register('Draw', defensive_dt_part1)

--------------------------------

--Disable fakelags on Revolver
local function revolver()
	if not revolver_check:GetValue() then
		return
	end
	if not engine.GetServerIP() then
		return
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	
	if entities.GetLocalPlayer():GetWeaponID() == 64 then
		if input.IsButtonDown(Fakeduck:GetValue()) then
			gui.SetValue('misc.fakelag.factor', 14)
		else
			gui.SetValue('misc.fakelag.factor', 13)
		end
	else
		return
	end
end
callbacks.Register('Draw', revolver)

--------------------------------

--Nonscope hitchance
local function nonescopehc()
	if not nonescopehc_check:GetValue() then
		return
	end
	if not engine.GetServerIP() then
		return
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end

	Scoped = entities.GetLocalPlayer():GetPropBool("m_bIsScoped");
	
	if entities.GetLocalPlayer():GetWeaponID() == 38
	or entities.GetLocalPlayer():GetWeaponID() == 11 then
		gui.SetValue('rbot.aim.automation.scope', 0)
		if Scoped then
			gui.SetValue(AutosniperHitchance, nonescopehc_scope:GetValue())
			if doublefire_mode:GetValue() == 1 then
				if not doublefire_bind:GetValue() then
					gui.SetValue(AutosniperDTHitchance, nonescopehc_dt_scope:GetValue() / 2)
				else
					gui.SetValue(AutosniperDTHitchance, nonescopehc_dt_scope:GetValue())
				end
			else
				gui.SetValue(AutosniperDTHitchance, nonescopehc_dt_scope:GetValue())
			end
		else
			gui.SetValue(AutosniperHitchance, nonescopehc_regular:GetValue())
			if doublefire_mode:GetValue() == 1 then
				if not doublefire_bind:GetValue() then
					gui.SetValue(AutosniperDTHitchance, nonescopehc_dt_regular:GetValue() / 1.5)
				else
					gui.SetValue(AutosniperDTHitchance, nonescopehc_dt_regular:GetValue())
				end
			else
				gui.SetValue(AutosniperDTHitchance, nonescopehc_dt_regular:GetValue())
			end
		end
	else
		gui.SetValue('rbot.aim.automation.scope', 2)
	end
end
callbacks.Register('Draw', nonescopehc)

--------------------------------

--Pasted legshaking
local function legshaking()
	if legshaking_check:GetValue() then
		if entities.GetLocalPlayer() then
			entities.GetLocalPlayer():SetPropInt(0, "m_flPoseParameter")
			if globals.CurTime() > Curtime then
				State = not State
				if legshaking_combo:GetValue() <= 5 then
					Curtime = globals.CurTime() + 0.03 + legshaking_combo:GetValue() / 100
				end
				entities.GetLocalPlayer():SetPropInt(1, "m_flPoseParameter")
			end
			gui.SetValue("misc.slidewalk", State)
		end
	end
end
callbacks.Register('Draw', 'legshaking', legshaking);	

--------------------------------	

--Always DT on AutoPeek
--Semi-pasted from sestain's script.
local function SavedValues()
	ScarDtValue 				= gui.GetValue('rbot.accuracy.weapon.asniper.doublefire')
	ScoutDtValue 				= gui.GetValue('rbot.accuracy.weapon.scout.doublefire')
	AwpDtValue 					= gui.GetValue('rbot.accuracy.weapon.sniper.doublefire')
	DeagleDtValue 				= gui.GetValue('rbot.accuracy.weapon.hpistol.doublefire')
	
	FakelatencyEnableValue 		= gui.GetValue('misc.fakelatency.enable')
	FakelatencyAmountValue 		= gui.GetValue('misc.fakelatency.amount')
	FakelatencyKeyValue			= gui.GetValue('misc.fakelatency.key')
	
	FreestandingLeftValue  		= gui.GetValue('rbot.antiaim.left')
	FreestandingRightValue		= gui.GetValue('rbot.antiaim.right')
	FreestandingAtedgesValue 	= gui.GetValue('rbot.antiaim.advanced.autodir.edges')
	FreestandingAttargetsValue 	= gui.GetValue('rbot.antiaim.advanced.autodir.targets')
end
local dt_autopeek_state = false
local function dt_autopeek()
	if not engine.GetServerIP() then
		return
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	
	if entities.GetLocalPlayer():GetWeaponID() == 38 
	or entities.GetLocalPlayer():GetWeaponID() == 11
	or entities.GetLocalPlayer():GetWeaponID() == 40
	or entities.GetLocalPlayer():GetWeaponID() == 9
	or entities.GetLocalPlayer():GetWeaponID() == 1 then
		if input.IsButtonDown(AutoPeek:GetValue()) then 
			if dt_on_autopeek:GetValue() then
				gui.SetValue('rbot.accuracy.weapon.asniper.doublefire', 2)
				gui.SetValue('rbot.accuracy.weapon.scout.doublefire', 2)
				gui.SetValue('rbot.accuracy.weapon.sniper.doublefire', 2)
				gui.SetValue('rbot.accuracy.weapon.hpistol.doublefire', 2)
			end
			if dt_on_autopeek_pingspike:GetValue() then
				gui.SetValue('misc.fakelatency.enable', 1)
				gui.SetValue('misc.fakelatency.amount', 200)
				gui.SetValue('misc.fakelatency.key', 'None')
			end
			if dt_on_autopeek_freestanding:GetValue() then
				gui.SetValue('rbot.antiaim.left', 120)
				gui.SetValue('rbot.antiaim.right', -120)
				gui.SetValue('rbot.antiaim.advanced.autodir.edges', 1)
				gui.SetValue('rbot.antiaim.advanced.autodir.targets', 0)
			end
			if dt_on_autopeek_16ticks:GetValue() and dt_on_autopeek:GetValue() then
				sv_maxusrcmdprocessticks:SetValue(16)
			end
			
			dt_autopeek_state = true
		end
		if input.IsButtonReleased(AutoPeek:GetValue()) then 
			if dt_on_autopeek:GetValue() then
				gui.SetValue('rbot.accuracy.weapon.asniper.doublefire', ScarDtValue)
				gui.SetValue('rbot.accuracy.weapon.scout.doublefire', ScoutDtValue)
				gui.SetValue('rbot.accuracy.weapon.sniper.doublefire', AwpDtValue)
				gui.SetValue('rbot.accuracy.weapon.hpistol.doublefire', DeagleDtValue)
			end
			if dt_on_autopeek_pingspike:GetValue() then
				gui.SetValue('misc.fakelatency.enable', FakelatencyEnableValue)
				gui.SetValue('misc.fakelatency.amount', FakelatencyAmountValue)
				gui.SetValue('misc.fakelatency.key', FakelatencyKeyValue)
			end
			if dt_on_autopeek_freestanding:GetValue() then
				gui.SetValue('rbot.antiaim.left', FreestandingLeftValue)
				gui.SetValue('rbot.antiaim.right', FreestandingRightValue)
				gui.SetValue('rbot.antiaim.advanced.autodir.edges', FreestandingAtedgesValue)
				gui.SetValue('rbot.antiaim.advanced.autodir.targets', FreestandingAttargetsValue)
			end
			if dt_on_autopeek_16ticks:GetValue() and dt_on_autopeek:GetValue() then
				return
			end
				
			dt_autopeek_state = false
		end
	end
	
	if not dt_autopeek_state then
		SavedValues()
	end
end
callbacks.Register('Draw', 'dt_autopeek', dt_autopeek);	
	
--------------------------------

--Pasted Aspect Ratio
local Aspect_Ratio_table = {};
local function gcd(a, b)
	while a ~= 0 do
		a, b = math.fmod(b, a), a
	end   
	return b
end
local function Set_Aspect_Ratio(aspect_ratio_multiplier)
	local screen_width, screen_height = draw.GetScreenSize()
	local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height
    client.SetConVar( "r_aspectratio", tonumber(aspectratio_value), true)
end
local function Aspect_Ratio()
	local screen_width, screen_height = draw.GetScreenSize()
	for i = 1, 200 do
		local i2 = 2 - i * 0.01
		local divisor = gcd(screen_width * i2, screen_height)
		if screen_width * i2 / divisor < 100 or i2 == 1 then
			Aspect_Ratio_table[i] = screen_width * i2 / divisor .. ":" .. screen_height / divisor
		end
	end
	local aspect_ratio = 2 - aspect_ratio:GetValue()*0.01
	Set_Aspect_Ratio(aspect_ratio)
end
callbacks.Register('Draw', "Aspect Ratio", Aspect_Ratio)

--------------------------------

--Pasted Night Mode
local function Night_Mode()
	local controller = entities.FindByClass("CEnvTonemapController")[1];
	if(controller) then
		controller:SetProp("m_bUseCustomAutoExposureMin", 1);
		controller:SetProp("m_bUseCustomAutoExposureMax", 1);

		local value = night_mode:GetValue()
		controller:SetProp("m_flCustomAutoExposureMin", value / 100);
		controller:SetProp("m_flCustomAutoExposureMax", value / 100);
	end
end
callbacks.Register('Draw', "Night Mode", Night_Mode)

--------------------------------

--Drawing ticks
local font = draw.CreateFont('Andre V', 17)
local function draw_ticks()
	if not engine.GetServerIP() then
		return
	end
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	
	draw.SetFont(font)
	local x, y = draw.GetScreenSize()
	local w, h = draw.GetTextSize('16 TICKS')
	local DrawingOverRapidfireX = toint(x / 2 - (w / 2))
	local DrawingOverRapidfireY = toint(y / 1.073 - (h / 2))

	if ticks_draw_check:GetValue() then		
		if gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2
		or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2
		or gui.GetValue('rbot.accuracy.weapon.scout.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2
		or gui.GetValue('rbot.accuracy.weapon.sniper.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2
		or gui.GetValue('rbot.accuracy.weapon.hpistol.doublefire') == 1 or gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2 then
			if entities.GetLocalPlayer():GetWeaponID() == 38 or entities.GetLocalPlayer():GetWeaponID() == 11 
			or entities.GetLocalPlayer():GetWeaponID() == 40 or entities.GetLocalPlayer():GetWeaponID() == 9 
			or entities.GetLocalPlayer():GetWeaponID() == 1 then
				draw.Color(ticks_draw_color:GetValue())
				draw.TextShadow(DrawingOverRapidfireX, DrawingOverRapidfireY, sv_maxusrcmdprocessticks:GetValue() .. ' TICKS', ticks_draw_color)
			end
		end
	end
	if ticks_draw_circle:GetValue() then
		local choke = time_to_ticks(globals.CurTime() - entities.GetLocalPlayer():GetPropFloat( "m_flSimulationTime")) + 2
		draw.Color(ticks_draw_color:GetValue())
		draw.OutlinedCircle(toint(x / 2), toint(y / 2), choke)
	end
end
callbacks.Register('Draw', 'draw_ticks', draw_ticks)
