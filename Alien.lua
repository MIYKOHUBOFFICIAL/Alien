local ALIENUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

local function GetAsset(url, fileName)
    if not isfile(fileName) then
        if request then
            local response = request({Url = url, Method = "GET"})
            if response.Success then
                writefile(fileName, response.Body)
            end
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
    ScreenGui.Name = "ALIENUICustom"
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
    MainFrame.Size = Config.Size or UDim2.fromOffset(450, 350)
    MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset/2, 0.5, -MainFrame.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local Background = Instance.new("ImageLabel", MainFrame)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundTransparency = 1
    Background.ImageTransparency = Config.BackgroundImageTransparency or 0.5
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
    elseif Config.SelectBackground == "Meguna" then
        task.spawn(function()
            local assetId = GetAsset("https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/To-Me/refs/heads/main/Sukuna-table-640-480.png", "sukuna_bg.png")
            Background.Image = assetId
            Background.ImageRectSize = Vector2.new(640, 480)
            local f = 0
            while true do
                Background.ImageRectOffset = Vector2.new(f * 640, 0)
                f = (f + 1) % 36
                task.wait(1/12)
            end
        end)
    end

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, Config.SideBarWidth or 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BackgroundTransparency = 0.3
    Sidebar.ZIndex = 1

    local SidebarList = Instance.new("UIListLayout", Sidebar)
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TitleLabel = Instance.new("TextLabel", Sidebar)
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Config.Title or "ALIEN"
    TitleLabel.TextColor3 = ThemeColor
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -(Config.SideBarWidth or 130), 1, 0)
    ContentArea.Position = UDim2.new(0, Config.SideBarWidth or 130, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ZIndex = 1

    local NotificationContainer = Instance.new("Frame", ScreenGui)
    NotificationContainer.Size = UDim2.new(0, 250, 1, -20)
    NotificationContainer.Position = UDim2.new(1, -260, 0, 10)
    NotificationContainer.BackgroundTransparency = 1
    local NotifyList = Instance.new("UIListLayout", NotificationContainer)
    NotifyList.Padding = UDim.new(0, 10)
    NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom

    local function MakeDraggable(gui)
        local dragToggle, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragToggle = false
            end
        end)
    end
    MakeDraggable(MainFrame)
    MakeDraggable(ToggleBtn)

    ToggleBtn.MouseButton1Click:Connect(function()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {Size = UDim2.new(0, 40, 0, 40)}):Play()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local Tabs = {}
    local FirstTab = true

    function Window:Notify(opts)
        local Notif = Instance.new("Frame", NotificationContainer)
        Notif.Size = UDim2.new(1, 0, 0, 60)
        Notif.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Notif.BackgroundTransparency = 0.1
        Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 6)
        local Stroke = Instance.new("UIStroke", Notif)
        Stroke.Color = ThemeColor
        Stroke.Thickness = 1
        local Title = Instance.new("TextLabel", Notif)
        Title.Size = UDim2.new(1, -10, 0, 25)
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.BackgroundTransparency = 1
        Title.Text = opts.Title or "Notification"
        Title.TextColor3 = ThemeColor
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        local Desc = Instance.new("TextLabel", Notif)
        Desc.Size = UDim2.new(1, -10, 0, 25)
        Desc.Position = UDim2.new(0, 10, 0, 30)
        Desc.BackgroundTransparency = 1
        Desc.Text = opts.Desc or ""
        Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
        Desc.Font = Enum.Font.Gotham
        Desc.TextSize = 12
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Notif.Position = UDim2.new(1, 50, 0, 0)
        TweenService:Create(Notif, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(opts.Time or 3, function()
            local tw = TweenService:Create(Notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 50, 0, 0)})
            tw:Play()
            tw.Completed:Connect(function() Notif:Destroy() end)
        end)
    end

    function Window:Tab(opts)
        local Tab = {}
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = FirstTab and 0 or 1
        TabBtn.Text = opts.Title
        TabBtn.TextColor3 = FirstTab and ThemeColor or Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        local TabContainer = Instance.new("ScrollingFrame", ContentArea)
        TabContainer.Size = UDim2.new(1, -20, 1, -20)
        TabContainer.Position = UDim2.new(0, 10, 0, 10)
        TabContainer.BackgroundTransparency = 1
        TabContainer.ScrollBarThickness = 2
        TabContainer.Visible = FirstTab
        local ContainerList = Instance.new("UIListLayout", TabContainer)
        ContainerList.Padding = UDim.new(0, 8)
        table.insert(Tabs, {Btn = TabBtn, Container = TabContainer})
        FirstTab = false
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Container.Visible = false
                t.Btn.BackgroundTransparency = 1
                t.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            TabContainer.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = ThemeColor
        end)

        function Tab:Section(sOpts)
            local Sec = Instance.new("TextLabel", TabContainer)
            Sec.Size = UDim2.new(1, 0, 0, 25)
            Sec.BackgroundTransparency = 1
            Sec.Text = sOpts.Title
            Sec.TextColor3 = ThemeColor
            Sec.Font = Enum.Font.GothamBold
            Sec.TextSize = 14
            Sec.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:Button(bOpts)
            local Btn = Instance.new("TextButton", TabContainer)
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Btn.Text = bOpts.Title
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {Size = UDim2.new(0.98, 0, 0, 33)}):Play()
                if bOpts.Callback then bOpts.Callback() end
            end)
        end

        function Tab:Toggle(tOpts)
            local TogFrame = Instance.new("Frame", TabContainer)
            TogFrame.Size = UDim2.new(1, 0, 0, 35)
            TogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", TogFrame).CornerRadius = UDim.new(0, 6)
            local Label = Instance.new("TextLabel", TogFrame)
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = tOpts.Title
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            local Switch = Instance.new("TextButton", TogFrame)
            Switch.Size = UDim2.new(0, 30, 0, 16)
            Switch.Position = UDim2.new(1, -40, 0.5, -8)
            Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Switch.Text = ""
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
            local Dot = Instance.new("Frame", Switch)
            Dot.Size = UDim2.new(0, 12, 0, 12)
            Dot.Position = UDim2.new(0, 2, 0.5, -6)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
            local state = tOpts.Default or false
            local function updateToggle()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = state and ThemeColor or Color3.fromRGB(50, 50, 50)}):Play()
                if tOpts.Callback then tOpts.Callback(state) end
            end
            updateToggle()
            Switch.MouseButton1Click:Connect(function() state = not state; updateToggle() end)
        end

        function Tab:Slider(slOpts)
            local SFrame = Instance.new("Frame", TabContainer)
            SFrame.Size = UDim2.new(1, 0, 0, 45)
            SFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", SFrame).CornerRadius = UDim.new(0, 6)
            local Label = Instance.new("TextLabel", SFrame)
            Label.Size = UDim2.new(1, -10, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = slOpts.Title .. ": " .. tostring(slOpts.Default or slOpts.Min)
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            local Bar = Instance.new("TextButton", SFrame)
            Bar.Size = UDim2.new(1, -20, 0, 6)
            Bar.Position = UDim2.new(0, 10, 0, 30)
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Bar.Text = ""
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
            local Fill = Instance.new("Frame", Bar)
            local percentage = ((slOpts.Default or slOpts.Min) - slOpts.Min) / (slOpts.Max - slOpts.Min)
            Fill.Size = UDim2.new(percentage, 0, 1, 0)
            Fill.BackgroundColor3 = ThemeColor
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(slOpts.Min + ((slOpts.Max - slOpts.Min) * pos))
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Label.Text = slOpts.Title .. ": " .. val
                if slOpts.Callback then slOpts.Callback(val) end
            end
            Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
        end

        function Tab:Paragraph(pOpts)
            local PFrame = Instance.new("Frame", TabContainer)
            PFrame.Size = UDim2.new(1, 0, 0, 50)
            PFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", PFrame).CornerRadius = UDim.new(0, 6)
            local Title = Instance.new("TextLabel", PFrame)
            Title.Size = UDim2.new(1, -10, 0, 20)
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.BackgroundTransparency = 1
            Title.Text = pOpts.Title
            Title.TextColor3 = ThemeColor
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            local Desc = Instance.new("TextLabel", PFrame)
            Desc.Size = UDim2.new(1, -10, 0, 20)
            Desc.Position = UDim2.new(0, 10, 0, 25)
            Desc.BackgroundTransparency = 1
            Desc.Text = pOpts.Desc
            Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
            Desc.Font = Enum.Font.Gotham
            Desc.TextSize = 12
            Desc.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:Image(iOpts)
            local Img = Instance.new("ImageLabel", TabContainer)
            Img.Size = UDim2.new(1, 0, 0, 150)
            Img.Image = iOpts.Image
            Img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", Img).CornerRadius = UDim.new(0, iOpts.Radius or 6)
            if iOpts.AspectRatio then
                local ratio = Instance.new("UIAspectRatioConstraint", Img)
                ratio.AspectRatio = 4/3
            end
        end

        return Tab
    end

    function Window:LockedTab(opts)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "🔒 " .. opts.Title
        TabBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        TabBtn.MouseButton1Click:Connect(function()
            TweenService:Create(TabBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {Size = UDim2.new(0.85, 0, 0, 33)}):Play()
            Window:Notify({Title = opts.NotifyTitle or "Locked", Desc = opts.NotifyDesc or "Locked Tab", Time = 4})
        end)
    end

    function Window:EditOpenButton() end
    function Window:Tag() end

    return Window
end

return ALIENUI
