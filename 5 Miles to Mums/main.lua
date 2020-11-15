import "Camera"

local gfx <const> = playdate.graphics

local camera
local characters = {}
local characterImage
local hand
local handImage

function init()
	camera = Camera(0, 0, 0)
	characterImage = gfx.image.new("images/character1")
	for index = 1, 6 do
		characters[index] = {}
		characters[index].sprite = gfx.sprite.new()
		characters[index].sprite:setImage(characterImage)
		characters[index].position = Vector4(math.random(), 0, math.random() + 5, 1)
	end
	handImage = gfx.image.new("images/hand")
	hand = gfx.sprite.new()
	hand:setImage(handImage)
	hand:setCenter(1, 1)
	hand:moveTo(400, 240)
	hand:setScale(0.3)
	hand:add()
end

function playdate.update()
	camera:update()
	for index = 1, 6 do
		local transform = Vector4(characters[index].position.x, characters[index].position.y, characters[index].position.z, 1)
		camera:worldToPostProjection(transform)
		if transform.z < camera:getNearPlane() then
			characters[index].sprite:remove()
		else
			characters[index].sprite:setZIndex(-transform.z)
			characters[index].sprite:moveTo(transform.x * 400, transform.y * 240)
			characters[index].sprite:setScale(1 / transform.z)
			characters[index].sprite:add()
		end
	end
	gfx.sprite.update()
end

init()
