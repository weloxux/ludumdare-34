function menu:enter(previous, ...)
	
end

function menu:update(dt)
	if love.keyboard.isDown(" ") then
		Gamestate.switch(level)
	end
end

function menu:draw()
	love.graphics.print("Menu", 400, 300)
end
