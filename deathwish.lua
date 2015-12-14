function deathwish:enter()
	dwcounter = 0
	love.audio.play(SFX.DEATHWISH)
end

function deathwish:update(dt)
	if dwcounter > 3 then
		Gamestate.switch(level)
	end

	dwcounter = dwcounter + dt
end

function deathwish:draw()
end
