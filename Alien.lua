local ALIENUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

local function GetAsset(url, fileName)
    if not isfile(fileName) then
        if request then
            local response = request({Url = url, Method = "GET"})
            if response.Success then writefile(fileName, response.Body) end
        else
            writefile(fileName, game:HttpGet(url))
        end
    end
    return getcustomasset(fileName)
end

function ALIENUI:CreateWindow(Config)
    local Window = {}
    local ThemeColor = Config.SelectBackground == "Meguna" and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 105, 180)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ALIEN_UI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    ToggleBtn.Text = Config.ToggleName or "ALIEN"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToggleBtn.TextColor3 = ThemeColor
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
    ToggleStroke.Color = ThemeColor
    ToggleStroke.Thickness = 2
    ToggleBtn.Parent = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(450, 320)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.BackgroundTransparency = 0.2

    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "ALIEN UI"
    TitleLabel.TextColor3 = ThemeColor
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ResizeHandle = Instance.new("Frame", MainFrame)
    ResizeHandle.Size = UDim2.new(0, 12, 0, 12)
    ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ResizeHandle.ZIndex = 10
    Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(1, 0)
    local ResizeStroke = Instance.new("UIStroke", ResizeHandle)
    ResizeStroke.Color = Color3.fromRGB(100, 100, 100)
    ResizeStroke.Thickness = 1

    local Background = Instance.new("ImageLabel", MainFrame)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundTransparency = 1
    Background.ImageTransparency = Config.BackgroundImageTransparency or 0.6
    Background.ScaleType = Enum.ScaleType.Crop
    Background.ZIndex = 0

    if Config.SelectBackground == "Astolfo" then
        task.spawn(function()
            local assetId = GetAsset("https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Roblox/refs/heads/main/TSB/Stuff/Utility/Techs/spritesheet-table-320-240%20(1).png", "femboy_anim_new.png")
            Background.Image = assetId
            Background.ImageRectSize = Vector2.new(320, 240)
            local cols, totalFrames = 9, (8 * 9) + 6 
            while true do
                for i = 0, totalFrames - 1 do
                    local curCol = i % cols
                    local curRow = math.floor(i / cols)
                    Background.ImageRectOffset = Vector2.new(curCol * 320, curRow * 240)
                    task.wait(1/12)
                end
            end
        end)
    end

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 130, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Sidebar.BackgroundTransparency = 0.4
    local SidebarList = Instance.new("UIListLayout", Sidebar)
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -135, 1, -40)
    ContentArea.Position = UDim2.new(0, 135, 0, 40)
    ContentArea.BackgroundTransparency = 1

    local function MakeResizeable(handle, target)
        local dragging, startPos, startSize
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startPos = input.Position
                startSize = target.Size
                TweenService:Create(handle, TweenInfo.new(0.2), {BackgroundColor3 = ThemeColor, Size = UDim2.new(0, 16, 0, 16)}):Play()
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - startPos
                target.Size = UDim2.new(0, math.max(350, startSize.X.Offset + delta.X), 0, math.max(250, startSize.Y.Offset + delta.Y))
                handle.Position = UDim2.new(1, -15, 1, -15)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                TweenService:Create(handle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), Size = UDim2.new(0, 12, 0, 12)}):Play()
            end
        end)
    end
    MakeResizeable(ResizeHandle, MainFrame)

    local function MakeDraggable(gui)
        local dragToggle, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and input.Position.Y < (gui.AbsolutePosition.Y + 40) then
                dragToggle = true
                dragStart = input.Position
                startPos = gui.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            dragToggle = false
        end)
    end
    MakeDraggable(MainFrame)

    ToggleBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local Tabs = {}
    local FirstTab = true

    function Window:Tab(opts)
        local Tab = {}
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = FirstTab and 0 or 1
        TabBtn.Text = opts.Title
        TabBtn.TextColor3 = FirstTab and ThemeColor or Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local TabContainer = Instance.new("ScrollingFrame", ContentArea)
        TabContainer.Size = UDim2.new(1, -5, 1, 0)
        TabContainer.BackgroundTransparency = 1
        TabContainer.Visible = FirstTab
        TabContainer.ScrollBarThickness = 0
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        local List = Instance.new("UIListLayout", TabContainer)
        List.Padding = UDim.new(0, 6)
        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10)
        end)

        table.insert(Tabs, {Btn = TabBtn, Container = TabContainer})
        FirstTab = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Container.Visible = false
                t.Btn.BackgroundTransparency = 1
                t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            TabContainer.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = ThemeColor
        end)

        function Tab:Section(sOpts)
            local Sec = Instance.new("TextLabel", TabContainer)
            Sec.Size = UDim2.new(1, -10, 0, 20)
            Sec.BackgroundTransparency = 1
            Sec.Text = sOpts.Title:upper()
            Sec.TextColor3 = ThemeColor
            Sec.Font = Enum.Font.GothamBold
            Sec.TextSize = 11
            Sec.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:Button(bOpts)
            local Btn = Instance.new("TextButton", TabContainer)
            Btn.Size = UDim2.new(1, -10, 0, 32)
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Btn.Text = bOpts.Title
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
            Btn.MouseButton1Click:Connect(function()
                if bOpts.Callback then bOpts.Callback() end
            end)
        end

        function Tab:Paragraph(pOpts)
            local PFrame = Instance.new("Frame", TabContainer)
            PFrame.Size = UDim2.new(1, -10, 0, 0)
            PFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            PFrame.AutomaticSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", PFrame).CornerRadius = UDim.new(0, 5)
            local UIList = Instance.new("UIListLayout", PFrame)
            UIList.Padding = UDim.new(0, 2)
            UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            local Title = Instance.new("TextLabel", PFrame)
            Title.Size = UDim2.new(1, -16, 0, 20)
            Title.BackgroundTransparency = 1
            Title.Text = pOpts.Title
            Title.TextColor3 = ThemeColor
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left
            local Desc = Instance.new("TextLabel", PFrame)
            Desc.Size = UDim2.new(1, -16, 0, 0)
            Desc.AutomaticSize = Enum.AutomaticSize.Y
            Desc.BackgroundTransparency = 1
            Desc.Text = pOpts.Desc
            Desc.TextColor3 = Color3.fromRGB(180, 180, 180)
            Desc.Font = Enum.Font.Gotham
            Desc.TextSize = 11
            Desc.TextWrapped = true
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UIPadding", PFrame).PaddingTop = UDim.new(0, 5)
            Instance.new("UIPadding", PFrame).PaddingBottom = UDim.new(0, 5)
        end

        function Tab:Toggle(tOpts)
            local TogFrame = Instance.new("Frame", TabContainer)
            TogFrame.Size = UDim2.new(1, -10, 0, 32)
            TogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 5)
            local Label = Instance.new("TextLabel", TogFrame)
            Label.Size = UDim2.new(1, -45, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = tOpts.Title
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            local Switch = Instance.new("TextButton", TogFrame)
            Switch.Size = UDim2.new(0, 28, 0, 14)
            Switch.Position = UDim2.new(1, -38, 0.5, -7)
            Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Switch.Text = ""
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
            local Dot = Instance.new("Frame", Switch)
            Dot.Size = UDim2.new(0, 10, 0, 10)
            Dot.Position = UDim2.new(0, 2, 0.5, -5)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
            local state = tOpts.Default or false
            local function update()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = state and ThemeColor or Color3.fromRGB(50, 50, 50)}):Play()
                if tOpts.Callback then tOpts.Callback(state) end
            end
            update()
            Switch.MouseButton1Click:Connect(function() state = not state; update() end)
        end

        return Tab
    end

    function Window:Notify(opts) end
    return Window
end

return ALIENUI
