import "Vector4"

class("Matrix4x4").extends()

function Matrix4x4:init()
	self.elements = {
		{ 1, 0, 0, 0 },
		{ 0, 1, 0, 0 },
		{ 0, 0, 1, 0 },
		{ 0, 0, 0, 1 }
	}
end

function Matrix4x4:set(row, column, value)
	self.elements[row][column] = value
end

function Matrix4x4:get(row, column)
	return self.elements[row][column]
end

function Matrix4x4:setRotationAroundY(angle)
	self.elements = {
		{ 1, 0, 0, 0 },
		{ 0, 1, 0, 0 },
		{ 0, 0, 1, 0 },
		{ 0, 0, 0, 1 }
	}
	self.elements[1][1] = math.cos(angle)
	self.elements[1][3] = -math.sin(angle)
	self.elements[3][1] = math.sin(angle)
	self.elements[3][3] = math.cos(angle)
end

function Matrix4x4:setFastInverse(matrix)
	for column = 1, 4 do
		for row = 1, 4 do
			self.elements[row][column] = matrix:get(column, row)
		end
	end
	self.elements[1][4] = 0
	self.elements[2][4] = 0
	self.elements[3][4] = 0
	self.elements[4][4] = 0
	local vector = Vector4(-matrix:get(4, 1), -matrix:get(4, 2), -matrix:get(4, 3), 0)
	vector:multiplyMatrix(self)
	self.elements[4][1] = vector.x
	self.elements[4][2] = vector.y
	self.elements[4][3] = vector.z
	self.elements[4][4] = 1
end

function Matrix4x4:multiply(matrix1, matrix2)
	for column = 1, 4 do
		for row = 1, 4 do
			self.elements[row][column] = 0
			for index = 1, 4 do
				self.elements[row][column] += matrix1:get(row, index) * matrix2:get(index, column)
			end
		end
	end
end

function Vector4:multiplyMatrix(matrix)
	local x = self.x
	local y = self.y
	local z = self.z
	local w = self.w
	self.x = x * matrix:get(1, 1)
	self.x += y * matrix:get(2, 1)
	self.x += z * matrix:get(3, 1)
	self.x += w * matrix:get(4, 1)
	self.y = x * matrix:get(1, 2)
	self.y += y * matrix:get(2, 2)
	self.y += z * matrix:get(3, 2)
	self.y += w * matrix:get(4, 2)
	self.z = x * matrix:get(1, 3)
	self.z += y * matrix:get(2, 3)
	self.z += z * matrix:get(3, 3)
	self.z += w * matrix:get(4, 3)
	self.w = x * matrix:get(1, 4)
	self.w += y * matrix:get(2, 4)
	self.w += z * matrix:get(3, 4)
	self.w += w * matrix:get(4, 4)
end
