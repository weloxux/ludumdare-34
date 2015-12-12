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
	seed = os.time()
	math.randomseed(seed)
	item = {x = width/2-20, y = 600, type = types[math.random(2)]}
	if item.type == "trash" then
		item.sprite = trashsprites[math.random(#trashsprites)]
	elseif item.type == "water" then
		item.sprite = watersprites[math.random(#watersprites)]
	end
	
	table.insert(items, item)
end
 
function level:enter(previous, ...)
	local g = anim8.newGrid(80, 40, (80 * 4), 40) -- Belt is 80x40
	beltanim = anim8.newAnimation(g('1-4',1), 0.0155)
	items = {}
	succession = 0
	pile_direction = 0
	difficulty = 3 -- TEMPORARILY HERE
	spawntimer = 0
	spawn_th = difficulty
	speed = difficulty * 0.7
	beltparts = {}
	
	for i=0,9 do -- Add the whole of the conveyor belt
		table.insert(beltparts, {x = width/2-40, y = (i * 40) + 200})
	end
end

function level:update(dt)
	beltanim:update(dt)
	if love.keyboard.isDown("right") then
		pile_direction = 1
	elseif love.keyboard.isDown("left") then
		pile_direction = 2
	else 
		pile_direction = 0
	end
	
	if spawntimer > spawn_th then -- Spawn new items if necessary
		spawn()
		spawntimer = 0
	end

	for k,v in pairs(items) do
		items[k] = itemupdate(v, dt) -- Move all items
	
		if v.y < 0 - 40 then --TODO
			items[k] = nil
		end
	end
	spawntimer = spawntimer + dt
end

function level:draw()
	
	love.graphics.print("Level", 400, 300)
	love.graphics.print(spawntimer, 0, 0)
	love.graphics.print(love.timer.getFPS( ), 0, 30)
	for k,v in pairs(beltparts) do
		beltanim:draw(Anim.belt, v.x, v.y)
	end
	for k,v in pairs(items) do
		love.graphics.draw(v.sprite, v.x, v.y)
	end
end
