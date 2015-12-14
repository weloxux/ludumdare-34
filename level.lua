function itemupdate(item, dt) -- Move items
	speed = speed + (dt * dt * 2)
	if speed < difficulty * 20 then
		item.y = item.y - speed
	else
		item.y = item.y - difficulty * 20
	end
	return item
end

function spawn_update(elapsed, spawn_th)
	local grades = {{0, 3}, {10, 2.8}, {25, 2.6}, {40, 2.0}, {55, 1.7}, {65, 1.4}, {80, 1.2}, {95, 0.8}, {110, 0.5}}
	for k,v in pairs(grades) do
		if elapsed > v[1] and spawn_th > v[2] then
			spawn_th = v[2]
			love.audio.play(SFX.next)
		end
	end
	return spawn_th
end
		
function spawn(dt) -- Spawns in a random new item
	local seed = os.time() * dt
	math.randomseed(seed)

	item = {x = width/2-20, y = 600 - 40}

	local ptype = math.random(3)
	if ptype <= 1 then
		item.type = "water"
	else
		item.type = "trash"
	end

	if item.type == "trash" then
		if math.random(500) == 69 then -- Companion cube spawns with a chance of 1/500
			item.sprite = Sprite.compcube
		else
			item.sprite = trashsprites[math.random(#trashsprites)]
		end
	elseif item.type == "water" then
		item.sprite = watersprites[math.random(#watersprites)]
	end

	print(item.type .. " ")
	
	table.insert(items, item)
end

function grow()
	love.audio.play(SFX.grow)
	local seed = os.time()
	math.randomseed(seed)
	table.insert(succession, stemsprites[math.random(#stemsprites)])
end

function vaporate(v) -- Gets called when water is thrown into the incinerator
	vapor = {x = 520, y = 110}
	if v.type == "water" then
		love.audio.play(SFX.vaporize)
		vapor.sprite = Sprite.vapor
	elseif v.type == "trash" then
		love.audio.play(SFX.vaporize)
		vapor.sprite = Sprite.smoke
	end
	table.insert(vapors, vapor)
end

function ruin() -- Gets called when trash gets thrown onto the plant
	local i = 0
	for k,v in pairs(succession) do
		i = i + 1
	end
	if i ~= 0 then
--		succession[1] = nil
		table.remove(succession, 1)
	end
	misses = misses + 1
end

function level:keypressed(key, code)
	throw(key)
end

function throw(key)
	for k,v in pairs(items) do
		if key ~= nil then
			if v.y < maxgrab and v.y > mingrab then
				if k == 1 then -- REMOVE ME IF INCORRECT
					if key == "right" then
						if v.type == "trash" then
							trashcount = trashcount + 1
						else
							misses = misses + 1
						end
						table.remove(items, 1)
						vaporate(v)
					elseif key == "left" then
						table.remove(items, 1)
						if v.type == "water" then
							grow()
						else
							ruin()
						end
					end
				end
			end
		elseif v.y < 165 then
			inyourface = inyourface + 1
			love.audio.play(SFX.inyourface)
			lifes = lifes - 1
			table.remove(items, k)
		end
	end
end

function level:enter(previous, ...)
	-- Animations --
	local g = anim8.newGrid(80, 40, (80 * 4), 40) -- Belt is 80x40
	beltanim = anim8.newAnimation(g('1-4',1), 0.0155)
	local g = anim8.newGrid(120,80, (120 * 3),80) -- Incinerator is 120x80
	incanim = anim8.newAnimation(g('1-3',1), 0.15)
	local g = anim8.newGrid(10, 10, (10*4), 10)	  -- Red lightbulb is 10x10
	bulbanim = anim8.newAnimation(g('1-4', 1), 0.15)

	floor = {}
	columns = (height / 40)
	for i=1,columns do -- Put rows in the columns
		newrow = {}
		table.insert(floor, newrow)
		for j=1,(width/40) do
			newsprite = floorsprites[math.random(#floorsprites)]
			table.insert(floor[i], newsprite)
		end
	end

	-- 100
	wall = {}
	for i=1,(width/40) do -- Delicious spaghetti
		newrow = {}
		table.insert(wall, newrow)
		for j=1,4 do
			newsprite = wallsprites[math.random(#wallsprites)]
			table.insert(wall[i], newsprite)
		end
	end

	-- Counters and stuff --
	items = {}			-- Keeps track of items
	inyourface = 0			-- Number of items you got IN YOUR FACE
	succession = {}			-- Keeps track of the plant's parts
	spawntimer = 0			-- Timer var for spawning
	if name ~= "DEATH WISH" then
		spawn_th = 3		-- Spawn threshold
		speed = 3 - difficulty 		-- Item speed
	else
		spawn_th = 1.4
		speed = 5 		-- Item speed
	end
	trashcount = 0			-- Keep track of disposed garbage for stats
	misses = 0			-- Amount of wrongfully thrown items
	vapors = {}
	elapsed = 0
	lifes = 3
	-- Constants --
	mingrab = 175				-- Closest place items can be grabbed
	maxgrab = 260				-- Farthest place items can be grabbed
	potloc = {x = width/2 - 150, y = 200}--170}	-- Flower pot location
	
	-- Sound --
	love.audio.stop() -- Stop previously playing music

	-- Set volumes --
	Mus.compost:setVolume(0.2)
	SFX.vaporize:setVolume(0.2)
	SFX.next:setVolume(0.2)
	SFX.inyourface:setVolume(0.2)
	SFX.grow:setVolume(0.2)

	-- Start background music --
	Mus.compost:play()
	Mus.compost:setLooping(true)
	
	-- Build up conveyor belt --
	beltparts = {}
	for i=0,9 do -- Add the whole of the conveyor belt
		table.insert(beltparts, {x = width/2-40, y = (i * 40) + 200}) -- Figure this one out yourself, schmuck
	end
end

function level:update(dt)
	-- Animations --
	beltanim:update(dt)
	incanim:update(dt)
	bulbanim:update(dt)
	throw()
	
	-- Game over?--
	if lifes == 0 then
		Gamestate.switch(gameover)
	end
	
	-- Item spawning
	if spawntimer > spawn_th + difficulty then -- Spawn new items if necessary
		spawn(dt)
		spawntimer = 0
	end

	-- Item movement
	for k,v in pairs(items) do
		items[k] = itemupdate(v, dt) -- Move all items
	
		if v.y < 0 - 40 then --TODO
			items[k] = nil
		end
	end
	for k,v in pairs(vapors)do
		if v.y < 50 then
			vapors[k] = nil
		else
			v.y = v.y - 3
		end
	end
	spawn_th = spawn_update(elapsed, spawn_th)
	elapsed = elapsed + dt
	spawntimer = spawntimer + (2 * dt)
end

function level:draw()
	-- Floor --
	for i in pairs(floor) do
		for j in pairs(floor[i]) do
			love.graphics.draw(floor[i][j], (j - 1) * 40, (i - 1) * 40)
		end
	end

	-- Wall --
	for i in pairs(wall) do
		for j in pairs(wall[i]) do
			love.graphics.draw(wall[i][j], (i - 1) * 40, -20 + ((j - 1) * 40))
		end
	end

	-- Debug --
	love.graphics.print(spawntimer, 0, 0)
	love.graphics.print(elapsed, 0, 40)
	love.graphics.print(spawn_th, 0, 20)

	-- Draw belt --
	for k,v in pairs(beltparts) do
		beltanim:draw(Anim.belt, v.x, v.y)
	end

	love.graphics.draw(Sprite.expulsor, width/2-(Sprite.expulsor:getWidth() / 2), 520) 
	bulbanim:draw(Anim.bulb, 410, 563)

	-- Draw items --
	for k,v in pairs(items) do
		love.graphics.draw(v.sprite, v.x, v.y)
	end

	-- Draw hearts --
	for i=1, lifes do 
		love.graphics.draw(Sprite.heart, 660 +(i - 1) * 40, 20)
	end
		
	-- Draw plant --
	love.graphics.draw(Sprite.pot, potloc.x, potloc.y)
	for k,v in pairs(succession) do
		local ypos = potloc.y - 40 - (40 * (k - 1))
		love.graphics.draw(v, potloc.x, ypos)
	end
	love.graphics.draw(Sprite.top, potloc.x, potloc.y - 40 - (40 * #succession))

	-- Draw etc. --
	love.graphics.draw(Sprite.char, (width / 2) - (Sprite.char:getWidth() / 2), 120)

	incanim:draw(Anim.inc, 500, 120)
	for k,v in pairs(vapors) do
		love.graphics.draw (v.sprite, v.x, v.y)
	end

end
