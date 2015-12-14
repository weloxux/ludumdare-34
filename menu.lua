function menu:enter(previous, ...)
	love.audio.stop() -- Stop previously playing music
	Mus.bombombom:setVolume(0.15)
	Mus.bombombom:play()
	Mus.bombombom:setLooping(true)

	optionpointer = 1
	options = {"o_start()", "o_difficulty()", "o_exit()"}
	difficultyl = {0.9,0.5,0}
	difficulty = 2
	SFX.DEATHWISH:setVolume(2.8)
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
	local difs = {"normal", "hard", "DEATH WISH"}
	local names = {"Difficulty: normal", "Difficulty: hard", "DEATH WISH"}
	love.graphics.draw(Sprite.menu, 0, 0)
	love.graphics.printf("Press left to cycle, right to select", 0, 400, 799, "center")

	love.graphics.setFont(bigfont)
	love.graphics.printf(string.sub(options[optionpointer], 3, -3), 0, 430, 799, "center")

	if optionpointer == 2 then
		love.graphics.printf(difs[difficulty], 0, 455, 800, "center")
		name = names[difficulty]
	end
	love.graphics.setFont(font)
end
