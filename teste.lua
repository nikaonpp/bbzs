local active = false  -- Variável para controlar se o código está ativo ou não

-- Função para criar o botão na tela
local function createButton()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Criar uma nova tela GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui
    screenGui.Name = "ControlButtonGui"

    -- Criar um botão
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 50)  -- Tamanho do botão
    button.Position = UDim2.new(1, -160, 1, -60)  -- Posição no canto inferior direito
    button.AnchorPoint = Vector2.new(1, 1)  -- Âncora no canto inferior direito
    button.Text = "Ativar"  -- Texto inicial do botão
    button.BackgroundColor3 = Color3.new(0, 1, 0)  -- Cor verde para indicar inativo
    button.Parent = screenGui
    
-- Função para alternar o estado do código
local function toggleCode()
    active = not active  -- Alternar o estado
    if active then
        button.Text = "Parar"
        button.BackgroundColor3 = Color3.new(1, 0, 0)  -- Cor vermelha para indicar ativo
        print("Código ativado")
        backevent()

        -- Usar coroutines para executar funções em paralelo
        local co1 = coroutine.create(continuouslyCheckForEventStart)
        local co2 = coroutine.create(checkTimerLabelContinuously)
        
        coroutine.resume(co1)
        coroutine.resume(co2)
    else
        button.Text = "Ativar"
        button.BackgroundColor3 = Color3.new(0, 1, 0)  -- Cor verde para indicar inativo
        print("Código parado")
    end
end
    
    -- Conectar a função de alternância ao clique no botão
    button.MouseButton1Click:Connect(toggleCode)
end

-- Função para teletransportar o jogador de volta para o barco
function backevent()
    if not active then return end  -- Verificar se o código está ativo
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    local targetPosition = Vector3.new(-350.322, 32.2789, -1413.78)
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    print("Voltando para o barco")
end

-- Função para teletransportar o jogador para a posição das moedas
local function flyToCoins()
    if not active then return end  -- Verificar se o código está ativo
    local collectibles = game:GetService("Workspace"):GetDescendants()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local flySpeed = 450  -- Velocidade do fly
    local itemFound = false
    local startTime = tick()  -- Marca o início da função

    -- Desabilita a colisão de todos os itens que não sejam Coin, LegendaryChest ou Chest
    for _, item in pairs(collectibles) do
        if item:IsA("BasePart") then
            if item.Name ~= "Coin" and item.Name ~= "LegendaryChest" and item.Name ~= "Chest" then
                item.CanCollide = false  -- Remove a colisão
            else
                item.CanCollide = true   -- Mantém a colisão para Coin, LegendaryChest e Chest
            end
        end
    end

    -- Teletransporta o jogador para as Coins
    for _, item in pairs(collectibles) do
        -- Verifica se já passou mais de 90 segundos
        if tick() - startTime > 90 then
            print("Tempo limite de 90 segundos atingido, interrompendo a coleta.")
            break
        end

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

                -- Verifica se o tempo limite foi atingido durante o movimento
                if tick() - startTime > 90 then
                    print("Tempo limite de 90 segundos atingido, interrompendo a coleta.")
                    break
                end
            end
            wait(0.3)  -- Pequena pausa antes de ir para a próxima coin
        end
    end

    if not itemFound then
        print("Nenhuma moeda encontrada.")
    end
end

-- Função para voar até LegendaryChest
local function flyToLegendaryChest()
    if not active then return end  -- Verificar se o código está ativo
    local collectibles = game:GetService("Workspace"):GetDescendants()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local flySpeed = 450  -- Velocidade do fly
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
            backevent()
        end
    end

    if not itemFound then
        print("Nenhum LegendaryChest encontrado.")
    end
end

local function teleportToCoinsAndThenLegendaryChest()
    if not active then return end  -- Verificar se o código está ativo
    print("Iniciando teleporte para Coins.")
    flyToCoins()
    wait(0.3)
    backevent()
end

function checkIfEventStarted()
    if not active then return end  -- Verificar se o código está ativo
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

function continuouslyCheckForEventStart()
    while active do  -- Verificar se o código está ativo
        checkIfEventStarted()
        wait(1)
    end
end

-- Função para checar o TimerLabel e executar o comando se o tempo estiver entre 4 e 17 minutos
local function checkTimerLabel()
    if not active then return end  -- Verificar se o código está ativo

    local paths = {"MainMap/Default", "MainMap!Default"}
    local label

    -- Tenta acessar o TimerLabel nos caminhos especificados
    for _, path in ipairs(paths) do
        local success, result = pcall(function()
            return game:GetService("Workspace").Interiors[path].Event.Ocean2024Exterior.JoinZone.Billboard.BillboardGui.TimerLabel
        end)

        if success and result then
            label = result
            break
        end
    end

    -- Verifica se encontrou o TimerLabel
    if label and string.find(label.Text, ":") then
        -- Extrai o tempo restante do texto
        local timeRemaining = string.match(label.Text, "%d%d:%d%d")
        
        -- Divide o tempo em minutos e segundos
        local minutes, seconds = string.match(timeRemaining, "(%d%d):(%d%d)")
        minutes = tonumber(minutes)
        seconds = tonumber(seconds)

        -- Mostra o tempo no console
        print("Tempo restante:", minutes .. ":" .. seconds)

        -- Se o tempo estiver entre 4 e 17 minutos, executa a compra
        if minutes >= 4 and minutes < 17 then
            print("Tentando realizar a compra no jogo...")
            game:GetService("ReplicatedStorage").API:FindFirstChild("OceanAPI/AttemptPurchaseDive"):InvokeServer()
        elseif minutes < 4 then
            print("Tempo menor que 4 minutos, aguardando.")
        elseif minutes >= 17 then
            print("Tempo maior que 17 minutos, aguardando.")
        end
    else
        print("TimerLabel não encontrado ou não corresponde ao padrão.")
    end
end

-- Função para checar o TimerLabel continuamente a cada 30 segundos
function checkTimerLabelContinuously()
    while active do
        checkTimerLabel()
        wait(30)  -- Intervalo de 30 segundos
    end
end






-- Criar o botão ao iniciar o código
createButton()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/ReQiuYTPL/hub/main/ReQiuYTPLHub.lua'), true))()
-- Script para esconder ou mostrar elementos
-- Função inicial executada ao iniciar o script
if _G.hideUnHide then
    _G.hideUnHide()
end

-- Criando um botão na tela para executar a função novamente
local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")

-- Propriedades da ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Propriedades do TextButton
TextButton.Parent = ScreenGui
TextButton.Text = "Toggle Hide/UnHide"
TextButton.Size = UDim2.new(0, 200, 0, 50)
TextButton.Position = UDim2.new(1, -210, 1, -60)  -- Alinhado à direita e 60 pixels acima do fundo
TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Font = Enum.Font.SourceSans
TextButton.TextSize = 24

-- Função ao clicar no botão
TextButton.MouseButton1Click:Connect(function()
    if _G.hideUnHide then
        _G.hideUnHide()
    end
end)

