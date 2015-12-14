
function intro:enter(previous, ...)
	bwalls = {}
	bcolumns = (height / 40)
	for i=1,bcolumns do -- Put rows in the columns
		bnewrow = {}
		table.insert(bwalls, bnewrow)
		for j=1,(width/40) do
			newsprite = wallsprites[math.random(#wallsprites)]
			table.insert(bwalls[i], newsprite)
		end
	end
	introtext = "It is the year 21XX. You are NAMEHERE, a dangerous criminal that robs garbage containers with his evil, antagonistical, horRIBLE, HORRENDOUS plant growing skills, instead of using his green fingers for the greater good. However, in your terrible quest of terror, you seem to have been caught by the plantlice (ouch, terrible), and you have been jailed up. Your day task consists of throwing garbage in the incinerator, but, being the powerful super villain you definitely are, you have devised a plan(t). Instead of throwing all garbage in the garbage container, you're going to throw all trash containing water ON A NEARBY PLANT. That's right, what a twist. You'll then be able to escape over the prison walls."
	texttimer = 0
	textloc = height
	love.graphics.setFont(introfont)
end

function intro:keypressed(key, code)
	if key == "left" then
		love.graphics.setFont(font)
		Gamestate.switch(level)
	end
end

function intro:update(dt)
	texttimer = texttimer + dt
	if texttimer > 49 then
		love.graphics.setFont(font)
		Gamestate.switch(level)
	end
	textloc = textloc - (dt * 40)
end

function intro:draw()
        for i in pairs(bwalls) do
                for j in pairs(bwalls[i]) do
                        love.graphics.draw(bwalls[i][j], (j - 1) * 40, (i - 1) * 40)
                end
        end

	love.graphics.printf(introtext, 200, textloc, 400, "center")
	love.graphics.print("left\nto skip", 5, 5)
end
