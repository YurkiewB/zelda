--[[
    Author: Brandon Yurkiewicz
    GitHub: YurkiewB
]]


PlayerIdlePotState = Class{__includes = EntityIdleState}

function PlayerIdlePotState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.player = self.entity

    self.dungeon = params.dungeon
    self.pot = params.pot
    
    self.entity:changeAnimation('pot-walk-idle-' .. self.entity.direction)

end

function PlayerIdlePotState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pot-walk', {pot = self.pot, dungeon = self.dungeon})
    end

    if love.keyboard.wasPressed('return') then
        local potX, potY = self.player.x, self.player.y + 16
        
        Timer.tween(0.01, {
            [self.pot] = {x = potX, y = potY}
        })
        self.entity:changeState('idle', self.dungeon)
    end

    local pot = self.pot
    if pot ~= nil then 
        local potX, potY = self.player.x, self.player.y - 12
        
        Timer.tween(0.01, {
            [pot] = {x = potX, y = potY}
        })

    end

end

function PlayerIdlePotState:render()
    
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))


    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.potHurtbox.width, self.potHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)



end
