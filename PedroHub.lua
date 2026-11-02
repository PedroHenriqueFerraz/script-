
--========================================
-- PEDRO HUB
-- Version: 2.0.0
-- Interface + Auto Farm
--========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("AutoFarmEvent")

local gui = Instance.new("ScreenGui")
gui.Name = "PedroHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local states = {
    ["Auto Farm"] = false,
    ["Auto Recarregar Lâminas"] = false,
    ["Auto Retry"] = false,
    ["Auto Execute"] = false
}

-- Janela
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(310, 260)
main.Position = UDim2.new(0.5, -155, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
main.BackgroundTransparency = 0.12
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 9)

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

-- Minimizar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(30, 30)
minimize.Position = UDim2.new(1, -72, 0, 7)
minimize.BackgroundTransparency = 1
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 24
minimize.Parent = header

-- Fechar
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

-- Botões
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -24, 1, -65)
container.Position = UDim2.fromOffset(12, 55)
container.BackgroundTransparency = 1
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = container

local options = {
    "Auto Farm",
    "Auto Recarregar Lâminas",
    "Auto Retry",
    "Auto Execute"
}

local function setToggle(name, value)
    states[name] = value

    if name == "Auto Farm" then
        remote:FireServer(value)
    end
end

for index, name in ipairs(options) do

    local button = Instance.new("TextButton")
    button.Name = "Button" .. index
    button.Size = UDim2.new(1, 0, 0, 39)
    button.BackgroundColor3 = Color3.fromRGB(43, 43, 49)
    button.BorderSizePixel = 0
    button.Text = ""
    button.LayoutOrder = index
    button.Parent = container

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 6)

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

    Instance.new("UICorner", indicator).CornerRadius =
        UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.fromOffset(14, 14)
    circle.Position = UDim2.fromOffset(3, 3)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.BorderSizePixel = 0
    circle.Parent = indicator

    Instance.new("UICorner", circle).CornerRadius =
        UDim.new(1, 0)

    button.MouseButton1Click:Connect(function()

        local newState = not states[name]
        setToggle(name, newState)

        if newState then
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

-- Minimizar
local minimized = false

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    container.Visible = not minimized
    separator.Visible = not minimized

    main.Size = minimized
        and UDim2.fromOffset(310, 45)
        or UDim2.fromOffset(310, 260)
end)

-- Fechar
close.MouseButton1Click:Connect(function()
    setToggle("Auto Farm", false)
    gui:Destroy()
end)

print("PEDRO HUB carregado!")



--========================================
-- PEDRO HUB | AUTO FARM SERVER
-- Version: 2.0.0
--========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local DAMAGE = 9999999
local HEIGHT = 8
local ATTACK_DELAY = 0.5
local SEARCH_DELAY = 1

-- Criar evento de comunicação
local remote = ReplicatedStorage:FindFirstChild("AutoFarmEvent")

if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "AutoFarmEvent"
    remote.Parent = ReplicatedStorage
end

local active = {}

-- Verificar NPC
local function isNPC(object)

    if not object:IsA("Model") then
        return false
    end

    if Players:GetPlayerFromCharacter(object) then
        return false
    end

    local humanoid = object:FindFirstChildOfClass("Humanoid")
    local root = object:FindFirstChild("HumanoidRootPart")

    return humanoid ~= nil
        and root ~= nil
        and humanoid.Health > 0
end

-- Procurar NPCs
local function findNPC()

    for _, object in ipairs(Workspace:GetDescendants()) do

        if isNPC(object) then
            return object
        end

    end

    return nil
end

-- Desligar Auto Farm
local function stopFarm(player)
    active[player] = nil
end

-- Ativação
remote.OnServerEvent:Connect(function(player, enabled)

    if typeof(enabled) ~= "boolean" then
        return
    end

    if not enabled then
        stopFarm(player)
        return
    end

    if active[player] then
        return
    end

    active[player] = true

    task.spawn(function()

        while active[player] do

            local character = player.Character
            local playerRoot = character
                and character:FindFirstChild("HumanoidRootPart")

            local npc = findNPC()

            if playerRoot and npc then

                local humanoid =
                    npc:FindFirstChildOfClass("Humanoid")

                local npcRoot =
                    npc:FindFirstChild("HumanoidRootPart")

                if humanoid and npcRoot and humanoid.Health > 0 then

                    -- Posicionar jogador acima do NPC
                    playerRoot.CFrame =
                        npcRoot.CFrame * CFrame.new(0, HEIGHT, 0)

                    -- Aplicar dano no servidor
                    humanoid:TakeDamage(DAMAGE)

                    task.wait(ATTACK_DELAY)
                end

            else
                task.wait(SEARCH_DELAY)
            end

            task.wait()
        end

    end)

end)

Players.PlayerRemoving:Connect(function(player)
    active[player] = nil
end)

print("PEDRO HUB AUTO FARM SERVER carregado!")
