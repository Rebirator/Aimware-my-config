--Minicord made by GLadiator
--DT speed made by lntranets

---------------lntranets----------------
local dt = 'rbot.accuracy.weapon.asniper.doublefire'
local processticks = gui.Reference('Misc', 'General', 'Server', 'sv_maxusrcmdprocessticks')
local fakeduck = gui.Reference('Ragebot', 'Anti-Aim', 'Extra', 'Fake Duck')
local RagebotAccracyWeapon = gui.Reference('Ragebot', 'Accuracy', 'Weapon')
local RagebotAntiaimExtra = gui.Reference('Ragebot', 'Anti-Aim', 'Extra')
local fakelaglimit = 'misc.fakelag.factor'
local dthc = 'rbot.accuracy.weapon.asniper.doublefirehc'
local x, y = draw.GetScreenSize()
local slidewalk = 'misc.slidewalk'
local last = 0
local state = true
x = x * 0.5;
y = y * 0.5;
---------------lntranets----------------

------------------------------------------------------------------------------------------------------

local MinicordTab = gui.Tab(gui.Reference('Ragebot'), 'minicord.tab', 'Minicord')
local MinicordGroupboxDoublefire = gui.Groupbox(MinicordTab, 'Double Fire', 16, 16, 296, 200)
local MinicordGroupboxFakeduck = gui.Groupbox(MinicordTab, 'Fake Duck', 328, 16, 296, 200)
local MinicordGroupboxOther = gui.Groupbox(MinicordTab, 'Other', 16, 184, 296, 200)
local MinicordGroupboxDraw = gui.Groupbox(MinicordTab, 'Draw', 328, 172, 296, 200)

------------------------------------------------------------------------------------------------------
local dt_combo = gui.Combobox(MinicordGroupboxDoublefire, 'minicord.df.speed', 'Double Fire speed', 
																				'Slow (for ping in tab 80+)', 'Delayed (for ping in tab 50 - 79)', 
																				'Slightly delayed (for ping in tab 30 - 49)', 'Standard (for ping in tab 16 - 29)', 
																				'Accelerated (for ping in tab 6 - 15)', 'Maximum Speed (for ping in tab 1 - 5)', 
																				'[VALVE] Slightly delayed (for ping in tab 80+)', '[VALVE] Standard (for ping in tab 40 - 79)', 
																				'[VALVE] Accelerated (unstable, for ping 16 - 40)', 
																				'[VALVE] Maximum speed (very unstable, ping 1 - 15)', 'Custom (uses sv_maxusrcmdprocessticks slider)');
local dt_slider = gui.Slider(MinicordGroupboxDoublefire, 'minicord.df.slider', 'sv_maxusrcmdprocessticks', 16, 3, 61);
local fd_combo = gui.Combobox(MinicordGroupboxFakeduck, 'minicrod.fd.combo', 'Fakeduck ticks', 'Elevated (14 ticks)', 'Variable-elevated (15 ticks)', 
																								'Standard (16 ticks)', 'Visually unchanged (17 ticks)', 
																								'Variable-reduced (unstable, 18 ticks)', 'Reduced (unstable, 19 ticks)', '[VALVE] Standard(p)')
local r8_check = gui.Checkbox(MinicordGroupboxFakeduck, 'minicord.fd.r8', 'Limiting fakelag ticks on Revolver R8', false);
local lb_check = gui.Checkbox(MinicordGroupboxOther, 'minicord.other.legbreaker.checkbox', 'Ideal legshaking', false);
local lb_combo = gui.Combobox(MinicordGroupboxOther, 'minicord.other.legbreaker.combo', 'Legshaking speed', 'Very slow', 'Slow', 'Normal', 'Fast', 'Maximum speed', 'Custom');
local lb_slider = gui.Slider(MinicordGroupboxOther, 'minicord.other.legbreaker.slider', 'Legshaking speed adjuster', 0.10, 0.01, 1.00, 0.01);
local aspect_ratio = gui.Slider(MinicordGroupboxOther, "minicord.other.aspectratio", "Aspect Ratio", 100, 75, 160)
local night_mode = gui.Slider(MinicordGroupboxOther, 'minicord.other.exposure.slider', 'World exposure', 100, 1, 100);
local ticks_draw = gui.Checkbox(MinicordGroupboxDraw, 'minicord.draw.draw', 'Draw ticks', false);
local ticks_draw_color = gui.ColorPicker(MinicordGroupboxDraw, 'minicord.draw.color', 'Draw Color', 0, 220, 83, 255);
--local ticks_draw_font = gui.Editbox(MinicordGroupboxDraw, "minicord.draw.font", "Font")
--local ticks_draw_size = gui.Slider(MinicordGroupboxDraw, 'minicord.draw.size', 'Font size', 17, 1, 32);
local ticks_draw_y = gui.Slider(MinicordGroupboxDraw, 'minicord.draw.y', 'Draw X', 927, 0, 2560);
local ticks_draw_x = gui.Slider(MinicordGroupboxDraw, 'minicord.draw.x', 'Draw Y', 1002, 0, 2560);
------------------------------------------------------------------------------------------------------

