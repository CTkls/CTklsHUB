local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- LOADING SCREEN
local loadingGui = Instance.new("ScreenGui", playerGui)
loadingGui.Name = "LoadingKLS"
loadingGui.ResetOnSpawn = false

local loadingFrame = Instance.new("Frame", loadingGui)
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Text = "Carregando CTkls"
loadingText.Size = UDim2.new(0.5, 0, 0.1, 0)
loadingText.Position = UDim2.new(0.25, 0, 0.45, 0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.SourceSansBold

task.wait(3)
loadingGui:Destroy()

-- MENU GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "⚡CTkls⚡"
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("ImageButton", screenGui)
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Image = "rbxassetid://17308821593"
toggleButton.BackgroundTransparency = 1

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainMenu"
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0, 70, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

local title = Instance.new("TextLabel", mainFrame)
title.Text = "⚡CTkls⚡"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- DRAG FUNCTION
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- CONSTANTES PADRÃO
local JUMP_POWER_BASE = 50
local WALK_SPEED_BASE = 16

-- SUPER PULO
local superJump = false
local jumpPercent = 100

local jumpLabel = Instance.new("TextLabel", mainFrame)
jumpLabel.Text = "Super Pulo: 100%"
jumpLabel.Size = UDim2.new(1, -20, 0, 30)
jumpLabel.Position = UDim2.new(0, 10, 0, 50)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpLabel.TextScaled = true
jumpLabel.Font = Enum.Font.SourceSansBold

local jumpToggle = Instance.new("TextButton", mainFrame)
jumpToggle.Text = "Ligar/Desligar"
jumpToggle.Size = UDim2.new(1, -20, 0, 30)
jumpToggle.Position = UDim2.new(0, 10, 0, 85)
jumpToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpToggle.Font = Enum.Font.SourceSansBold
jumpToggle.TextScaled = true
local jc = Instance.new("UICorner", jumpToggle)
jc.CornerRadius = UDim.new(0, 6)

local jumpMinus = Instance.new("TextButton", mainFrame)
jumpMinus.Text = "-"
jumpMinus.Size = UDim2.new(0, 40, 0, 30)
jumpMinus.Position = UDim2.new(0, 10, 0, 120)
jumpMinus.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
jumpMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpMinus.TextScaled = true
jumpMinus.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", jumpMinus).CornerRadius = UDim.new(0, 6)

local jumpPlus = Instance.new("TextButton", mainFrame)
jumpPlus.Text = "+"
jumpPlus.Size = UDim2.new(0, 40, 0, 30)
jumpPlus.Position = UDim2.new(1, -50, 0, 120)
jumpPlus.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
jumpPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpPlus.TextScaled = true
jumpPlus.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", jumpPlus).CornerRadius = UDim.new(0, 6)

local function updateJump()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if superJump then
			humanoid.JumpPower = JUMP_POWER_BASE * (jumpPercent / 100)
		else
			humanoid.JumpPower = JUMP_POWER_BASE
		end
	end
	jumpLabel.Text = "Super Pulo: " .. jumpPercent .. "%"
end

jumpToggle.MouseButton1Click:Connect(function()
	superJump = not superJump
	updateJump()
	jumpToggle.BackgroundColor3 = superJump and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(70, 130, 180)
end)

jumpMinus.MouseButton1Click:Connect(function()
	if jumpPercent > 50 then
		jumpPercent = jumpPercent - 10
		if superJump then updateJump() end
	end
end)

jumpPlus.MouseButton1Click:Connect(function()
	if jumpPercent < 200 then
		jumpPercent = jumpPercent + 10
		if superJump then updateJump() end
	end
end)

updateJump()

-- SUPER VELOCIDADE
local superSpeed = false
local speedPercent = 100

local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Text = "Super Velocidade: 100%"
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 170)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSansBold

local speedToggle = Instance.new("TextButton", mainFrame)
speedToggle.Text = "Ligar/Desligar"
speedToggle.Size = UDim2.new(1, -20, 0, 30)
speedToggle.Position = UDim2.new(0, 10, 0, 205)
speedToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.Font = Enum.Font.SourceSansBold
speedToggle.TextScaled = true
local sc = Instance.new("UICorner", speedToggle)
sc.CornerRadius = UDim.new(0, 6)

local speedMinus = Instance.new("TextButton", mainFrame)
speedMinus.Text = "-"
speedMinus.Size = UDim2.new(0, 40, 0, 30)
speedMinus.Position = UDim2.new(0, 10, 0, 240)
speedMinus.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
speedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
speedMinus.TextScaled = true
speedMinus.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", speedMinus).CornerRadius = UDim.new(0, 6)

local speedPlus = Instance.new("TextButton", mainFrame)
speedPlus.Text = "+"
speedPlus.Size = UDim2.new(0, 40, 0, 30)
speedPlus.Position = UDim2.new(1, -50, 0, 240)
speedPlus.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
speedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
speedPlus.TextScaled = true
speedPlus.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", speedPlus).CornerRadius = UDim.new(0, 6)

local function updateSpeed()
	local char = player.Character or player.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if superSpeed then
			humanoid.WalkSpeed = WALK_SPEED_BASE * (speedPercent / 100)
		else
			humanoid.WalkSpeed = WALK_SPEED_BASE
		end
	end
	speedLabel.Text = "Super Velocidade: " .. speedPercent .. "%"
end

speedToggle.MouseButton1Click:Connect(function()
	superSpeed = not superSpeed
	updateSpeed()
	speedToggle.BackgroundColor3 = superSpeed and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(70, 130, 180)
end)

speedMinus.MouseButton1Click:Connect(function()
	if speedPercent > 50 then
		speedPercent = speedPercent - 10
		if superSpeed then updateSpeed() end
	end
end)

speedPlus.MouseButton1Click:Connect(function()
	if speedPercent < 200 then
		speedPercent = speedPercent + 10
		if superSpeed then updateSpeed() end
	end
end)

updateSpeed()