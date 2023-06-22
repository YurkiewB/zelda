PlayerWalkPotState = Class{__includes = BaseState}

function PlayerWalkPotState:init(player, dungeon)
    self.entity = player
    self.player = player
    self.dungeon = dungeon


    -- render offset
    self.player.offsetY = 5
    self.player.offsetX = 0

end

function PlayerWalkPotState:enter(params)
    self.player.currentAnimation:refresh()
end


function PlayerWalkPotState:update(dt)

    if love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player:changeAnimation('pot-walk-left')
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player:changeAnimation('pot-walk-right')
    elseif love.keyboard.isDown('up') then
        self.player.direction = 'up'
        self.player:changeAnimation('pot-walk-up')
    elseif love.keyboard.isDown('down') then
        self.player.direction = 'down'
        self.player:changeAnimation('pot-walk-down')
    else
        if self.player.direction == 'left' then
            self.player:changeAnimation('pot-walk-left-idle')
        
        elseif self.player.direction == 'right' then
            self.player:changeAnimation('pot-walk-right-idle')
        elseif self.player.direction == 'down' then
            self.player:changeAnimation('pot-walk-down-idle')
        elseif self.player.direction == 'up' then
            self.player:changeAnimation('pot-walk-up-idle')
        end
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    if self.bumped then

        if self.entity.direction == 'left' then
            
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end


            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end


            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end

            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        else
            
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end

            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        if self.player.direction == 'left' then
            self.player:changeAnimation('pot-walk-left-idle')
        elseif self.player.direction == 'right' then
            self.player:changeAnimation('pot-walk-right-idle')
        elseif self.player.direction == 'down' then
            self.player:changeAnimation('pot-walk-down-idle')
        elseif self.player.direction == 'up' then
            self.player:changeAnimation('pot-walk-up-idle')
        end
    end
end



function PlayerWalkPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.potHurtbox.width, self.potHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end