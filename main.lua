-- LevelBuilderAI Mod for Geometry Dash (Geode Launcher)
-- New version: UI-controlled difficulty, length, style input, decorations, passability check

local LevelBuilder = {}

-- Default settings
LevelBuilder.settings = {
    difficulty = "Normal",  -- Options: Easy → Extreme Demon
    length = 100,
    style = ""              -- user input for background/decor style
}

-- Difficulty mapping to numeric values
local difficultyValues = {
    ["Easy"] = 0.1,
    ["Normal"] = 0.3,
    ["Hard"] = 0.5,
    ["Harder"] = 0.6,
    ["Insane"] = 0.7,
    ["Easy Demon"] = 0.75,
    ["Medium Demon"] = 0.8,
    ["Hard Demon"] = 0.85,
    ["Insane Demon"] = 0.9,
    ["Extreme Demon"] = 1.0
}

LevelBuilder.blocks = {}
LevelBuilder.decorations = {}

-- Generate level
function LevelBuilder:generateLevel()
    local diff = difficultyValues[self.settings.difficulty]
    local styleText = (self.settings.style or ""):lower()

    for i = 1, self.settings.length do
        -- Main block
        if math.random() < diff then
            table.insert(self.blocks, {pos = i, type = "obstacle"})
        else
            table.insert(self.blocks, {pos = i, type = "normal"})
        end

        -- Decorations based on style keywords
        local decoType = "decoration"
        if styleText:find("space") then
            decoType = "star"
        elseif styleText:find("galaxies") then
            decoType = "galaxy"
        elseif styleText:find("gray") then
            decoType = "gray_deco"
        end

        if math.random() < 0.3 then
            table.insert(self.decorations, {pos = i, type = decoType})
        end
    end
end

-- Check passability
function LevelBuilder:isLevelPassable()
    local consecutiveObstacles = 0
    for _, block in ipairs(self.blocks) do
        if block.type == "obstacle" then
            consecutiveObstacles = consecutiveObstacles + 1
            if consecutiveObstacles > 3 then
                return false
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
end

-- Generate level until passable
function LevelBuilder:start()
    repeat
        self.blocks = {}
        self.decorations = {}
        self:generateLevel()
    until self:isLevelPassable()
    self:syncWithMusic()
    print("Level ready! Difficulty: " .. self.settings.difficulty ..
          ", Length: " .. self.settings.length ..
          ", Style: " .. (self.settings.style or "Default"))
end

-- ========== Geode UI ==========

-- Difficulty dropdown
local difficultyDropdown = ModUI.Dropdown("Difficulty", {
    "Easy","Normal","Hard","Harder","Insane",
    "Easy Demon","Medium Demon","Hard Demon","Insane Demon","Extreme Demon"
}, LevelBuilder.settings.difficulty)
difficultyDropdown.onChange = function(value)
    LevelBuilder.settings.difficulty = value
end

-- Length slider
local lengthSlider = ModUI.Slider("Level Length", 10, 300, LevelBuilder.settings.length)
lengthSlider.onChange = function(value)
    LevelBuilder.settings.length = value
end

-- Style text input
local styleInput = ModUI.TextBox("Level Style", "")
styleInput.onChange = function(value)
    LevelBuilder.settings.style = value
end

-- Generate button
local generateButton = ModUI.Button("Generate Level")
generateButton.onClick = function()
    LevelBuilder:start()
end
