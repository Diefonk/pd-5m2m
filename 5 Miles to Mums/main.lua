import "Camera"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics
local tmr <const> = playdate.timer

local camera
local characters = {}
local characterImages = {}
local hand
local handImage
local sign
local signImage
local sound

function despawnCharacter(character)
	character.scaleTimer = tmr.new(200, 0.4, 0)
	character.scaleTimer.timerEndedCallback = spawnCharacter
	character.scaleTimer.timerEndedArgs = { character }
end


function spawnCharacter(character)
	character.x = (math.random() * 7 - 3.5) + camera.position.x
	character.z = (math.random() * 7 - 3.5) + camera.position.z
	character.scaleTimer = tmr.new(200, 0, 0.4)
	tmr.performAfterDelay(math.random() * 5000 + 10000, despawnCharacter, character)
end

function init()
	camera = Camera(0.5, 1, -1)

	characterImages[1] = gfx.image.new("images/character1")
	characterImages[2] = gfx.image.new("images/character2")
	characterImages[3] = gfx.image.new("images/character3")
	characterImages[4] = gfx.image.new("images/character4")
	characterImages[5] = gfx.image.new("images/character5")
	for index = 1, 15 do
		characters[index] = {}
		characters[index].sprite = gfx.sprite.new()
		characters[index].sprite:setImage(characterImages[index % 5 + 1])
		characters[index].sprite:setCenter(0.5, 1)
		characters[index].scale = 0
		spawnCharacter(characters[index])
	end

	signImage = gfx.image.new("images/sign")
	sign = gfx.sprite.new()
	sign:setImage(signImage)
	sign:setCenter(0.5, 1)

	handImage = gfx.image.new("images/hand")
	hand = gfx.sprite.new()
	hand:setImage(handImage)
	hand:setCenter(1, 1)
	hand:moveTo(400, 240)
	hand:setScale(0.4)
	hand:add()

	sound = playdate.sound.sampleplayer.new("sound")
	sound:setVolume(0.5)
	sound:play(0)
end

function playdate.update()
	tmr.updateTimers()
	camera:update()
	for index = 1, 15 do
		local transform = Vector4(characters[index].x, 0, characters[index].z, 1)
		camera:worldToPostProjection(transform)
		if transform.z < camera.nearPlane or transform.z > camera.farPlane then
			characters[index].sprite:remove()
		else
			characters[index].sprite:setZIndex(-(transform.z * 1000))
			characters[index].sprite:moveTo(transform.x, transform.y)
			if characters[index].scaleTimer then
				characters[index].scale = characters[index].scaleTimer.value
			end
			characters[index].sprite:setScale(characters[index].scale / transform.z)
			characters[index].sprite:add()
		end
	end
	local transform = Vector4(0, 0, 0, 1)
	camera:worldToPostProjection(transform)
	if transform.z < camera.nearPlane or transform.z > camera.farPlane then
		sign:remove()
	else
		sign:setZIndex(-(transform.z * 1000))
		sign:moveTo(transform.x, transform.y)
		sign:setScale(0.4 / transform.z)
		sign:add()
	end
	gfx.sprite.update()
end

init()
