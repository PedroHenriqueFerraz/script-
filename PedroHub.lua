
--========================================
-- PEDRO HUB | AUTO FARM
-- Version: 3.0.0
-- Roblox Studio
--========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- CONFIGURAÇÕES
local DAMAGE = 9999
local HEIGHT = 8
local ATTACK_DELAY = 0.5
local SEARCH_DELAY = 1

-- EVENTO DE ATIVAÇÃO
local remote = ReplicatedStorage:WaitForChild("AutoFarmEvent")

-- ESTADOS DOS JOGADORES
local active = {}

-- HITBOX REUTILIZÁVEL POR JOGADOR
local hitboxes = {}

-- Verificar se é um NPC válido
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

-- Procurar próximo NPC
local function findNPC()

    for _, object in ipairs(Workspace:GetDescendants()) do

        if isNPC(object) then
            return object
        end

    end

    return nil
end

-- Criar hitbox
local function createHitbox(player)

    local hitbox = Instance.new("Part")

    hitbox.Name = "PedroHub_Hitbox"
    hitbox.Size = Vector3.new(8, 8, 8)
    hitbox.Transparency = 1
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.CanTouch = false
    hitbox.CanQuery = true
    hitbox.Parent = Workspace

    hitboxes[player] = hitbox

    return hitbox
end

-- Verificar se a hitbox está sobre o NPC
local function hitboxTouchesNPC(hitbox, npc)

    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = {npc}

    local parts = Workspace:GetPartsInPart(hitbox, params)

    return #parts > 0
end

-- Executar Auto Farm
local function startFarm(player)

    if active[player] then
        return
    end

    active[player] = true

    local hitbox = hitboxes[player] or createHitbox(player)

    task.spawn(function()

        while active[player] do

            local npc = findNPC()

            if not npc then
                task.wait(SEARCH_DELAY)
                continue
            end

            local humanoid = npc:FindFirstChildOfClass("Humanoid")
            local npcRoot = npc:FindFirstChild("HumanoidRootPart")

            while active[player]
                and humanoid
                and npcRoot
                and humanoid.Health > 0
                and npc.Parent do

                local character = player.Character

                local playerRoot = character
                    and character:FindFirstChild("HumanoidRootPart")

                if not playerRoot then
                    break
                end

                -- Posicionar jogador acima do NPC
                playerRoot.CFrame =
                    npcRoot.CFrame * CFrame.new(0, HEIGHT, 0)

                -- Posicionar hitbox no NPC
                hitbox.CFrame = npcRoot.CFrame

                -- Aplicar dano se a hitbox alcançar o NPC
                if hitboxTouchesNPC(hitbox, npc) then
                    humanoid:TakeDamage(DAMAGE)
                end

                task.wait(ATTACK_DELAY)

            end

            task.wait()
        end

    end)
end

-- Parar Auto Farm
local function stopFarm(player)

    active[player] = nil

    local hitbox = hitboxes[player]

    if hitbox then
        hitbox:Destroy()
        hitboxes[player] = nil
    end
end

-- Receber ativação da interface
remote.OnServerEvent:Connect(function(player, enabled)

    if typeof(enabled) ~= "boolean" then
        return
    end

    if enabled then
        startFarm(player)
    else
        stopFarm(player)
    end

end)

-- Limpeza ao sair
Players.PlayerRemoving:Connect(function(player)

    stopFarm(player)

end)

print("PEDRO HUB | AUTO FARM carregado!")
