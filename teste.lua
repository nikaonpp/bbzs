-- Função para teletransportar o jogador para a posição das moedas
local function flyToCoins()
    local collectibles = game:GetService("Workspace"):GetDescendants()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local flySpeed = 100  -- Velocidade do fly
    local itemFound = false

    for _, item in pairs(collectibles) do
        if item.Name == "Coin" and item:IsA("BasePart") then
            itemFound = true
            print("Indo em direção à Coin: ", item.Name)

            -- Calcula a direção do fly em relação à coin
            local direction = (item.Position - humanoidRootPart.Position).unit
            local distance = (item.Position - humanoidRootPart.Position).magnitude

            -- Move o personagem em direção à Coin
            while distance > 5 do  -- Aproxima-se até estar a 5 unidades de distância
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + direction * flySpeed * game:GetService("RunService").Heartbeat:Wait()
                distance = (item.Position - humanoidRootPart.Position).magnitude
            end
            wait(0.2)  -- Pequena pausa antes de ir para a próxima coin
        end
    end

    if not itemFound then
        print("Nenhuma moeda encontrada.")
    end
end

-- Função para voar até LegendaryChest
local function flyToLegendaryChest()
    local collectibles = game:GetService("Workspace"):GetDescendants()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local flySpeed = 100  -- Velocidade do fly
    local itemFound = false

    for _, item in pairs(collectibles) do
        if item.Name == "LegendaryChest" and item:IsA("BasePart") then
            itemFound = true
            print("Indo em direção ao LegendaryChest: ", item.Name)

            -- Calcula a direção do fly em relação ao LegendaryChest
            local direction = (item.Position - humanoidRootPart.Position).unit
            local distance = (item.Position - humanoidRootPart.Position).magnitude

            -- Move o personagem em direção ao LegendaryChest
            while distance > 5 do  -- Aproxima-se até estar a 5 unidades de distância
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + direction * flySpeed * game:GetService("RunService").Heartbeat:Wait()
                distance = (item.Position - humanoidRootPart.Position).magnitude
            end
            wait(0.2)  -- Pequena pausa antes de ir para o próximo item
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
    wait(30)
    -- Função auxiliar para encontrar um objeto com tentativas repetidas
    local function waitForObject(parent, objectName)
        local object = nil
        while not object do
            object = parent:FindFirstChild(objectName)
            if object then
                print(objectName .. " encontrado.")
            else
                warn(objectName .. " não encontrado. Tentando novamente em 3 segundos.")
                wait(3)  -- Esperar 3 segundos antes de tentar novamente
            end
        end
        return object
    end

    -- Encontre o objeto "HouseInteriors" e o personagem dinamicamente
    local workspace = game:GetService("Workspace")
    
    -- Usar a função waitForObject para procurar HouseInteriors
    local houseInteriors = waitForObject(workspace, "HouseInteriors")

    -- Usar a função waitForObject para procurar blueprint
    local blueprint = waitForObject(houseInteriors, "blueprint")

    -- Encontrar o personagem dinamicamente
    local personagem = blueprint:FindFirstChildOfClass("Model")
    while not personagem do
        warn("Personagem não encontrado. Tentando novamente em 3 segundos.")
        wait(3)
        personagem = blueprint:FindFirstChildOfClass("Model")
    end

    local personagemNome = personagem.Name
    local doors = waitForObject(personagem, "Doors")

    -- Verificar continuamente se a porta 'MainDoor' aparece
    local mainDoor = waitForObject(doors, "MainDoor")
    
    -- Aguardar 10 segundos antes de continuar após encontrar a MainDoor
    print("MainDoor encontrada. Aguardando 10 segundos para continuar...")
    wait(10)

    -- Prosseguir após encontrar e aguardar 10 segundos
    local workingParts = waitForObject(mainDoor, "WorkingParts")

    -- Encontre e renomeie o objeto NoAutoOpen para Autoopen
    local configuracao = waitForObject(workingParts:WaitForChild("Configuration"), "NoAutoOpen")
    if configuracao then
        configuracao.Name = "Autoopen"
        print("Objeto renomeado para Autoopen")
    end

    -- Encontre a porta
    local porta = waitForObject(workingParts, "TouchToEnter")
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
        wait(5)  -- Esperar um pouco para garantir que o teleport foi concluído

        -- Função para mover o personagem para frente por 3 segundos
        local function moverParaFrente()
            local personagem = game.Players.LocalPlayer.Character
            if personagem and personagem:FindFirstChild("Humanoid") then
                local humanoid = personagem.Humanoid
                local moveTime = 3  -- Tempo em segundos que o personagem andará
                local startTime = tick()  -- Marcar o tempo de início

                -- Loop para mover o personagem para frente durante o tempo especificado
                while tick() - startTime < moveTime do
                    humanoid:Move(Vector3.new(0, 0, -1))  -- Continuar movendo para frente
                    wait(0.1)  -- Pequeno intervalo para manter o movimento
                end

                humanoid:Move(Vector3.new(0, 0, 0))  -- Parar o movimento
            else
                warn("Humanoid não encontrado.")
            end
        end

        -- Chame a função para mover o personagem para frente
        moverParaFrente()

        -- Função para teleportar o jogador
        local function teleportPlayer(position)
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
            end
        end

        wait(20)

        -- Coordenadas para teleportar
        local teleportPosition = Vector3.new(-5.04932, 3534.82, 8077.69)

        -- Teleportar e mover
        teleportPlayer(teleportPosition)
        wait(1)  -- Esperar um pouco para garantir que o teleport foi concluído
    else
        warn("A porta não é um objeto válido para interagir.")
    end
end






-- Função para teletransportar para as moedas e, em seguida, para LegendaryChest
local function teleportToCoinsAndThenLegendaryChest()
    print("Iniciando teleporte para Coins.")
    flyToCoins()
    wait(0.3)
    print("Iniciando teleporte para LegendaryChest.")
    flyToLegendaryChest()
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

--startgame()
wait(20)
-- Chama a função backevent no início para teleportar o jogador para o barco
backevent()

-- Inicia a verificação contínua do início do evento
continuouslyCheckForEventStart()
