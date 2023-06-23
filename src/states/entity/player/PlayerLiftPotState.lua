--[[
    Author: Brandon Yurkiewicz 
    github: YurkiewB
]]

local pot = nil

PlayerLiftPotState = Class{__includes = BaseState}

function PlayerLiftPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon


    -- render offset
    self.player.offsetY = 5
    self.player.offsetX = 0

    self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerLiftPotState:enter(params)
    
    if params ~= nil then 
        gSounds['pot-lift']:play()

        pot = params.pot
        pot.solid = false

        self.player.currentAnimation:refresh()

        local potX, potY = self.player.x, self.player.y - 12

        Timer.tween(0.3, {
            [pot] = {x = potX, y = potY}
        })
    end

end


function PlayerLiftPotState:update(dt)
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('pot-idle', {pot = pot, dungeon = self.dungeon})
    end
end



function PlayerLiftPotState:render()
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