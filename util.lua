function slide(item, max, speed)
	if item.y > max then
		item.y = item.y - speed * dt
		return item

	else
		return nil
	end
end
