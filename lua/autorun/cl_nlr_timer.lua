if (CLIENT) then

	local nlrTimer = {}
	nlrTimer.length = 30
	nlrTimer.endTime = 0
	nlrTimer.active = false
	nlrTimer.text = nil
	nlrTimer.frame = nil
	nlrTimer.playerDied = false

	function showTimer( )
		
		if nlrTimer.active then
			local frame = vgui.Create("DFrame")
			frame:SetSize(200, 75)
			frame:SetTitle("")
			frame:SetVisible(true)
			frame:ShowCloseButton(false)
			frame:SetDraggable(false)
			frame:SetPos((ScrW() - frame:GetWide()) / 2, (ScrH() - frame:GetTall()) - 150)
			frame.Paint = function(self, w, h)

	            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 224))
	            
				draw.SimpleText("NLR", "RobotLarge", 100, 10, Color(224, 24, 24, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			end

			nlrTimer.frame = frame

			local label = vgui.Create("DLabel", frame)
	        label:SetText("Endet in 00:00")
	        label:SetFont("Robot")
	        label:Dock(FILL)
	        label:SetContentAlignment(5)

	        surface.CreateFont( "Robot", {
            	font = "Robot",
            	size = 20,
            	weight = 400,
            	antialias = true
        	})

        	surface.CreateFont( "RobotLarge", {
            	font = "Robot",
            	size = 28,
            	weight = 400,
            	antialias = true
        	})


	        nlrTimer.text = label
	    end
	end

	function startTimer()

		nlrTimer.active = true
		nlrTimer.endTime = CurTime() + nlrTimer.length

	end

	function stopTimer()

		nlrTimer.active = false

	end	

	function updateTimer()
		
		if nlrTimer.active then

			nlrTimer.remaining = nlrTimer.endTime - CurTime()

			if nlrTimer.remaining > 0 then

				nlrTimer.minutes = math.floor(nlrTimer.remaining / 60)
				nlrTimer.seconds = math.floor(nlrTimer.remaining % 60)
				local timerText = "Endet in " .. string.format("%02d:%02d", nlrTimer.minutes, nlrTimer.seconds)

				if IsValid(nlrTimer.text) then
					nlrTimer.text:SetText(timerText)
				end

			else

				stopTimer()

				nlrTimer.frame:Remove()

			end	

		end	

	end

	hook.Add("Think", "updateTimer", updateTimer)

	net.Receive("nlr_timer_player_died", function( len )

		nlrTimer.playerDied = true

	end)

	net.Receive("nlr_timer_start_timer", function( len )

		if nlrTimer.playerDied then
			startTimer()
			showTimer()
			nlrTimer.playerDied = false
		end

	end)

end