function menu:enter(previous, ...)
	love.audio.stop() -- Stop previously playing music
	Mus.bombombom:setVolume(0.2)
	Mus.bombombom:play()
	Mus.bombombom:setLooping(true)

	optionpointer = 1
	options = {"o_start()", "o_difficulty()", "o_exit()"}
	difficultyl = {1,2,3}
	difficulty = #difficultyl
end

function o_start() -- Start the game
	difficulty = difficultyl[difficulty]
	Gamestate.switch(level)
end

function o_difficulty() -- Set the difficulty
	if difficulty < #difficultyl then
		difficulty = difficulty + 1
	else
		difficulty = 1
	end
end

function o_exit() -- Quit
	love.quit()
end

function menu:keypressed(key, code)
	if key ~= "left" then
		return
	end

	if optionpointer < #options then
		optionpointer = optionpointer + 1
	else
		optionpointer = 1
	end
end

function menu:update(dt)
	if love.keyboard.isDown("right") then
		loadstring(options[optionpointer])()
	end
end

function menu:draw()
	love.graphics.draw(Sprite.menu, 0, 0)
	love.graphics.printf("Press left to cycle, right to select", 30, 300, 800, center)
	love.graphics.printf(string.sub(options[optionpointer], 3), 30, 330, 800, center)
end
