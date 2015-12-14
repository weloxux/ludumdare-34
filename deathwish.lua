function deathwish:enter()
	dwcounter = 0
	bloodloc = -80
	SFX.DEATHWISH:setVolume(0.2)
	love.audio.play(SFX.DEATHWISH)
	love.graphics.setFont(bigfont)
end

function deathwish:update(dt)
	if dwcounter > 2.5 then
		love.graphics.setFont(font)
		Gamestate.switch(level)
	end

	dwcounter = dwcounter + dt
	bloodloc = bloodloc + (32 * dt)
end

function deathwish:draw()
	love.graphics.draw(Sprite.blood, 0, bloodloc)
	love.graphics.printf("DEATH WISH", 0, 250, 799, "center")
end
