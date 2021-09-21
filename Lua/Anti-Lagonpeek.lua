--[[--------------------------------------Credits---------------------------------------------------

                             Anti-Lagonpeek made by GLadiator                                       
                                     Found by Soufiw

------------------------------------------Credits-----------------------------------------------]]--

callbacks.Register( 'Draw', 'AntiLagOnPeek', function( )
    if entities.GetLocalPlayer( ):GetTeamNumber( ) == 1 then
        client.SetConVar( 'cl_lagcompensation', 0, true )
    end
end)

callbacks.Register( 'Unload', function( )
    client.SetConVar( 'cl_lagcompensation', 1, true )
end)