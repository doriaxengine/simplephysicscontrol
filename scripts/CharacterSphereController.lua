-- CharacterSphereController.lua

local CharacterSphereController = {
    properties = {
        { name = "moveAcceleration", displayName = "Move Acceleration", type = "float", default = 6.0 },
        { name = "isActive", displayName = "Is Active", type = "bool", default = true }
    }
}

function CharacterSphereController:init()
    self.body = Body3D(self.scene, self.entity)
    self.sphere = Object(self.scene, self.entity)
    self.spaceWasPressed = false

    -- Transform changes must be made before the physics fixed step syncs them.
    RegisterEngineEvent(self, "onUpdate")
    RegisterEngineEvent(self, "onFixedUpdate")
end

function CharacterSphereController:onUpdate()
    local spacePressed = Input.isKeyPressed(Input.KEY_SPACE)
    if spacePressed and not self.spaceWasPressed then
        self.body.linearVelocity = Vector3(0.0, 0.0, 0.0)
        self.body.angularVelocity = Vector3(0.0, 0.0, 0.0)
        self.sphere.position = Vector3(0.0, 1.1, 0.0)
    end
    self.spaceWasPressed = spacePressed
end

function CharacterSphereController:onFixedUpdate()
    if not self.isActive then return end

    local dirX = 0.0
    local dirZ = 0.0

    if Input.isKeyPressed(Input.KEY_LEFT) then dirX = dirX - 1.0 end
    if Input.isKeyPressed(Input.KEY_RIGHT) then dirX = dirX + 1.0 end
    if Input.isKeyPressed(Input.KEY_UP) then dirZ = dirZ - 1.0 end
    if Input.isKeyPressed(Input.KEY_DOWN) then dirZ = dirZ + 1.0 end

    if dirX == 0.0 and dirZ == 0.0 then return end

    local length = math.sqrt(dirX * dirX + dirZ * dirZ)
    dirX = dirX / length
    dirZ = dirZ / length

    local force = self.body.mass * self.moveAcceleration
    self.body:applyForce(Vector3(dirX * force, 0.0, dirZ * force))
end

return CharacterSphereController
