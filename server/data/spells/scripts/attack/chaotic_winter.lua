-- To get the proper alignment on the sprite pattern, I created another version of the ICETORNADO effect which is shifted 1 tile horizontally
-- On the C++ side this required creating a new ThingType attribute, and repairing the saveDat function so I could export a modified dat file
-- The reason I decided to do it this way was to avoid any additional data needing to be sent over the network, and to avoid having duplicated image data stored in the dat file.

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO_SHIFTED)
combat:setArea(createCombatArea(AREA_BEAM1))

function onGetFormulaValues(player, level, magicLevel)
    local min = (level / 5) + (magicLevel * 5.5) + 25
    local max = (level / 5) + (magicLevel * 11) + 50
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local R = 3 -- the radius of the diamond of random points

 --using an id is safer than passing the creature directly for corner cases like the creature being deleted before the event executes
function strikeRandomPoints(creatureId)
    local creature = Creature(creatureId)
    if creature == nil then
        return
    end

    local pos = creature:getPosition() -- this can be moved outside if we don't want it to follow the caster
    for j = 1,8 do
        -- get a random point in a radius 3 diamond, excluding the center
        -- this is done by taking a skewed 4x6 rectangle, and shifting half of it to form a diamond
        -- this includes the center and misses a corner, so we then shift the center to the missing point
        -- (0,0) is the center
        --       . , , , , ,         .                 .
        --     . . . , , ,         . . .             . . .
        --   . . . . . ,         . . . . .         . . . . .
        -- . . . _ . .     =>  . . . _ . .   =>  . . .   . . _
        --                       , , , , ,         , , , , ,
        --                         , , ,             , , ,
        --                           ,                 ,
        local y =     math.random(0, R)
        local x = y + math.random(-R, R - 1)
        if x + y > R then
            x = x - R
            y = y - R - 1
        end
        if x == 0 and y == 0 then
            x = R
        end

        combat:execute(creature, Variant(Position(x+pos.x, y+pos.y, pos.z)))
    end
end

function onCastSpell(creature, variant)
    -- if this needed to be used in cases where it is not centered on the caster then I would convert the variant to a position based on what type of data it holds, but just using the caster position is simpler and works for the one case it's used

    for i = 1,10 do
        addEvent(strikeRandomPoints, 200*(i-1), creature:getId())
    end
	return true
end
