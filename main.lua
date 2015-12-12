require "lib/lovedebug" -- For live debugging
require "lib/boundingbox" -- coll(x1,y1,w1,h1 x2,y2,w2,h2)
Gamestate = require "lib/gamestate" -- For game states
anim8 = require 'lib/anim8' -- For animations

-- Define gamestates
menu = {}
level = {}
gameover = {}

-- Require our gamestates
require "menu"
require "level"
require "gameover"

function Proxy(f) -- Proxy function for sprites and audio
	return setmetatable({}, {__index = function(self, k)
		local v = f(k)
		rawset(self, k, v)
		return v
	end})
end


Anim = Proxy( function(k) return love.graphics.newImage("anim/"..k..".png") end)

