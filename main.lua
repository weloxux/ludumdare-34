require "lib/lovedebug" -- For live debugging
require "lib/boundingbox" -- coll(x1,y1,w1,h1 x2,y2,w2,h2)
highscore = require "lib/sick"
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
Sprite = Proxy( function(k) return love.graphics.newImage("spr/"..k..".png") end)
Mus = Proxy(function(k) return love.audio.newSource(love.sound.newSoundData("mus/"..k..".wav")) end)
SFX = Proxy(function(k) return love.audio.newSource(love.sound.newSoundData("snd/"..k..".wav")) end)

function love.load()
	width, height = love.graphics.getDimensions() -- Get screen size

	-- Prepare sprite lists --
	trashsprites = {Sprite.trash1, Sprite.trash2, Sprite.trash3}
	watersprites = {Sprite.water1}
	stemsprites = {Sprite.stem1,Sprite.stem2,Sprite.stem3}
	floorsprites = {Sprite.tile1, Sprite.tile2, Sprite.tile3, Sprite.tile4, Sprite.tile5, Sprite.tile6}
	wallsprites = {Sprite.wall1, Sprite.wall2}

	highscore.set("highscore", 1, "Wow you suck.", -100000)
 	
	font = love.graphics.newFont("font/justice.ttf", 23)
	bigfont = love.graphics.newFont("font/justice.ttf", 35)
	love.graphics.setFont(font)

	Gamestate.registerEvents() -- Find all gamestates
	Gamestate.switch(menu)
end
