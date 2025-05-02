local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "VuSlothGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.4, 0, 0.75, 0) -- Gần 4:3
frame.Position = UDim2.new(0.3, 0, 0.125, 0)
frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
frame.Visible = true
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Toggle Button (VuSloth)
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 120, 0, 35)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "VuSloth"
toggleButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19) -- Màu nâu nhạt
toggleButton.TextColor3 = Color3.new(0, 0, 0) -- Màu đen
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 22

local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(0, 8)

toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Font helper
local function createButton(text, position, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.4, 0, 0, 40)
    btn.Position = position
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 20
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Features
local infiniteJumpEnabled = false
local noclip = false
local freeze = false
local setPos = nil
local espEnabled = false

-- Infinite Jump Logic
local infJumpButton

local function onInfJumpButtonClick()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infJumpButton then
        infJumpButton.Text = infiniteJumpEnabled and "InfJump On" or "InfJump Off"
    end
end

UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- NoClip Logic
local noclipButton
local function onNoClipButtonClick()
    noclip = not noclip
    if noclipButton then
        noclipButton.Text = noclip and "NoClip On" or "NoClip Off"
    end
end

runService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    elseif not noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == false then
                v.CanCollide = true
            end
        end
    end
end)

-- ESP
local function toggleESP()
    espEnabled = not espEnabled
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            if espEnabled then
                local billboard = Instance.new("BillboardGui", p.Character:FindFirstChild("Head"))
                billboard.Name = "VuESP"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.AlwaysOnTop = true
                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = p.Name
                label.Font = Enum.Font.Gotham
                label.TextColor3 = Color3.new(0, 0, 0) -- Màu đen cho chữ ESP
                label.BackgroundTransparency = 1
            else
                if p.Character:FindFirstChild("Head") then
                    local old = p.Character.Head:FindFirstChild("VuESP")
                    if old then old:Destroy() end
                end
            end
        end
    end
end

-- Buttons
local y = 20
local spacing = 50

infJumpButton = createButton("InfJump Off", UDim2.new(0.05, 0, 0, y), onInfJumpButtonClick)

noclipButton = createButton("NoClip Off", UDim2.new(0.05, 0, 0, y + spacing), onNoClipButtonClick)

createButton("Freeze", UDim2.new(0.05, 0, 0, y + spacing * 2), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        freeze = not freeze
        if freeze then
            player.Character.HumanoidRootPart.Anchored = true
        else
            player.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

createButton("ESP", UDim2.new(0.05, 0, 0, y + spacing * 3), function()
    toggleESP()
end)

createButton("Set Point", UDim2.new(0.55, 0, 0, y), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        setPos = player.Character.HumanoidRootPart.Position
    end
end)

createButton("Teleport", UDim2.new(0.55, 0, 0, y + spacing), function()
    if setPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(setPos)
    end
end)

-- Speed section
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0.4, 0, 0, 35)
speedBox.Position = UDim2.new(0.55, 0, 0, y + spacing * 2)
speedBox.PlaceholderText = "Enter Speed" -- Đã đổi từ ............ thành Enter Speed
speedBox.Font = Enum.Font.Gotham
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

local speedButton = createButton("Set Speed", UDim2.new(0.55, 0, 0, y + spacing * 3), function()
    local value = tonumber(speedBox.Text)
    if value and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)
