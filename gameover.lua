function whoami(difficulty)
	if difficulty == 1 then
		name = "Difficulty: Flying Garbage"
	elseif  difficulty == 2 then
		name = "Difficulty: Take Your Time"
	elseif difficulty == 3 then
		name = "Difficulty: Greenling"
	end
end

function gameover:enter(previous, ...)
	love.audio.stop() -- Stop previously playing music
	whoami(difficulty)
	print ("Name: " .. name)
	local score = #succession - misses
	highscore.add(name, score)
	highscore.save()
	Mus.overgrown:setVolume(0.2)
	Mus.overgrown:play()
	Mus.overgrown:setLooping(true)
end

function gameover:update(dt)
	if love.keyboard.isDown("r") then
		Gamestate.switch(level)
	elseif love.keyboard.isDown("escape") then
		love.event.quit()
	end
end

function gameover:draw()
	for i, score, name in highscore() do
		love.graphics.print(name, 50, i * 100)
		love.graphics.print(score, 660, i * 100)
	end

	love.graphics.printf("Press R to restart", 190, 255, 800, center) -- Debug
	love.graphics.printf("What to press to escape??", 80, 395, 800, center)
	love.graphics.printf("You´ll be trapped in here forever!", 50, 450, 800, center)
end
