if (SERVER) then

	util.AddNetworkString("nlr_timer_player_died")
	util.AddNetworkString("nlr_timer_start_timer")

	hook.Add("PlayerDeath", "HandlePlayerDied", function( victim, inflictor, attacker )
    	
    	net.Start("nlr_timer_player_died")
    	net.Send(victim)

	end)

    hook.Add("PlayerSpawn", "HandlePlayerSpawn", function( ply )
        
    	net.Start("nlr_timer_start_timer")
    	net.Send(ply)

    end)

end	