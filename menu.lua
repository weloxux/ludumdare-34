function menu:enter(previous, ...)
	love.audio.stop() -- Stop previously playing music
	Mus.bombombom:setVolume(0.15)
	Mus.bombombom:play()
	Mus.bombombom:setLooping(true)

	optionpointer = 1
	options = {"o_start()", "o_difficulty()", "o_exit()"}
	difficultyl = {3,2,1}
	difficulty = 2
end

function o_start() -- Start the game
	difficulty = difficultyl[difficulty]
	Gamestate.switch(level)
end

function o_difficulty() -- Set the difficulty
	print(difficulty .. " " .. #difficultyl)
	if difficulty < #difficultyl then
		difficulty = difficulty + 1
	else
		difficulty = 1
	end
end

function o_exit() -- Quit
	love.event.quit()
end

function menu:keypressed(key, code)
	if key == "right" then
		loadstring(options[optionpointer])()
	end
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
end

function menu:draw()
	local difs = {"easy", "normal", "hard"}
	love.graphics.draw(Sprite.menu, 0, 0)
	love.graphics.printf("Press left to cycle, right to select", 30, 400, 800, center)

	love.graphics.setFont(bigfont)
	love.graphics.printf(string.sub(options[optionpointer], 3, -3), 30, 430, 800, center)

	if optionpointer == 2 then
		love.graphics.printf(difs[difficulty], 30, 455, 800, center)
	end
	love.graphics.setFont(font)
end