--DoubleTap
local function handledt()
	if gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2 then
		if dt_combo:GetValue() == 0 then
			processticks:SetValue(13)
		elseif dt_combo:GetValue() == 1 then
			processticks:SetValue(14)
		elseif dt_combo:GetValue() == 2 then
			processticks:SetValue(15)
		elseif dt_combo:GetValue() == 3 then
			processticks:SetValue(16)
		elseif dt_combo:GetValue() == 4 then
			processticks:SetValue(17)
		elseif dt_combo:GetValue() == 5 then
			processticks:SetValue(18)
		elseif dt_combo:GetValue() == 6 then
			processticks:SetValue(5)
		elseif dt_combo:GetValue() == 7 then
			processticks:SetValue(6)
		elseif dt_combo:GetValue() == 8 then
			processticks:SetValue(7)
		elseif dt_combo:GetValue() == 9 then
			processticks:SetValue(8)
		elseif dt_combo:GetValue() == 10 then
			processticks:SetValue(dt_slider:GetValue())
		end
	elseif gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 0 then
		processticks:SetValue(dt_slider:GetValue())
		return
	end
end
callbacks.Register('CreateMove', handledt)

--------------------------------

--Drawing ticks
--ticks_draw_font:SetValue('Andre V')
local font = draw.CreateFont('Andre V', 17)
local function ontick()
	if ticks_draw:GetValue() then
		if gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2 then
			draw.Color(ticks_draw_color:GetValue())
			draw.SetFont(font)
			draw.TextShadow(ticks_draw_y:GetValue(), ticks_draw_x:GetValue(), processticks:GetValue() .. ' TICKS', ticks_draw_color)
		end
		if not gui.GetValue('rbot.accuracy.weapon.asniper.doublefire') == 2 then
			return
		end
	end
end
callbacks.Register('Draw', 'ontick', ontick)

--------------------------------

--Fakeduck
local function handlefd()
	if fd_combo:GetValue() == 0 then
		if input.IsButtonDown(fakeduck:GetValue()) then 
			processticks:SetValue(14) 
		end
		if not input.IsButtonDown(fakeduck:GetValue()) then
			return
		end
	elseif fd_combo:GetValue() == 1 then
		if input.IsButtonDown(fakeduck:GetValue()) then 
			processticks:SetValue(15) 
		end
		if not input.IsButtonDown(fakeduck:GetValue()) then
			return
		end
	elseif fd_combo:GetValue() == 2 then
		if input.IsButtonDown(fakeduck:GetValue()) then 
			processticks:SetValue(16) 
		end
		if not input.IsButtonDown(fakeduck:GetValue()) then
			return
		end
	elseif fd_combo:GetValue() == 3 then
		if input.IsButtonDown(fakeduck:GetValue()) then 
			processticks:SetValue(17) 
		end
		if not input.IsButtonDown(fakeduck:GetValue()) then
			return
		end
	elseif fd_combo:GetValue() == 4 then
		if input.IsButtonDown(fakeduck:GetValue()) then 
			processticks:SetValue(18) 
		end
		if not input.IsButtonDown(fakeduck:GetValue()) then
			return
		end
	elseif fd_combo:GetValue() == 5 then
		if input.IsButtonDown(fakeduck:GetValue()) then 
			processticks:SetValue(19) 
		end
		if not input.IsButtonDown(fakeduck:GetValue()) then
			return
		end
	elseif fd_combo:GetValue() == 6 then
		if input.IsButtonDown(fakeduck:GetValue()) then 
			processticks:SetValue(7) 
		end
		if not input.IsButtonDown(fakeduck:GetValue()) then
			return
		end
	end
end
callbacks.Register('CreateMove', handlefd)

--------------------------------

--Limiting fakelag ticks on Revolver
local function handlerevolver()
	if r8_check:GetValue() then
		if entities.GetLocalPlayer():GetWeaponID() == 64 then
			if input.IsButtonDown(fakeduck:GetValue()) then 
				processticks:SetValue(14)
			end
			if not input.IsButtonDown(fakeduck:GetValue()) then
				processticks:SetValue(13)
			end
		end
		if not entities.GetLocalPlayer():GetWeaponID() == 64 then
			return
		end
	end
end
callbacks.Register('CreateMove', handlerevolver)

--------------------------------

--Pasted legshaking
local curtime = globals.CurTime()
local state = true
local function legbreaker()
	if lb_check:GetValue() then
		if entities.GetLocalPlayer() then
			entities.GetLocalPlayer():SetPropInt(0, "m_flPoseParameter")
			if globals.CurTime() > curtime then
				state = not state
				if lb_combo:GetValue() == 0 then
					curtime = globals.CurTime() + 0.10
				elseif lb_combo:GetValue() == 1 then
					curtime = globals.CurTime() + 0.07
				elseif lb_combo:GetValue() == 2 then
					curtime = globals.CurTime() + 0.05
				elseif lb_combo:GetValue() == 3 then
					curtime = globals.CurTime() + 0.04
				elseif lb_combo:GetValue() == 4 then
					curtime = globals.CurTime() + 0.03
				elseif lb_combo:GetValue() == 5 then
					curtime = globals.CurTime() + lb_slider:GetValue()
				end
				entities.GetLocalPlayer():SetPropInt(1, "m_flPoseParameter")
			end
			gui.SetValue("misc.slidewalk", state)
		end
	end
end
callbacks.Register('Draw', 'legbreaker', legbreaker);

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