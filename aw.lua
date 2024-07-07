







local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local TextButton_2 = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local TextButton_3 = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local TextButton_4 = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local TextLabel_2 = Instance.new("TextLabel")
local TextButton_5 = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.0863309354, 0, 0.230769232, 0)
Frame.Size = UDim2.new(0, 325, 0, 325)
Frame.Draggable = true
Frame.Active = true

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(102, 0, 0)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(0, 325, 0, 34)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "AIMWARE"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
TextLabel.Draggable = true


TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(102, 0, 0)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0714285746, 0, 0.183193952, 0)
TextButton.Size = UDim2.new(0, 275, 0, 33)
TextButton.Font = Enum.Font.SourceSansBold
TextButton.Text = "Aimbot [Q]"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
TextButton.MouseButton1Click:Connect(function()
    getgenv().OldAimPart = "HumanoidRootPart"
    getgenv().AimPart = "HumanoidRootPart" -- For R15 Games: {UpperTorso, LowerTorso, HumanoidRootPart, Head} | For R6 Games: {Head, Torso, HumanoidRootPart}  
    getgenv().AimlockKey = "q" -- change to whatever you want, make sure it's lowercase
    getgenv().AimRadius = 325 -- How far away from someone's character you want to lock on at
    getgenv().ThirdPerson = true 
    getgenv().FirstPerson = true
    getgenv().TeamCheck = false
    getgenv().PredictMovement = true
    getgenv().PredictionVelocity = 6.18
    getgenv().CheckIfJumped = true
    getgenv().Smoothness = true 
    getgenv().SmoothnessAmount = 0.05 
    

    local function lerp(a, b, t)
        return a + (b - a) * t
    end
    
    -- Function to smoothly adjust camera position
    local function smoothCamera(targetPosition)
        local currentPosition = game.Workspace.CurrentCamera.CFrame.p
        local smoothness = getgenv().SmoothnessAmount
        local newPosition = Vector3.new(
            lerp(currentPosition.X, targetPosition.X, smoothness),
            lerp(currentPosition.Y, targetPosition.Y, smoothness),
            lerp(currentPosition.Z, targetPosition.Z, smoothness)
        )
        return CFrame.new(newPosition)
    end
    
    -- Example usage:
    local targetPosition = Vector3.new(10, 0, 10) -- Replace this with the actual target position
    game.Workspace.CurrentCamera.CFrame = smoothCamera(targetPosition)

	local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
	local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
	local Aimlock, MousePressed, CanNotify = true, false, false;
	local AimlockTarget;
	local OldPre;



	getgenv().WorldToViewportPoint = function(P)
		return Camera:WorldToViewportPoint(P)
	end

	getgenv().WorldToScreenPoint = function(P)
		return Camera.WorldToScreenPoint(Camera, P)
	end

	getgenv().GetObscuringObjects = function(T)
		if T and T:FindFirstChild(getgenv().AimPart) and Client and Client.Character:FindFirstChild("Head") then 
			local RayPos = workspace:FindPartOnRay(RNew(
				T[getgenv().AimPart].Position, Client.Character.Head.Position)
			)
			if RayPos then return RayPos:IsDescendantOf(T) end
		end
	end

	getgenv().GetNearestTarget = function()
		-- Credits to whoever made this, i didnt make it, and my own mouse2plr function kinda sucks
		local players = {}
		local PLAYER_HOLD  = {}
		local DISTANCES = {}
		for i, v in pairs(Players:GetPlayers()) do
			if v ~= Client then
				table.insert(players, v)
			end
		end
		for i, v in pairs(players) do
			if v.Character ~= nil then
				local AIM = v.Character:FindFirstChild("Head")
				if getgenv().TeamCheck == true and v.Team ~= Client.Team then
					local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
					local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
					local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
					local DIFF = math.floor((POS - AIM.Position).magnitude)
					PLAYER_HOLD[v.Name .. i] = {}
					PLAYER_HOLD[v.Name .. i].dist= DISTANCE
					PLAYER_HOLD[v.Name .. i].plr = v
					PLAYER_HOLD[v.Name .. i].diff = DIFF
					table.insert(DISTANCES, DIFF)
				elseif getgenv().TeamCheck == false and v.Team == Client.Team then 
					local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
					local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
					local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
					local DIFF = math.floor((POS - AIM.Position).magnitude)
					PLAYER_HOLD[v.Name .. i] = {}
					PLAYER_HOLD[v.Name .. i].dist= DISTANCE
					PLAYER_HOLD[v.Name .. i].plr = v
					PLAYER_HOLD[v.Name .. i].diff = DIFF
					table.insert(DISTANCES, DIFF)
				end
			end
		end

		if unpack(DISTANCES) == nil then
			return nil
		end

		local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
		if L_DISTANCE > getgenv().AimRadius then
			return nil
		end

		for i, v in pairs(PLAYER_HOLD) do
			if v.diff == L_DISTANCE then
				return v.plr
			end
		end
		return nil
	end

	Mouse.KeyDown:Connect(function(a)
		if not (Uis:GetFocusedTextBox()) then 
			if a == AimlockKey and AimlockTarget == nil then
				pcall(function()
					if MousePressed ~= true then MousePressed = true end 
					local Target;Target = GetNearestTarget()
					if Target ~= nil then 
						AimlockTarget = Target
					end
				end)
			elseif a == AimlockKey and AimlockTarget ~= nil then
				if AimlockTarget ~= nil then AimlockTarget = nil end
				if MousePressed ~= false then 
					MousePressed = false 
				end
			end
		end
	end)

	RService.RenderStepped:Connect(function()
		if getgenv().ThirdPerson == true and getgenv().FirstPerson == true then 
			if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
				CanNotify = true 
			else 
				CanNotify = false 
			end
		elseif getgenv().ThirdPerson == true and getgenv().FirstPerson == false then 
			if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
				CanNotify = true 
			else 
				CanNotify = false 
			end
		elseif getgenv().ThirdPerson == false and getgenv().FirstPerson == true then 
			if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
				CanNotify = true 
			else 
				CanNotify = false 
			end
		end
		if Aimlock == true and MousePressed == true then 
			if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(getgenv().AimPart) then 
				if getgenv().FirstPerson == true then
					if CanNotify == true then
						if getgenv().PredictMovement == true then
							if getgenv().Smoothness == true then
								--// The part we're going to lerp/smoothen \\--
								local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)

								--// Making it work \\--
								Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)
							else
								Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
							end
						elseif getgenv().PredictMovement == false then 
							if getgenv().Smoothness == true then
								--// The part we're going to lerp/smoothen \\--
								local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)

								--// Making it work \\--
								Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)
							else
								Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
							end
						end
					end
				end
			end
		end
		if CheckIfJumped == true then
			if AimlockTarget.Character.HuDDDDDDDDDDWmanoid.FloorMaterial == Enum.Material.Air then

				getgenv().AimPart = "UpperTorso"
			else
				getgenv().AimPart = getgenv().OldAimPart

			end
		end
	end)

	--by yeslidez_vzx
