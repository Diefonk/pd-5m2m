import "Vector4"
import "Matrix4x4"

class("Camera").extends()

function Camera:init(x, y, z)
	self.speed = 1
	self.rotation = 0
	self.nearPlane = 0.1
	self.farPlane = 10
	self.windowRatio = 400 / 240
	self.projectionMatrix = Matrix4x4()
	self.projectionMatrix:set(1, 1, self.windowRatio)
	self.projectionMatrix:set(3, 3, self.farPlane / (self.farPlane - self.nearPlane))
	self.projectionMatrix:set(3, 4, 1)
	self.projectionMatrix:set(4, 3, -(self.farPlane * self.nearPlane) / (self.farPlane - self.nearPlane))
	self.projectionMatrix:set(4, 4, 0)
	self.position = Vector4(x, y, z, 1)
	self.orientation = Matrix4x4()
	self.transformation = Matrix4x4()
	self.viewMatrix = Matrix4x4()
end

function Camera:update()
	local left = playdate.buttonIsPressed(playdate.kButtonLeft)
	local right = playdate.buttonIsPressed(playdate.kButtonRight)
	local forwards = playdate.buttonIsPressed(playdate.kButtonUp)
	local backwards = playdate.buttonIsPressed(playdate.kButtonDown)
	self.orientation:setRotationAroundY(playdate.getCrankPosition() * (math.pi / 180))
	if left and not right then
		local direction = Vector4(-1, 0, 0, 0)
		direction:multiplyScalar(self.speed * 0.033) --delta time
		direction:multiplyMatrix(self.orientation)
		self.position:add(direction)
	elseif right and not left then
		local direction = Vector4(1, 0, 0, 0)
		direction:multiplyScalar(self.speed * 0.033) --delta time
		direction:multiplyMatrix(self.orientation)
		self.position:add(direction)
	end
	if forwards and not backwards then
		local direction = Vector4(0, 0, 1, 0)
		direction:multiplyScalar(self.speed * 0.033) --delta time
		direction:multiplyMatrix(self.orientation)
		self.position:add(direction)
	elseif backwards and not forwards then
		local direction = Vector4(0, 0, -1, 0)
		direction:multiplyScalar(self.speed * 0.033) --delta time
		direction:multiplyMatrix(self.orientation)
		self.position:add(direction)
	end

	local translation = Matrix4x4()
	translation:set(4, 1, self.position.x)
	translation:set(4, 2, self.position.y)
	translation:set(4, 3, self.position.z)
	self.transformation:multiply(self.orientation, translation)
	self.viewMatrix:setFastInverse(self.transformation)
end

function Camera:worldToPostProjection(transform)
	transform:multiplyMatrix(self.viewMatrix)
	transform:multiplyMatrix(self.projectionMatrix)
	if transform.z >= self.nearPlane then
		transform.x = transform.x / transform.z
		transform.y = transform.y / transform.z
		transform.x = transform.x / self.windowRatio
		transform.x = (transform.x + 1) / 2
		transform.x = transform.x * 400
		transform.y = 1 - (transform.y + 1) / 2
		transform.y = transform.y * 240
	end
end
