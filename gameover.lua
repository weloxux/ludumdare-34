--[[function whoami(difficulty)
	if difficulty == 1 then
		name = "Difficulty: Flying Garbage"
	elseif  difficulty == 2 then
		name = "Difficulty: Take Your Time"
	elseif difficulty == 3 then
		name = "Difficulty: Greenling"
	end
end]]--

function gameover:enter(previous, ...)
	love.audio.stop() -- Stop previously playing music
	--whoami(difficulty)
	print ("Name: " .. name)
	lscore = (#succession * 100) - (misses * 100) - (inyourface * 100)
	highscore.add(name, lscore)
	highscore.save()
	Mus.overgrown:setVolume(0.15)
	Mus.overgrown:play()
	Mus.overgrown:setLooping(true)
	love.timer.sleep(0.3)
end

function gameover:keypressed(key, code)
	if key == "right" then
		Gamestate.switch(level)
	elseif key == "escape" then
		love.event.quit()
	elseif key == "left" then
		Gamestate.switch(menu)
	end
end

function gameover:update(dt)
end

function gameover:draw()
	for i, tscore, tname in highscore() do
		love.graphics.print("Your score:", 30, 20)
		love.graphics.print(name, 50, 40)
		love.graphics.print(lscore, 660, 40)
		love.graphics.print("Top score:", 30, 80)
		love.graphics.print(tname, 50, 100)
		love.graphics.print(tscore, 660, 100)
	end

	love.graphics.printf("Press right to restart", 0, 300, 799, "center")
	love.graphics.printf("Press left to return to menu", 0, 320, 799, "center")
--	love.graphics.printf("What to press to escape??", 80, 395, 800, center)
--	love.graphics.printf("You´ll be trapped in here forever!", 50, 450, 800, center)
end
