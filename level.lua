function itemupdate(item, dt) -- Move items
	speed = speed + (dt * dt)
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
	local types = {"trash", "water"}
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
--		if math.random(1000) == 69 then -- Companion cube spawns with a chance of 1/1000
		if math.random(3) == 1 then -- Companion cube spawns with a chance of 1/1000
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
 
function level:enter(previous, ...)
	-- Animations --
	local g = anim8.newGrid(80, 40, (80 * 4), 40) -- Belt is 80x40
	beltanim = anim8.newAnimation(g('1-4',1), 0.0155)
	local g = anim8.newGrid(120,80, (120 * 3),80) -- Incinerator is 120x80
	incanim = anim8.newAnimation(g('1-3',1), 0.15)

	-- Counters and stuff --
	items = {}
	succession = {}
	pile_direction = 0
	difficulty = 3 -- TEMPORARILY HERE
	spawntimer = 0
	spawn_th = difficulty
	speed = difficulty * 0.7

	-- Constants --
	mingrab = 200
	maxgrab = 280
	potloc = {x = width/2 - 150, y = 120}

	-- Build up conveyor belt --
	beltparts = {}
	for i=0,9 do -- Add the whole of the conveyor belt
		table.insert(beltparts, {x = width/2-40, y = (i * 40) + mingrab}) -- Figure this one out yourself, schmuck
	end
end

function level:update(dt)
	-- Animations --
	beltanim:update(dt)
	incanim:update(dt)

	-- Controls --
	if love.keyboard.isDown("right") then
		pile_direction = 1
	elseif love.keyboard.isDown("left") then
		pile_direction = 2
	else 
		pile_direction = 0
	end
	
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
	spawntimer = spawntimer + dt
end

function level:draw()
	-- Debug --
	love.graphics.print("Level", 400, 300)
	love.graphics.print(spawntimer, 0, 0)
	love.graphics.print(love.timer.getFPS( ), 0, 30)

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
end
