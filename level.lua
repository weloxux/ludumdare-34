function itemupdate(item, dt) -- Move items
	speed = speed + (dt * dt * 2)
	if speed < difficulty * 20 then
		item.y = item.y - speed
	else
		item.y = item.y - difficulty * 20
	end
	return item
end


function spawn_th ()
	while spawn_th > 0.5 do
		spawn_th = spawn_th - 0.00001 * spawn_th
	end
	return spawn_th
end
		
function spawn() -- Spawns in a random new item
	local seed = os.time()
	math.randomseed(seed)

	item = {x = width/2-20, y = 600}

	local ptype = math.random(9)
	if ptype <= 2 then
		item.type = "water"
	else
		item.type = "trash"
	end

	if item.type == "trash" then
		if math.random(1000) == 69 then -- Companion cube spawns with a chance of 1/1000
			item.sprite = Sprite.compcube
		else
			item.sprite = trashsprites[math.random(#trashsprites)]
		end
	elseif item.type == "water" then
		item.sprite = watersprites[math.random(#watersprites)]
	end
	
	table.insert(items, item)
end

function grow()
	local seed = os.time()
	math.randomseed(seed)
	table.insert(succession, stemsprites[math.random(#stemsprites)])
end

function vaporate(v) -- Gets called when water is thrown into the incinerator
	vapor = {x = 510, y = 110}
	if v.type == "water" then
		-- sound needed
		vapor.sprite = Sprite.vapor
	elseif v.type == "trash" then
		--sound needed
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
		succession[1] = nil
	end
	misses = misses + 1
end

function throw()
	for k,v in pairs(items) do
		if v.y < maxgrab and v.y > mingrab then
			if love.keyboard.isDown("right") then
				if v.type == "trash" then
					trashcount = trashcount + 1
				else
					misses = misses + 1
				end
				items[k] = nil
				vaporate(v)
			elseif love.keyboard.isDown("left") then
				items[k] = nil
				if v.type == "water" then
					grow()
				else
					ruin()
				end
			end
		elseif v.y < 165 then
			inyourface= inyourface + 1
			items[k] = nil
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

	-- Counters and stuff --
	items = {}			-- Keeps track of items
	inyourface = 0			-- Number of items you got IN YOUR FACE
	succession = {}			-- Keeps track of the plant's parts
	difficulty = 3			-- Difficulty (TODO: move to menu)
	spawntimer = 0			-- Timer var for spawning
	spawn_th = difficulty		-- Spawn threshold
	speed = difficulty * 0.7	-- Item speed
	trashcount = 0			-- Keep track of disposed garbage for stats
	misses = 0			-- Amount of wrongfully thrown items
	vapors = {}

	-- Constants --
	mingrab = 175				-- Closest place items can be grabbed
	maxgrab = 240				-- Farthest place items can be grabbed
	potloc = {x = width/2 - 150, y = 120}	-- Flower pot location
	
	-- Sound --
	love.audio.stop() -- Stop previously playing music
	Mus.compost:setVolume(0.1)
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
	
	-- Item spawning
	if spawntimer > spawn_th then -- Spawn new items if necessary
		spawn()
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
		if v.y < 70 then
			vapors[k] = nil
		else
			v.y = v.y - 3
		end
	end
	spawntimer = spawntimer + dt
end

function level:draw()
	-- Debug --
	love.graphics.print(spawntimer, 0, 0)
	love.graphics.print(love.timer.getFPS( ), 0, 20)

	-- Draw belt --
	for k,v in pairs(beltparts) do
		beltanim:draw(Anim.belt, v.x, v.y)
	end

	-- Draw items --
	for k,v in pairs(items) do
		love.graphics.draw(v.sprite, v.x, v.y)
	end

	-- Draw plant --
	love.graphics.draw(Sprite.pot, potloc.x, potloc.y)
	for k,v in pairs(succession) do
		local ypos = potloc.y - 40 - (40 * (k - 1))
		love.graphics.draw(v, potloc.x, ypos)
	end

	-- Draw etc. --
	incanim:draw(Anim.inc, 500, 120)
	for k,v in pairs(vapors) do
		love.graphics.draw (v.sprite, v.x, v.y)
	end

	love.graphics.draw(Sprite.expulsor, width/2-(Sprite.expulsor:getWidth() / 2), 520) 
	bulbanim:draw(Anim.bulb, 410, 563)
end
