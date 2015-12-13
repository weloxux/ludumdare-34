function whoami(difficulty)
	if difficulty == 3 then
		name = "Difficulty: Flying Garbage"
	elseif  difficulty == 2 then
		name = "Difficulty: Take Your Time"
	end
end

function gameover:enter(previous, ...)
	love.audio.stop() -- Stop previously playing music
	whoami(difficulty)
	score = -1 * inyourface - misses + #succession
	highscore.add(name, score)
	highscore.save()
	Mus.overgrown:setVolume(0.2)
	Mus.overgrown:play()
	Mus.overgrown:setLooping(true)
end

function gameover:update(dt)
	if love.keyboard.isDown("r") then
	--	Gamestate.switch(level)
	elseif love.keyboard.isDown("escape") then
	end
end

function gameover:draw()
	love.graphics.printf("Press R to restart", 400, 350, 800, center) -- Debug
	love.graphics.printf("Press ??? to restart", 400, 400, 800, center)
	love.graphics.printf("You´ll be trapped in here forever!", 400, 410, 800, center)
end
