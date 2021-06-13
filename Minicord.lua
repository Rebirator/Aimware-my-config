------------------------------------------Credits-------------------------------------------
--								Minicord made by GLadiator
--it was originally a script "DT Changer" by Intranets, but it has almost completely changed
------------------------------------------Credits-------------------------------------------

------------------------------------------------------------------------------------------------------
local sv_maxusrcmdprocessticks = gui.Reference('Misc', 'General', 'Server', 'sv_maxusrcmdprocessticks')
local fakeduck = gui.Reference('Ragebot', 'Anti-Aim', 'Extra', 'Fake Duck')
local AutosniperHitchance = 'rbot.accuracy.weapon.asniper.hitchance'
local AutosniperDTHitchance = 'rbot.accuracy.weapon.asniper.doublefirehc'
local x, y = draw.GetScreenSize()
local DrawingOverRapidfireX = x / 2.072
local DrawingOverRapidfireY = y / 1.078
local curtime = globals.CurTime()
local state = true
------------------------------------------------------------------------------------------------------

local MinicordTab = gui.Tab(gui.Reference('Ragebot'), 'minicord.tab', 'Minicord')
local MinicordGroupboxRagebot = gui.Groupbox(MinicordTab, 'Ragebot', 16, 16, 296, 200)
local MinicordGroupboxMisc = gui.Groupbox(MinicordTab, 'Misc', 328, 16, 296, 200)
local MinicordGroupboxVisuals = gui.Groupbox(MinicordTab, 'Visuals', 328, 172, 296, 200)

------------------------------------------------------------------------------------------------------
local maxprocessticks_combo = gui.Combobox(MinicordGroupboxRagebot, 'minicord.rbot.sv_maxusrcmdprocessticks_combo', 'sv_maxusrcmdprocessticks', 'Standard', 'Valve servers', 'Custom');
local maxprocessticks_slider = gui.Slider(MinicordGroupboxRagebot, 'minicord.rbot.sv_maxusrcmdprocessticks_slider', 'Maximum process ticks adjuster', 16, 3, 61);

local doublefire_combo = gui.Combobox(MinicordGroupboxRagebot, 'minicord.rbot.doublefire.speed', 'Double fire speed', 'Off',
						'Slow (for ping in tab 80+)', 'Delayed (for ping in tab 50 - 79)', 
						'Slightly delayed (stable, for ping in tab 30 - 49)', 'Standard (for ping in tab 16 - 29)', 
						'Accelerated (unstable, for ping in tab 6 - 15)', 'Maximum speed (unstable, for ping in tab 1 - 5)', 
						'[VALVE] Slightly delayed (for ping in tab 80+)', '[VALVE] Standard (stable, for ping in tab 21 - 79)', 
						'[VALVE] Accelerated (unstable, for ping 1 - 20)', 'Use the "Maximum process ticks" value');

local fakeduck_combo = gui.Combobox(MinicordGroupboxRagebot, 'minicord.rbot.fakeduck.speed', 'Fakeduck speed', 'Off',
						'Elevated (14 ticks)', 'Variable-elevated (15 ticks)', 
						'Standard (16 ticks)', 'Visually unchanged (17 ticks)', 
						'Variable-reduced (unstable, 18 ticks)', 'Reduced (unstable, 19 ticks)', '[VALVE] Standard(p)');
																								
local revolver_check = gui.Checkbox(MinicordGroupboxRagebot, 'minicord.rbot.revolver', 'Disable fakelags on Revolver R8', false);

local nonescopehc_check = gui.Checkbox(MinicordGroupboxRagebot, 'minicord.rbot.nonscopehc.check', 'Enable autosniper none scope hitchance', false);
local nonescopehc_scope = gui.Slider(MinicordGroupboxRagebot, 'minicord.rbot.nonscopehc.regularvalue', 'Scope hitchance', 50, 0, 100);
local nonescopehc_dt_scope = gui.Slider(MinicordGroupboxRagebot, 'minicord.rbot.nonscopehc.regularvalue', 'Scope DF hitchance', 0, 0, 100);
local nonescopehc_regular = gui.Slider(MinicordGroupboxRagebot, 'minicord.rbot.nonscopehc.regularvalue', 'None scope hitchance', 50, 0, 100);
local nonescopehc_dt_regular = gui.Slider(MinicordGroupboxRagebot, 'minicord.rbot.nonscopehc.regularvalue', 'None scope DF hitchance', 0, 0, 100);

