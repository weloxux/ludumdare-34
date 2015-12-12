function itemupdate(item, dt) -- Move items
--[[	movement = dt * difficulty
	local maxspeed = 50 * difficulty

	if movement < maxspeed then
		spawn_th = movement
		item.y = item.y - (0.5 * movement)
	else
		spawn_th = dt * 50
		item.y = item.y - (0.5 * maxspeed)
	end]]--

	-- Wolla mattie wat is deze

	spawn_th = spawn_th - 0.00001 * spawn_th
	speed = speed + (dt * dt)
	item.y = item.y - speed

	return item, spawn_th
end

function spawn() -- Spawns in a random new item
	local types = {"trash", "water"}
	seed = os.time()
	math.randomseed(seed)
	item = {x = 350, y = 600, type = types[math.random(2)]}
	if item.type == "trash" then
		item.sprite = trashsprites[math.random(#trashsprites)]
	elseif item.type == "water" then
		item.sprite = watersprites[math.random(#watersprites)]
	end
	
	table.insert(items, item)
end

function position()

end
 
function level:enter(previous, ...)
	items = {}
	succession = 0
	pile_direction = 0
	difficulty = 3 -- TEMPORARILY HERE
	spawntimer = 0
	spawn_th = difficulty
	speed = difficulty
end

function level:update(dt)
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
		items[k], spawn_th = itemupdate(v, dt) -- Move all items

		if v.y < 0 then --TODO
			items[k] = nil
		end
	end

	spawntimer = spawntimer + dt
end

function level:draw()
	love.graphics.print("Level", 400, 300)
	love.graphics.print(spawntimer, 0, 0)
	
	for k,v in pairs(items) do
		print(v.y)
		love.graphics.draw(v.sprite, v.x, v.y)
	end
end