end)
-- Instances for Slider:
local SliderLabel = Instance.new("TextLabel")
local Slider = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")

-- Properties for Slider:
SliderLabel.Parent = Frame
SliderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.BackgroundTransparency = 1.000
SliderLabel.Position = UDim2.new(0.071, 0, 0.5, 0)
SliderLabel.Size = UDim2.new(0, 275, 0, 25)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.Text = "Smoothness: 0"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.TextScaled = true
SliderLabel.TextSize = 14.000
SliderLabel.TextWrapped = true

Slider.Parent = Frame
Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Slider.BorderSizePixel = 0
Slider.Position = UDim2.new(0.071, 0, 0.6, 0)
Slider.Size = UDim2.new(0, 275, 0, 10)

SliderButton.Parent = Slider
SliderButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
SliderButton.BorderSizePixel = 0
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0, 0, -0.5, 0)
UICorner_6.Parent = SliderButton

-- Smoothness Slider functionality:
local function updateSmoothnessValue()
    local relativeX = SliderButton.Position.X.Scale
    local smoothnessValue
    if relativeX == 1 then
        smoothnessValue = "SHAKE"
    else
        smoothnessValue = math.floor(relativeX * 60)
    end
    SliderLabel.Text = "Smoothness: " .. smoothnessValue
    if relativeX == 1 then
        getgenv().SmoothnessAmount = 100 -- Set to a large value for infinite smoothing
    else
        getgenv().SmoothnessAmount = smoothnessValue / 100
    end
end

SliderButton.MouseButton1Down:Connect(function()
    local userInput = game:GetService("UserInputService")

    local function moveInput(input)
        local delta = input.Position.X - Slider.AbsolutePosition.X
        local newScale = math.clamp(delta / Slider.AbsoluteSize.X, 0, 1)
        SliderButton.Position = UDim2.new(newScale, 0, SliderButton.Position.Y.Scale, 0)
        updateSmoothnessValue()
    end



    local moveConnection, releaseConnection

    moveConnection = userInput.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            moveInput(input)
        end
    end)

    releaseConnection = userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            moveConnection:Disconnect()
            releaseConnection:Disconnect()
        end
    end)
end)

-- Instances:
local ScreenGui = Instance.new("ScreenGui")
local guiEnabled = false

-- Function to create GUI elements:
local function createGui()
    -- Create your GUI elements here
    -- For example:
    -- local guiButton = Instance.new("TextButton")
    -- guiButton.Parent = ScreenGui
    -- guiButton.Text = "Click me"
    -- guiButton.Position = UDim2.new(0, 100, 0, 100)
    -- guiButton.Size = UDim2.new(0, 100, 0, 50)
    -- guiButton.MouseButton1Click:Connect(function()
    --     print("Button clicked!")
    -- end)
end

-- Function to toggle GUI visibility:
local function toggleGui()
    guiEnabled = not guiEnabled
    if guiEnabled then
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        print("GUI enabled")
    else
        ScreenGui.Parent = nil
        print("GUI disabled")
    end
end

-- Input listener for the "V" key:
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        toggleGui()
    end
end)


TextLabel_2.Parent = Frame
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.0155843757, 0, 0.80334729, 0)
TextLabel_2.Size = UDim2.new(0, 308, 0, 49)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "I DO NOT OWN AIMWARE.NET, THIS IS NOT THE REAL AIMWARE"
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextSize = 14.000
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left