import "CoreLibs/object"

class("Vector4").extends()

function Vector4:init(x, y, z, w)
	self.x = x
	self.y = y
	self.z = z
	self.w = w
end

function Vector4:multiplyScalar(scalar)
	self.x = self.x * scalar
	self.y = self.y * scalar
	self.z = self.z * scalar
	self.w = self.w * scalar
end

function Vector4:add(vector)
	self.x += vector.x
	self.y += vector.y
	self.z += vector.z
	self.w += vector.w
end
