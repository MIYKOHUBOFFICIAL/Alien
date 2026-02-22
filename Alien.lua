local ALIENUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

local function GetAsset(url, fileName)
    if not isfile(fileName) then
        pcall(function() writefile(fileName, game:HttpGet(url)) end)
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

    local function MakeDraggable(gui)
        local dragging, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = gui.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function() dragging = false end)
    end
    MakeDraggable(ToggleBtn)

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(450, 320) -- Tamaño inicial arreglado
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160) -- Centrado perfecto
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
    ResizeHandle.Position = UDim2.new(1, -12, 1, -12)
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ResizeHandle.ZIndex = 10
    Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(0, 2)

    local function SetupResize(handle, target)
        local resizing, inputPos, startSize
        handle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true; inputPos = i.Position; startSize = target.Size
                TweenService:Create(handle, TweenInfo.new(0.2), {BackgroundColor3 = ThemeColor}):Play()
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - inputPos
                -- Limites de redimensionado para evitar que se rompa
                target.Size = UDim2.new(0, math.clamp(startSize.X.Offset + delta.X, 300, 800), 0, math.clamp(startSize.Y.Offset + delta.Y, 200, 600))
            end
        end)
        UserInputService.InputEnded:Connect(function() resizing = false; TweenService:Create(handle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play() end)
    end
    SetupResize(ResizeHandle, MainFrame)

    local Background = Instance.new("ImageLabel", MainFrame)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundTransparency = 1
    Background.ImageTransparency = Config.BackgroundImageTransparency or 0.6
    Background.ScaleType = Enum.ScaleType.Stretch
    Background.ZIndex = 0

    if Config.SelectBackground == "Meguna" then
        task.spawn(function()
            local asset = GetAsset("https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/To-Me/refs/heads/main/Sukuna-table-640-480.png", "sukuna_bg.png")
            Background.Image = asset
            Background.ImageRectSize = Vector2.new(640, 480)
            local currentFrame = 0
            while true do
                Background.ImageRectOffset = Vector2.new(currentFrame * 640, 0)
                currentFrame = (currentFrame + 1) % 36
                task.wait(1/12)
            end
        end)
    elseif Config.SelectBackground == "Astolfo" then
        task.spawn(function()
            local asset = GetAsset("https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Roblox/refs/heads/main/TSB/Stuff/Utility/Techs/spritesheet-table-320-240%20(1).png", "femboy_anim_new.png")
            Background.Image = asset
            Background.ImageRectSize = Vector2.new(320, 240)
            local cols = 9
            local totalFrames = (8 * cols) + 6 
            while true do
                for i = 0, totalFrames - 1 do
                    Background.ImageRectOffset = Vector2.new((i % cols) * 320, math.floor(i / cols) * 240)
                    task.wait(1/12)
                end
            end
        end)
    end

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, Config.SideBarWidth or 130, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Sidebar.BackgroundTransparency = 0.4
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -(Config.SideBarWidth or 130) - 10, 1, -45)
    ContentArea.Position = UDim2.new(0, (Config.SideBarWidth or 130) + 5, 0, 40)
    ContentArea.BackgroundTransparency = 1

    MakeDraggable(MainFrame) -- Permitir mover la UI desde la barra superior

    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local Tabs = {}; local FirstTab = true

    function Window:Tab(opts)
        local Tab = {}
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 30); TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = FirstTab and 0 or 1; TabBtn.Text = opts.Title
        TabBtn.TextColor3 = FirstTab and ThemeColor or Color3.fromRGB(150, 150, 150)
        TabBtn.Font = "GothamSemibold"; TabBtn.TextSize = 12; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local TabContainer = Instance.new("ScrollingFrame", ContentArea)
        TabContainer.Size = UDim2.new(1, 0, 1, 0); TabContainer.BackgroundTransparency = 1; TabContainer.Visible = FirstTab
        TabContainer.ScrollBarThickness = 0; TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        local List = Instance.new("UIListLayout", TabContainer); List.Padding = UDim.new(0, 6)
        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10)
        end)

        table.insert(Tabs, {Btn = TabBtn, Container = TabContainer}); FirstTab = false

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do t.Container.Visible = false; t.Btn.BackgroundTransparency = 1; t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150) end
            TabContainer.Visible = true; TabBtn.BackgroundTransparency = 0; TabBtn.TextColor3 = ThemeColor
        end)

        function Tab:Section(sOpts)
            local Sec = Instance.new("TextLabel", TabContainer)
            Sec.Size = UDim2.new(1, -10, 0, 20); Sec.BackgroundTransparency = 1; Sec.Text = sOpts.Title:upper()
            Sec.TextColor3 = ThemeColor; Sec.Font = "GothamBold"; Sec.TextSize = 11; Sec.TextXAlignment = "Left"
        end

        function Tab:Button(bOpts)
            local Btn = Instance.new("TextButton", TabContainer)
            Btn.Size = UDim2.new(1, -10, 0, 32); Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Btn.Text = bOpts.Title; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = "Gotham"; Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
            Btn.MouseButton1Click:Connect(function() if bOpts.Callback then bOpts.Callback() end end)
        end

        function Tab:Toggle(tOpts)
            local f = Instance.new("Frame", TabContainer)
            f.Size = UDim2.new(1, -10, 0, 32); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", f)
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1, -45, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1; l.Text = tOpts.Title
            l.TextColor3 = Color3.fromRGB(255, 255, 255); l.Font = "Gotham"; l.TextSize = 12; l.TextXAlignment = "Left"
            local sw = Instance.new("TextButton", f)
            sw.Size = UDim2.new(0, 28, 0, 14); sw.Position = UDim2.new(1, -38, 0.5, -7); sw.BackgroundColor3 = Color3.fromRGB(50, 50, 50); sw.Text = ""
            Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
            local d = Instance.new("Frame", sw); d.Size = UDim2.new(0, 10, 0, 10); d.Position = UDim2.new(0, 2, 0.5, -5); d.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", d)
            local state = tOpts.Default or false
            local function update()
                TweenService:Create(d, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
                TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = state and ThemeColor or Color3.fromRGB(50, 50, 50)}):Play()
                if tOpts.Callback then tOpts.Callback(state) end
            end
            update(); sw.MouseButton1Click:Connect(function() state = not state; update() end)
        end

        function Tab:Slider(sOpts)
            local SFrame = Instance.new("Frame", TabContainer)
            SFrame.Size = UDim2.new(1, -10, 0, 45); SFrame.BackgroundTransparency = 1
            local Label = Instance.new("TextLabel", SFrame)
            Label.Size = UDim2.new(1, 0, 0, 20); Label.BackgroundTransparency = 1; Label.Text = sOpts.Title .. ": " .. (sOpts.Default or sOpts.Min)
            Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.Font = "Gotham"; Label.TextSize = 12; Label.TextXAlignment = "Left"
            local Box = Instance.new("Frame", SFrame); Box.Size = UDim2.new(1, 0, 0, 4); Box.Position = UDim2.new(0, 0, 0, 30); Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            local Fill = Instance.new("Frame", Box); Fill.Size = UDim2.new(((sOpts.Default or sOpts.Min) - sOpts.Min)/(sOpts.Max - sOpts.Min), 0, 1, 0); Fill.BackgroundColor3 = ThemeColor
            local dragging = false
            local function move()
                local pos = math.clamp((UserInputService:GetMouseLocation().X - Box.AbsolutePosition.X) / Box.AbsoluteSize.X, 0, 1)
                local val = math.floor(sOpts.Min + (sOpts.Max - sOpts.Min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0); Label.Text = sOpts.Title .. ": " .. val
                if sOpts.Callback then sOpts.Callback(val) end
            end
            Box.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move() end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            RunService.RenderStepped:Connect(function() if dragging then move() end end)
        end

        function Tab:Paragraph(pOpts)
            local f = Instance.new("Frame", TabContainer)
            f.Size = UDim2.new(1, -10, 0, 0); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); f.AutomaticSize = "Y"; Instance.new("UICorner", f)
            local Layout = Instance.new("UIListLayout", f); Layout.Padding = UDim.new(0, 2); Layout.HorizontalAlignment = "Center"
            local T = Instance.new("TextLabel", f); T.Size = UDim2.new(1, -16, 0, 20); T.BackgroundTransparency = 1; T.Text = pOpts.Title; T.TextColor3 = ThemeColor; T.Font = "GothamBold"; T.TextSize = 12; T.TextXAlignment = "Left"
            local D = Instance.new("TextLabel", f); D.Size = UDim2.new(1, -16, 0, 0); D.AutomaticSize = "Y"; D.BackgroundTransparency = 1; D.Text = pOpts.Desc; D.TextColor3 = Color3.fromRGB(180, 180, 180); D.Font = "Gotham"; D.TextSize = 11; D.TextWrapped = true; D.TextXAlignment = "Left"
            Instance.new("UIPadding", f).PaddingTop = UDim.new(0, 5); Instance.new("UIPadding", f).PaddingBottom = UDim.new(0, 5); Instance.new("UIPadding", f).PaddingLeft = UDim.new(0, 8)
        end

        function Tab:Image(iOpts)
            local img = Instance.new("ImageLabel", TabContainer)
            img.Size = UDim2.new(1, -10, 0, 150); img.Image = iOpts.Image; img.ScaleType = "Crop"
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, iOpts.Radius or 9)
            if iOpts.AspectRatio then Instance.new("UIAspectRatioConstraint", img) end
        end

        return Tab
    end

    function Window:LockedTab(opts)
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(0.9, 0, 0, 30); btn.Text = "🔒 "..opts.Title; btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btn.TextColor3 = Color3.fromRGB(80, 80, 80); btn.Font = "GothamSemibold"; btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(function() Window:Notify({Title = opts.NotifyTitle, Desc = opts.NotifyDesc}) end)
    end

    function Window:Notify(nOpts)
        local nf = Instance.new("Frame", ScreenGui)
        nf.Size = UDim2.new(0, 220, 0, 60); nf.Position = UDim2.new(1, 10, 1, -70); nf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", nf); Instance.new("UIStroke", nf).Color = ThemeColor
        local T = Instance.new("TextLabel", nf); T.Size = UDim2.new(1, -10, 0, 20); T.Position = UDim2.new(0, 5, 0, 5); T.BackgroundTransparency = 1; T.Text = nOpts.Title; T.TextColor3 = ThemeColor; T.Font = "GothamBold"; T.TextSize = 13
        local D = Instance.new("TextLabel", nf); D.Size = UDim2.new(1, -10, 0, 30); D.Position = UDim2.new(0, 5, 0, 25); D.BackgroundTransparency = 1; D.Text = nOpts.Desc; D.TextColor3 = Color3.fromRGB(200, 200, 200); D.Font = "Gotham"; D.TextSize = 11; D.TextWrapped = true
        TweenService:Create(nf, TweenInfo.new(0.4), {Position = UDim2.new(1, -230, 1, -70)}):Play()
        task.delay(nOpts.Time or 3, function() TweenService:Create(nf, TweenInfo.new(0.4), {Position = UDim2.new(1, 10, 1, -70)}):Play(); task.wait(0.4); nf:Destroy() end)
    end

    return Window
end

return ALIENUI
