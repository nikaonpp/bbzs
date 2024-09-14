-- Função para teletransportar o jogador para a posição das moedas
local function teleportToCoins()
    local collectibles = game:GetService("Workspace"):GetDescendants()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local itemFound = false

    for _, item in pairs(collectibles) do
        if item.Name == "Coin" and item:IsA("BasePart") then
            itemFound = true
            humanoidRootPart.CFrame = item.CFrame + Vector3.new(0, 1, 0)
            print("Teleportado para Coin: ", item.Name)
            wait(0.2)
        end
    end

    if not itemFound then
        print("Nenhuma moeda encontrada.")
    end
end

-- Função para teletransportar o jogador para a posição dos LegendaryChest
local function teleportToLegendaryChest()
    local collectibles = game:GetService("Workspace"):GetDescendants()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local itemFound = false

    for _, item in pairs(collectibles) do
        if item.Name == "LegendaryChest" and item:IsA("BasePart") then
            itemFound = true
            humanoidRootPart.CFrame = item.CFrame + Vector3.new(0, 1, 0)
            print("Teleportado para LegendaryChest: ", item.Name)
            wait(0.2)
        end
    end

    if not itemFound then
        print("Nenhum LegendaryChest encontrado.")
    end
end

local function backevent()
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    local targetPosition = Vector3.new(-350.322, 32.2789, -1413.78)
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    print("Voltando para o barco")
end

local function startgame()
    -- Encontre e renomeie o objeto NoAutoOpen para Autoopen
    local configuracao = game:GetService("Workspace").HouseInteriors.blueprint.pokasbolas201.Doors.MainDoor.WorkingParts.Configuration.NoAutoOpen
    if configuracao then
        configuracao.Name = "Autoopen"
        print("Objeto renomeado para Autoopen")
    else
        warn("O objeto NoAutoOpen não foi encontrado.")
        return
    end

    -- Encontre a porta
    local porta = game:GetService("Workspace").HouseInteriors.blueprint.pokasbolas201.Doors.MainDoor.WorkingParts.TouchToEnter
    if porta:IsA("Part") or porta:IsA("Model") then
        -- Função para teletransportar o personagem para a porta
        local function teleportarParaPorta()
            local personagem = game.Players.LocalPlayer.Character
            if personagem then
                local portaPosicao = porta.Position
                personagem:MoveTo(portaPosicao)
            else
                warn("O personagem não foi encontrado.")
                return
            end
        end

        -- Chame a função para teletransportar o personagem para a porta
        teleportarParaPorta()
        wait(1)  -- Esperar um pouco para garantir que o teleport foi concluído

        -- Função para teleportar o jogador
        local function teleportPlayer(position)
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
            end
        end
		wait(10)
        -- Função para mover o jogador para trás
        local function moveBackward(duration)
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                local startTime = tick()
                local moveDirection = -player.Character.HumanoidRootPart.CFrame.LookVector
                
                while tick() - startTime < duration do
                    humanoid:Move(moveDirection, false)
                    wait(0)
                end
                
                -- Parar movimento após o tempo
                humanoid:Move(Vector3.new(), false)
            end
        end

        -- Coordenadas para teleportar
        local teleportPosition = Vector3.new(-5.04932, 3534.82, 8077.69)

        -- Teleportar e mover
        teleportPlayer(teleportPosition)
        wait(1)  -- Esperar um pouco para garantir que o teleport foi concluído
        moveBackward(5)  -- Mover para trás por 5 segundos
    else
        warn("A porta não é um objeto válido para interagir.")
    end
end

-- Função para teletransportar para as moedas e, em seguida, para LegendaryChest
local function teleportToCoinsAndThenLegendaryChest()
    print("Iniciando teleporte para Coins.")
    teleportToCoins()
    wait(0.3)
    print("Iniciando teleporte para LegendaryChest.")
    teleportToLegendaryChest()
    wait(10)
    backevent()
end

local function checkIfEventStarted()
    local eventStartPosition = Vector3.new(16029.02734375, 7894.48828125, 16013.0146484375)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local distanceToEventStart = (humanoidRootPart.Position - eventStartPosition).Magnitude

    if distanceToEventStart <= 100 then
        print("O evento começou. Teleportando em 3 segundos.")
        wait(3)
        teleportToCoinsAndThenLegendaryChest()
    else
        print("Aguardando o início do evento. Distância: " .. distanceToEventStart)
    end
end

local function continuouslyCheckForEventStart()
    while true do
        checkIfEventStarted()
        wait(1)
    end
end

startgame()
wait(5)
-- Chama a função backevent no início para teleportar o jogador para o barco
backevent()

-- Inicia a verificação contínua do início do evento
continuouslyCheckForEventStart()
