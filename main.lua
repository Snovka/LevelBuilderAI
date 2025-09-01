-- LevelBuilderAI mod for Geode Launcher
-- Generates levels, decorations, and checks passability

local LevelBuilder = {}

-- Generator settings
LevelBuilder.difficulty = 0.5   -- 0 = easy, 1 = hard
LevelBuilder.length = 100       -- level length in blocks
LevelBuilder.blocks = {}
LevelBuilder.decorations = {}

-- Level generation
function LevelBuilder:generateLevel()
    for i = 1, self.length do
        -- Main block
        if math.random() < self.difficulty then
            table.insert(self.blocks, {pos = i, type = "obstacle"})
        else
            table.insert(self.blocks, {pos = i, type = "normal"})
        end

        -- Decorations
        if math.random() < 0.3 then
            table.insert(self.decorations, {pos = i, type = "decoration"})
        end
    end
end

-- Check if level is passable
function LevelBuilder:isLevelPassable()
    local consecutiveObstacles = 0
    for _, block in ipairs(self.blocks) do
        if block.type == "obstacle" then
            consecutiveObstacles = consecutiveObstacles + 1
            if consecutiveObstacles > 3 then
                return false -- too hard
            end
        else
            consecutiveObstacles = 0
        end
    end
    return true
end

-- Pseudo music sync
function LevelBuilder:syncWithMusic()
    print("Syncing blocks with music...")
    -- You can implement timers or beat detection here
end

-- Main start
function LevelBuilder:start()
    repeat
        self.blocks = {}
        self.decorations = {}
        self:generateLevel()
    until self:isLevelPassable() -- regenerate until level is passable
    self:syncWithMusic()
    print("Level ready! Total blocks: " .. #self.blocks)
end

-- Run the mod when the game starts
LevelBuilder:start()
