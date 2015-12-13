function menu:enter(previous, ...)
	love.audio.stop() -- Stop previously playing music
	Mus.bombombom:setVolume(0.2)
	Mus.bombombom:play()
	Mus.bombombom:setLooping(true)
end

function menu:update(dt)
	if love.keyboard.isDown(" ") then
		Gamestate.switch(level)
	end
end

function menu:draw()
	love.graphics.print("Menu", width / 2, 300) -- Debug
end
