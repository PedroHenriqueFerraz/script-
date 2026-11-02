
--========================================
-- PEDRO HUB | AUTO FARM
-- Version: 2.0.0
--========================================

local ReplicatedStorage =
    game:GetService("ReplicatedStorage")

local AutoFarm = {}

-- Configurações
AutoFarm.HEIGHT = 8
AutoFarm.DAMAGE = 9999999
AutoFarm.ATTACK_DELAY = 0.5
AutoFarm.SEARCH_DELAY = 1

-- Comunicação com o servidor
local remote = ReplicatedStorage:
    WaitForChild("AutoFarmEvent")

-- Estado
local enabled = false

-- Ativar ou desativar
function AutoFarm.SetEnabled(value)

    if typeof(value) ~= "boolean" then
        return
    end

    if enabled == value then
        return
    end

    enabled = value

    remote:FireServer(
        enabled,
        AutoFarm.HEIGHT,
        AutoFarm.DAMAGE,
        AutoFarm.ATTACK_DELAY,
        AutoFarm.SEARCH_DELAY
    )

    print(
        "PEDRO HUB | AUTO FARM: " ..
        (enabled and "ATIVADO" or "DESATIVADO")
    )
end

-- Consultar estado
function AutoFarm.IsEnabled()
    return enabled
end

-- Desligar
function AutoFarm.Stop()
    AutoFarm.SetEnabled(false)
end

return AutoFarm