local legshaking_check = gui.Checkbox(MinicordGroupboxMisc, 'minicord.other.legbreaker.checkbox', 'Legshaking', false);
local legshaking_combo = gui.Combobox(MinicordGroupboxMisc, 'minicord.other.legbreaker.combo', 'Legshaking speed', 'Maximum speed', 'Fast', 'Normal', 'Slow', 'Very slow');

local ticks_draw_check = gui.Checkbox(MinicordGroupboxVisuals, 'minicord.draw.draw', 'Draw ticks on screen', false);
local ticks_draw_color = gui.ColorPicker(MinicordGroupboxVisuals, 'minicord.draw.color', 'Draw color', 0, 220, 83, 255);
local ticks_draw_x = gui.Slider(MinicordGroupboxVisuals, 'minicord.draw.x', 'Draw width', DrawingOverRapidfireX, 0, x); --927
local ticks_draw_y = gui.Slider(MinicordGroupboxVisuals, 'minicord.draw.y', 'Draw height', DrawingOverRapidfireY, 0, y); --1002

local aspect_ratio = gui.Slider(MinicordGroupboxVisuals, "minicord.other.aspectratio", "Aspect ratio", 100, 75, 160)
local night_mode = gui.Slider(MinicordGroupboxVisuals, 'minicord.other.exposure.slider', 'World exposure', 100, 1, 100);

local ref_maxprocessticks_slider = gui.Reference( "Ragebot", "Minicord", "Ragebot", "Maximum process ticks adjuster")
local ref_nonescopehc_scope = gui.Reference( "Ragebot", "Minicord", "Ragebot", "Scope hitchance")
local ref_nonescopehc_dt_scope = gui.Reference( "Ragebot", "Minicord", "Ragebot", "Scope DF hitchance")
local ref_nonescopehc_regular = gui.Reference( "Ragebot", "Minicord", "Ragebot", "None scope hitchance")
local ref_nonescopehc_dt_regular = gui.Reference( "Ragebot", "Minicord", "Ragebot", "None scope DF hitchance")
local ref_legshaking_combo = gui.Reference( "Ragebot", "Minicord", "Misc", "Legshaking speed")
local ref_ticks_draw_color = gui.Reference( "Ragebot", "Minicord", "Visuals", "Draw color")
local ref_ticks_draw_x = gui.Reference( "Ragebot", "Minicord", "Visuals", "Draw width")
local ref_ticks_draw_y = gui.Reference( "Ragebot", "Minicord", "Visuals", "Draw height")
------------------------------------------------------------------------------------------------------

--Main
local function handlemain()
	if maxprocessticks_combo:GetValue() == 0 then
		sv_maxusrcmdprocessticks:SetValue(16)
		ref_maxprocessticks_slider:SetDisabled(true)
	elseif maxprocessticks_combo:GetValue() == 1 then
		sv_maxusrcmdprocessticks:SetValue(6)
		ref_maxprocessticks_slider:SetDisabled(true)
	elseif maxprocessticks_combo:GetValue() == 2 then
		sv_maxusrcmdprocessticks:SetValue(maxprocessticks_slider:GetValue())
		ref_maxprocessticks_slider:SetDisabled(false)
	end
	
	if doublefire_combo:GetValue() == 10 then
		ref_maxprocessticks_slider:SetDisabled(false)
	end
	
	if not nonescopehc_check:GetValue() then
		ref_nonescopehc_scope:SetDisabled(true)
		ref_nonescopehc_dt_scope:SetDisabled(true)
		ref_nonescopehc_regular:SetDisabled(true)
		ref_nonescopehc_dt_regular:SetDisabled(true)
	else
		ref_nonescopehc_scope:SetDisabled(false)
		ref_nonescopehc_dt_scope:SetDisabled(false)
		ref_nonescopehc_regular:SetDisabled(false)
		ref_nonescopehc_dt_regular:SetDisabled(false)
	end
	
	if not legshaking_check:GetValue() then
		ref_legshaking_combo:SetDisabled(true)
	else
		ref_legshaking_combo:SetDisabled(false)
	end
	
	if not ticks_draw_check:GetValue() then
		ref_ticks_draw_color:SetDisabled(true)
		ref_ticks_draw_x:SetDisabled(true)
		ref_ticks_draw_y:SetDisabled(true)
	else
		ref_ticks_draw_color:SetDisabled(false)
		ref_ticks_draw_x:SetDisabled(false)
		ref_ticks_draw_y:SetDisabled(false)
	end
