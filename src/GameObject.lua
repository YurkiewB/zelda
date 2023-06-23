--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
local dungeon = nil

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- projectile 
    self.projectile = def.projectile
    self.dx = 0
    self.dy = 0
    self.speed = 80
    self.distanceTraveled = 0
    self.maxDistance = 2 * TILE_SIZE
    self.thrown = false
    self.dungeon = nil
    self.player = nil
    


    --decides if collidable or not
    self.collidable = def.collidable
    self.consumable = def.consumable

    -- default empty collision callback
    self.onCollide = def.onCollide
    
    -- onConsume
    self.onConsume = def.onConsume

end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:fire(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    if self.projectile then
        if self.type == "pot" then
            if player.direction == 'left' then
                self.dx = -self.speed
            elseif player.direction == 'right' then
                self.dx = self.speed
            elseif player.direction == 'up' then
                self.dy = -self.speed
            elseif player.direction == 'down' then
                self.dy = self.speed
            end

            self.thrown = true
        end 

    end
end

function GameObject:update(dt)
    if self.thrown then
        -- Update the pot's position
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt

        -- Update the distance traveled
        self.distanceTraveled = self.distanceTraveled + math.abs(self.dx * dt) + math.abs(self.dy * dt)

        if self.dungeon ~= nil then
            local entities = self.dungeon.currentRoom.entities
            local objects = self.dungeon.currentRoom.objects

            for k, entity in pairs(entities) do 
                if self:collides(entity) then
                    entity:damage(1) 
                    self.dx = 0
                    self.dy = 0
                    if self.type == 'pot' then 
                        self.state = 'broken'
                        self.thrown = false
                    end
                    gSounds['hit-enemy']:play()
                    if entity.health == 0 then 
                        if math.random(1, 3) == 3 then
                            local heart = GameObject(
                            GAME_OBJECT_DEFS['heart'],
                            entity.x,
                            entity.y
                        )

                        -- collision with heart passes heart object
                        heart.onCollide = function(heart)
                            gSounds['pickup']:play()

                            for k, object in pairs(self.dungeon.currentRoom.objects) do
                                if object == heart then
                                    table.remove(self.dungeon.currentRoom.objects, k)
                                end
                            end
                        
                            if self.player.health + 2 <= 6 then
                                self.player.health = self.player.health + 2
                            else
                                self.player.health = 6
                            end
                        end

                        Timer.tween(0.1, {
                            [heart] = {y = entity.y + 4}
                        })
                        table.insert(self.dungeon.currentRoom.objects, heart)
                        end 
                    end 
                end
            end
        end

        if self.distanceTraveled >= self.maxDistance then
            self.dx = 0
            self.dy = 0
            if self.type == 'pot' then 
                self.state = 'broken'
                self.thrown = false
            end
        end

        if self.x < 28 or self.x > VIRTUAL_WIDTH - 46  or self.y < 28 or self.y > VIRTUAL_HEIGHT - 48 then
            self.dx = 0
            self.dy = 0
            if self.type == 'pot' then
                self.state = 'broken'
                self.thrown = false
            end
        end


        
        
    end
    



end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end