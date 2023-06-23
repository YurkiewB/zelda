--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
        type = 'consumable',
        texture = 'hearts',
        frame = 5,
        height = 16,
        width = 16,
        solid = false,
        collidable = true,
        consumbale = true,
        defaultState = 'whole',
        states = {
            ['whole'] = {
                frame = 5
            }
        }       
    },
    ['pot'] = {
        -- TODO
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        height = 16,
        width = 16,
        solid = true,
        collidable = true,
        projectile = true,
        defaultState = 'unbroken',
        states = {
            ['unbroken'] = {
                frame = 14
            },
            ['broken'] = {
                frame = 52
            }
        }
    }
}