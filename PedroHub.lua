
--========================================
-- PEDRO HUB | AOT REVOLUTION
-- Version: 1.0.0
-- Interface only
--========================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Evitar interfaces duplicadas
local guiName = "PedroHub"

local parent
if gethui then
    local success, result = pcall(gethui)
    if success then
        parent = result
    end
end


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local DAMAGE = 9999
local HEIGHT = 8
local ATTACK_DELAY = 0.5
local SEARCH_DELAY = 1

-- Uma única Part reutilizável
local hitbox = Instance.new("Part")
hitbox.Name = "PedroHub_Hitbox"
hitbox.Size = Vector3.new(8, 8, 8)
hitbox.Transparency = 1
hitbox.Anchored = true
hitbox.CanCollide = false
hitbox.CanTouch = false
hitbox.CanQuery = false
hitbox.Parent = Workspace

local function getPlayer()
    while true do
        local player = Players:GetPlayers()[1]

        if player and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                return player, root
            end
        end

        task.wait(1)
    end
end

local function isNPC(model)
    if not model:IsA("Model") then
        return false
    end

    if Players:GetPlayerFromCharacter(model) then
        return false
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")

    return humanoid ~= nil
        and root ~= nil
        and humanoid.Health > 0
end

local function findNPC()
    for _, object in ipairs(Workspace:GetDescendants()) do
        if isNPC(object) then
            return object
        end
    end

    return nil
end

local player, playerRoot = getPlayer()

while true do
    local npc = findNPC()

    if npc then
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        local npcRoot = npc:FindFirstChild("HumanoidRootPart")

        if humanoid and npcRoot and humanoid.Health > 0 then
            -- Posiciona o jogador acima do NPC
            playerRoot.CFrame = npcRoot.CFrame * CFrame.new(0, HEIGHT, 0)

            -- Reposiciona a mesma hitbox
            hitbox.CFrame = npcRoot.CFrame

            -- Aplica dano pelo servidor
            humanoid:TakeDamage(DAMAGE)

            task.wait(ATTACK_DELAY)
        end
    else
        task.wait(SEARCH_DELAY)
    end

    -- Atualiza referências caso o personagem renasça
    if not player.Character
        or not player.Character:FindFirstChild("HumanoidRootPart") then

        player.CharacterAdded:Wait()
    end

    playerRoot = player.Character:WaitForChild("HumanoidRootPart")
end

parent = parent or CoreGui

pcall(function()
    local old = parent:FindFirstChild(guiName)
    if old then
        old:Destroy()
    end
end)

-- Criar interface
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

-- Janela principal
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(310, 260)
main.Position = UDim2.new(0.5, -155, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
main.BackgroundTransparency = 0.12
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 9)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 90, 115)
stroke.Transparency = 0.45
stroke.Parent = main

-- Cabeçalho
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundTransparency = 1
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "PEDRO HUB"
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Botão minimizar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(30, 30)
minimize.Position = UDim2.new(1, -72, 0, 7)
minimize.BackgroundTransparency = 1
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 24
minimize.Parent = header

-- Botão fechar
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -38, 0, 7)
close.BackgroundTransparency = 1
close.Text = "×"
close.TextColor3 = Color3.fromRGB(255, 110, 110)
close.TextSize = 24
close.Parent = header

-- Separador
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -20, 0, 1)
separator.Position = UDim2.fromOffset(10, 45)
separator.BackgroundColor3 = Color3.fromRGB(75, 75, 85)
separator.BorderSizePixel = 0
separator.Parent = main

-- Área dos botões
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -24, 1, -65)
container.Position = UDim2.fromOffset(12, 55)
container.BackgroundTransparency = 1
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

-- Opções
local options = {
    "Auto Farm",
    "Auto Recarregar Lâminas",
    "Auto Retry",
    "Auto Execute"
}

local states = {}

for index, name in ipairs(options) do

    states[name] = false

    local button = Instance.new("TextButton")
    button.Name = "Button" .. index
    button.Size = UDim2.new(1, 0, 0, 39)
    button.BackgroundColor3 = Color3.fromRGB(43, 43, 49)
    button.BorderSizePixel = 0
    button.Text = ""
    button.LayoutOrder = index
    button.Parent = container

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.fromOffset(12, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(235, 235, 240)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.fromOffset(38, 20)
    indicator.Position = UDim2.new(1, -49, 0.5, -10)
    indicator.BackgroundColor3 = Color3.fromRGB(75, 75, 80)
    indicator.BorderSizePixel = 0
    indicator.Parent = button

    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator

    local circle = Instance.new("Frame")
    circle.Size = UDim2.fromOffset(14, 14)
    circle.Position = UDim2.fromOffset(3, 3)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.BorderSizePixel = 0
    circle.Parent = indicator

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    button.MouseButton1Click:Connect(function()

        states[name] = not states[name]

        if states[name] then
            indicator.BackgroundColor3 =
                Color3.fromRGB(145, 100, 210)

            circle.Position = UDim2.new(1, -17, 0, 3)
        else
            indicator.BackgroundColor3 =
                Color3.fromRGB(75, 75, 80)

            circle.Position = UDim2.fromOffset(3, 3)
        end

    end)
end

-- Minimizar / restaurar
local minimized = false

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    container.Visible = not minimized
    separator.Visible = not minimized

    main.Size = minimized
        and UDim2.fromOffset(310, 45)
        or UDim2.fromOffset(310, 260)
end)

-- Fechar interface
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("PEDRO HUB carregado com sucesso!")
