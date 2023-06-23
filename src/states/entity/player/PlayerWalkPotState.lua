PlayerWalkPotState = Class{__includes = EntityWalkState}

function PlayerWalkPotState:init(player, dungeon)
    self.entity = player
    self.player = player
    self.dungeon = dungeon


    -- render offset
    self.player.offsetY = 5
    self.player.offsetX = 0

    self.player:changeAnimation('pot-walk-' .. self.player.direction)

end

function PlayerWalkPotState:enter(params)
    self.player.currentAnimation:refresh()
    self.pot = params.pot
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
        self.player:changeState('pot-idle', {pot = self.pot, dungeon = self.dungeon})
    end

    if love.keyboard.wasPressed('return') then
        self.pot:fire(self.player, self.dungeon)
        self.entity:changeState('idle', self.dungeon)
    end

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    local pot = self.pot
    if pot ~= nil then 

        local potX, potY = self.player.x, self.player.y - 12

        Timer.tween(0.01, {
            [pot] = {x = potX, y = potY}
        })
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