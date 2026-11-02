
--========================================
-- PEDRO HUB | AUTO FARM
-- Version: 1.0.0
-- Roblox Studio - ModuleScript
--========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local AutoFarm = {}

-- Configurações
local SEARCH_DELAY = 1

-- Estado
local enabled = false
local currentTarget = nil
local targetChanged = Instance.new("BindableEvent")

-- Verificar se é um NPC válido
local function isNPC(object)

    if not object:IsA("Model") then
        return false
    end

    -- Ignorar personagens de jogadores
    if Players:GetPlayerFromCharacter(object) then
        return false
    end

    local humanoid =
        object:FindFirstChildOfClass("Humanoid")

    local root =
        object:FindFirstChild("HumanoidRootPart")

    return humanoid ~= nil
        and root ~= nil
        and humanoid.Health > 0
end

-- Procurar NPCs no Workspace
function AutoFarm.FindNPCs()

    local results = {}

    for _, object in ipairs(
        Workspace:GetDescendants()
    ) do

        if isNPC(object) then
            table.insert(results, object)
        end
    end

    return results
end

-- Obter alvo atual
function AutoFarm.GetTarget()
    return currentTarget
end

-- Verificar estado
function AutoFarm.IsEnabled()
    return enabled
end

-- Ativar / desativar
function AutoFarm.SetEnabled(value)

    enabled = value

    if not enabled then
        currentTarget = nil
        targetChanged:Fire(nil)
    end
end

-- Evento de mudança de alvo
function AutoFarm.OnTargetChanged(callback)

    targetChanged.Event:Connect(callback)

end

-- Ciclo de detecção
task.spawn(function()

    while true do

        if enabled then

            local npcs = AutoFarm.FindNPCs()

            currentTarget = npcs[1]

            targetChanged:Fire(currentTarget)

        end

        task.wait(SEARCH_DELAY)

    end

end)
--========================================
-- MOVIMENTAÇÃO E COMBATE
--========================================

local HEIGHT = 8
local DAMAGE = 9999999
local ATTACK_DELAY = 0.5

local function attackNPC(player, npc)

    if not enabled then return end
    if not player or not player.Character then return end
    if not isNPC(npc) then return end

    local character = player.Character
    local playerRoot =
        character:FindFirstChild("HumanoidRootPart")

    local humanoid =
        npc:FindFirstChildOfClass("Humanoid")

    local npcRoot =
        npc:FindFirstChild("HumanoidRootPart")

    if not playerRoot or not humanoid or not npcRoot then
        return
    end

    -- Movimentar o jogador acima do NPC
    playerRoot.CFrame =
        npcRoot.CFrame * CFrame.new(0, HEIGHT, 0)

    -- Aplicar dano
    humanoid:TakeDamage(DAMAGE)

    task.wait(ATTACK_DELAY)
end

return AutoFarm
