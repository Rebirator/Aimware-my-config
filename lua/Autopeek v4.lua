local misc_ref                  = gui.Reference('Misc', 'Automation', 'Movement')
local ui_quickstop              = gui.Combobox(misc_ref, 'autopeek.quickstop', 'Quick stop', 'Off', 'On, auto disable on MRX servers', 'Always on')
local ui_keybox                 = gui.Keybox(misc_ref, 'autopeek.key', 'Autopeek key', 0)
local ui_checkbox_visualize     = gui.Checkbox(misc_ref, 'autopeek.visualize', 'Visualize autopeek', false);

local LocalPlayerPos = 0
local AutopeekEnabledFrame = true
local AutopeekHasShot = false

local function drawCircle(Position, Radius) -- Will keep this function since the new api's circles aren't capable of drawing 3D circles
    if Position[1] == nil or Position[2] == nil or Position[3] == nil then
        return
    end

    local center = {client.WorldToScreen(Position[1], Position[2], Position[3])}
    for degrees = 1, 360, 8 do
        local thisPoint = nil;
        local lastPoint = nil;
                
        if Position[3] == nil then
            thisPoint = {Position[1] + math.sin(math.rad(degrees)) * Radius, Position[2] + math.cos(math.rad(degrees)) * Radius}; 
            lastPoint = {Position[1] + math.sin(math.rad(degrees - 1)) * Radius, Position[2] + math.cos(math.rad(degrees - 1)) * Radius};
        else
            thisPoint = {client.WorldToScreen(Position[1] + math.sin(math.rad(degrees)) * Radius, Position[2] + math.cos(math.rad(degrees)) * Radius, Position[3])};
            lastPoint = {client.WorldToScreen(Position[1] + math.sin(math.rad(degrees - 1)) * Radius, Position[2] + math.cos(math.rad(degrees - 1)) * Radius, Position[3])};
        end
                    
        if thisPoint[1] ~= nil and thisPoint[2] ~= nil and lastPoint[1] ~= nil and lastPoint[2] ~= nil then 
            draw.Line(thisPoint[1], thisPoint[2], lastPoint[1], lastPoint[2]); 
        end
        
    end
end

function moveToPos(cmd, pos)
    if pos[1] == nil or pos[2] == nil or pos[3] == nil then
        return
    end

    local distance = vector.Distance(pos, {entities.GetLocalPlayer():GetAbsOrigin()})
    if (distance < 0.1 ) then return end

    local world_forward = {vector.Subtract( pos,  {entities.GetLocalPlayer():GetAbsOrigin()} )}
    local ang_LocalPlayer = {cmd:GetViewAngles()}

    if (distance <= 1) then
        cmd:SetForwardMove( ( (math.sin(math.rad(ang_LocalPlayer[2]) ) * world_forward[2]) + (math.cos(math.rad(ang_LocalPlayer[2]) ) * world_forward[1]) ) * 0.75 )
        cmd:SetSideMove( ( (math.cos(math.rad(ang_LocalPlayer[2]) ) * -world_forward[2]) + (math.sin(math.rad(ang_LocalPlayer[2]) ) * world_forward[1]) ) * 0.75 )
        return
    end

    cmd:SetForwardMove( ( (math.sin(math.rad(ang_LocalPlayer[2]) ) * world_forward[2]) + (math.cos(math.rad(ang_LocalPlayer[2]) ) * world_forward[1]) ) * 300 )
    cmd:SetSideMove( ( (math.cos(math.rad(ang_LocalPlayer[2]) ) * -world_forward[2]) + (math.sin(math.rad(ang_LocalPlayer[2]) ) * world_forward[1]) ) * 300 )
end

callbacks.Register('Draw', function()
    if ui_keybox:GetValue() == 0 then
        return
    end

    if entities.GetLocalPlayer() then
        if not entities.GetLocalPlayer():IsAlive() then
            return
        end
    else
        return
    end

    local m_local = entities.GetLocalPlayer()

    if input.IsButtonDown(ui_keybox:GetValue()) and AutopeekEnabledFrame then
        LocalPlayerPos = { m_local:GetAbsOrigin() }
        AutopeekEnabledFrame = false

        if ui_quickstop:GetValue() == 0 then
            gui.SetValue('msc_quickstop', 0)
        elseif ui_quickstop:GetValue() == 1 then
            if engine.GetServerIP() == '62.122.214.132:27015' or engine.GetServerIP() == '62.122.214.132:27016' or engine.GetServerIP() == '178.32.80.148:27015'
            or engine.GetServerIP() == '178.32.80.148:27030' or engine.GetServerIP() == '178.32.80.148:27031' or engine.GetServerIP() == '178.32.80.148:27016' or engine.GetServerIP() == '178.32.80.148:27020' then
                gui.SetValue('msc_quickstop', 0)
            else
                gui.SetValue('msc_quickstop', 1)
            end
        elseif ui_quickstop:GetValue() == 2 then
            gui.SetValue('msc_quickstop', 1)
        end
    elseif input.IsButtonReleased(ui_keybox:GetValue()) and not AutopeekEnabledFrame then
        AutopeekEnabledFrame = true
        AutopeekHasShot = false
    end

    if input.IsButtonDown(ui_keybox:GetValue()) then
        draw.Color(200, 0, 0, 255)
        drawCircle({LocalPlayerPos[1], LocalPlayerPos[2], LocalPlayerPos[3]}, 3)
        draw.Color(255, 65, 0, 255)
        drawCircle({LocalPlayerPos[1], LocalPlayerPos[2], LocalPlayerPos[3]}, 7)
        draw.Color(255, 220, 0, 255)
        drawCircle({LocalPlayerPos[1], LocalPlayerPos[2], LocalPlayerPos[3]}, 11)
        draw.Color(200, 255, 0, 255)
        drawCircle({LocalPlayerPos[1], LocalPlayerPos[2], LocalPlayerPos[3]}, 15)
    end
end)

callbacks.Register('CreateMove', function(cmd)
    if ui_keybox:GetValue() == 0 then
        return
    end

    if entities.GetLocalPlayer() then
        if not entities.GetLocalPlayer():IsAlive() then
            AutopeekHasShot = false
            return
        end
    else
        AutopeekHasShot = false
        return
    end

    local m_local = entities.GetLocalPlayer()

    if AutopeekHasShot and input.IsButtonDown(ui_keybox:GetValue()) then
        moveToPos(cmd, {LocalPlayerPos[1], LocalPlayerPos[2], LocalPlayerPos[3]})

        local Difference = vector.Subtract({LocalPlayerPos[1], LocalPlayerPos[2], LocalPlayerPos[3]}, {m_local:GetAbsOrigin()})
        if vector.Length(Difference) < 5 then
            AutopeekHasShot = false
        end
    end
end)

callbacks.Register('FireGameEvent', function(Event)
    if ui_keybox:GetValue() == 0 then
        return
    end

    if entities.GetLocalPlayer() then
        if not entities.GetLocalPlayer():IsAlive() then
            return
        end
    else
        return
    end

    if Event:GetName() == "weapon_fire" then
        AutopeekHasShot = true
    end
end)
