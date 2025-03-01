local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
local textLabel = Instance.new("TextLabel")

screenGui.Parent = game.CoreGui
screenGui.DisplayOrder = 1000000000000000000

textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 250, 0, 40)
textLabel.Position = UDim2.new(0, 10, 0, 10)
textLabel.Font = Enum.Font.FredokaOne
textLabel.TextScaled = true
textLabel.BackgroundTransparency = 1
textLabel.TextStrokeTransparency = 0

local function rainbowColor()
    local dreamon = 0
    while not getgenv().StopUpdate do
        dreamon = (dreamon + 0.01) % 1
        textLabel.TextColor3 = Color3.fromHSV(dreamon, 1, 1)
        RunService.RenderStepped:Wait()
    end
end

local frameCount = 0
local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()

    if now - lastUpdate >= 1 then
        local fps = frameCount / (now - lastUpdate)
        frameCount = 0
        lastUpdate = now

        local userName = LocalPlayer.Name
        textLabel.Text = string.format("%s, FPS: %d", userName, math.floor(fps))
    end
end)

task.spawn(rainbowColor)

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local os_time = os.time()

getgenv().StopUpdate = false

GuiService.ErrorMessageChanged:Connect(function()
    local errorMessage = GuiService:GetErrorMessage() -- Use proper method if available
    if errorMessage and string.find(errorMessage, "disconnected") then
        getgenv().StopUpdate = true
    end
end)

local function writeExecutorStatus(status)
    local username = LocalPlayer.Name -- Get the player's username
    pcall(function()
        writefile("executor_check_" .. username .. ".txt", status .. ":" .. os.time())
    end)
end

writeExecutorStatus("working")

task.spawn(function()
    while not getgenv().StopUpdate do
        wait(1)
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts") then
            writeExecutorStatus("working")
        end
    end
end)