end
callbacks.Register('CreateMove', handlemain)

--------------------------------

--Double Fire speed
local function handledt()
	if doublefire_combo:GetValue() == 0 then
		return
	end
	
	local df_speed = {13, 14, 15, 16, 17, 18, 5, 6, 7, maxprocessticks_slider:GetValue()}
	
	if gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2 then
		if doublefire_combo:GetValue() >= 1 then
			sv_maxusrcmdprocessticks:SetValue(df_speed[doublefire_combo:GetValue()])
		end
	else
		return
	end
end
callbacks.Register('CreateMove', handledt)

--------------------------------

--Fakeduck speed
local function fakeduck_speed()
	if fakeduck_combo:GetValue() == 0 then
		return
	end
	
	local fd_speed = {14, 15, 16, 17, 18, 19, 7}
	
	if input.IsButtonDown(fakeduck:GetValue()) then 
		if fakeduck_combo:GetValue() <= 6 then
			sv_maxusrcmdprocessticks:SetValue(fd_speed[fakeduck_combo:GetValue()])
		end
	else
		return
	end
end
callbacks.Register('CreateMove', fakeduck_speed)

--------------------------------

--Limiting fakelag ticks on Revolver
local function revolver()
	if not revolver_check:GetValue() then
		return
	end
	
	if entities.GetLocalPlayer():GetWeaponID() == 64 then
		gui.SetValue('misc.fakelag.enable', false)
	else
		gui.SetValue('misc.fakelag.enable', true)
	end
end
callbacks.Register('CreateMove', revolver)

--------------------------------

--Nonscope hitchance
local function nonescopehc()
	if not nonescopehc_check:GetValue() then
		return
	end

	Scoped = entities.GetLocalPlayer():GetPropBool("m_bIsScoped");
	
	if entities.GetLocalPlayer():GetWeaponID() == 38 then
		gui.SetValue('rbot.aim.automation.scope', 0)
		if Scoped then
			gui.SetValue(AutosniperHitchance, nonescopehc_scope:GetValue())
			gui.SetValue(AutosniperDTHitchance, nonescopehc_dt_scope:GetValue())
		else
			gui.SetValue(AutosniperHitchance, nonescopehc_regular:GetValue())
			gui.SetValue(AutosniperDTHitchance, nonescopehc_dt_regular:GetValue())
		end
	else
		gui.SetValue('rbot.aim.automation.scope', 2)
	end
end
callbacks.Register('CreateMove', nonescopehc)

--------------------------------

--Pasted legshaking
local function legshaking()
	if legshaking_check:GetValue() then
		if entities.GetLocalPlayer() then
			entities.GetLocalPlayer():SetPropInt(0, "m_flPoseParameter")
			if globals.CurTime() > curtime then
				state = not state
				if legshaking_combo:GetValue() <= 5 then
					curtime = globals.CurTime() + 0.03 + legshaking_combo:GetValue() / 100
				end
				entities.GetLocalPlayer():SetPropInt(1, "m_flPoseParameter")
			end
			gui.SetValue("misc.slidewalk", state)
		end
	end
end
callbacks.Register('Draw', 'legshaking', legshaking);		
	
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
	if not entities.GetLocalPlayer():IsAlive() then
		return
	end
	
	if ticks_draw_check:GetValue() then
		if gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2 then
			draw.Color(ticks_draw_color:GetValue())
			draw.SetFont(font)
			draw.TextShadow(ticks_draw_x:GetValue(), ticks_draw_y:GetValue(), sv_maxusrcmdprocessticks:GetValue() .. ' TICKS', ticks_draw_color)
		end
		if not gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2 then
			return
		end
	end
end
callbacks.Register('Draw', 'draw_ticks', draw_ticks)