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

    -- [ BOTÓN TOGGLE ARRASTRABLE ]
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
        local dragging, dragInput, dragStart, startPos
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

    -- [ VENTANA PRINCIPAL ]
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = Config.Size or UDim2.fromOffset(450, 320)
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
    ResizeHandle.Size = UDim2.new(0, 10, 0, 10)
    ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
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
                target.Size = UDim2.new(0, math.max(350, startSize.X.Offset + delta.X), 0, math.max(250, startSize.Y.Offset + delta.Y))
            end
        end)
        UserInputService.InputEnded:Connect(function() resizing = false; TweenService:Create(handle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,80,80)}):Play() end)
    end
    SetupResize(ResizeHandle, MainFrame)

    -- [ FONDO ANIMADO MEGUNA CORREGIDO ]
    local Background = Instance.new("ImageLabel", MainFrame)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundTransparency = 1
    Background.ImageTransparency = Config.BackgroundImageTransparency or 0.6
    Background.ScaleType = Enum.ScaleType.Crop
    Background.ZIndex = 0

    if Config.SelectBackground == "Meguna" then
        task.spawn(function()
            local assetId = GetAsset("https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/To-Me/refs/heads/main/Sukuna-table-640-480.png", "sukuna_bg.png")
            Background.Image = assetId
            Background.ImageRectSize = Vector2.new(640, 480)
            while true do
                for row = 0, 5 do
                    for col = 0, 5 do
                        Background.ImageRectOffset = Vector2.new(col * 640, row * 480)
                        task.wait(1/12)
                    end
                end
            end
        end)
    end

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, Config.SideBarWidth or 130, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Sidebar.BackgroundTransparency = 0.4
    local SidebarList = Instance.new("UIListLayout", Sidebar)
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -(Config.SideBarWidth or 130) - 5, 1, -40)
    ContentArea.Position = UDim2.new(0, (Config.SideBarWidth or 130) + 5, 0, 40)
    ContentArea.BackgroundTransparency = 1

    local function MainDrag(gui)
        local dragging, dragStart, startPos
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; dragStart = input.Position; startPos = gui.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function() dragging = false end)
    end
    MainDrag(MainFrame)

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
        TabContainer.Size = UDim2.new(1, -5, 1, 0); TabContainer.BackgroundTransparency = 1; TabContainer.Visible = FirstTab
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

        function Tab:Section(s)
            local Sec = Instance.new("TextLabel", TabContainer)
            Sec.Size = UDim2.new(1, -10, 0, 20); Sec.BackgroundTransparency = 1; Sec.Text = s.Title:upper()
            Sec.TextColor3 = ThemeColor; Sec.Font = "GothamBold"; Sec.TextSize = 11; Sec.TextXAlignment = "Left"
        end

        function Tab:Button(b)
            local Btn = Instance.new("TextButton", TabContainer)
            Btn.Size = UDim2.new(1, -10, 0, 32); Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Btn.Text = b.Title; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = "Gotham"; Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
            Btn.MouseButton1Click:Connect(function() if b.Callback then b.Callback() end end)
        end

        function Tab:Toggle(t)
            local f = Instance.new("Frame", TabContainer)
            f.Size = UDim2.new(1, -10, 0, 32); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", f)
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1, -45, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1; l.Text = t.Title
            l.TextColor3 = Color3.fromRGB(255, 255, 255); l.Font = "Gotham"; l.TextSize = 12; l.TextXAlignment = "Left"
            local sw = Instance.new("TextButton", f)
            sw.Size = UDim2.new(0, 28, 0, 14); sw.Position = UDim2.new(1, -38, 0.5, -7); sw.BackgroundColor3 = Color3.fromRGB(50, 50, 50); sw.Text = ""
            Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
            local d = Instance.new("Frame", sw); d.Size = UDim2.new(0, 10, 0, 10); d.Position = UDim2.new(0, 2, 0.5, -5); d.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", d)
            local state = t.Default or false
            local function up()
                TweenService:Create(d, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
                TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = state and ThemeColor or Color3.fromRGB(50, 50, 50)}):Play()
                if t.Callback then t.Callback(state) end
            end
            up(); sw.MouseButton1Click:Connect(function() state = not state; up() end)
        end

        function Tab:Slider(sl)
            local f = Instance.new("Frame", TabContainer)
            f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundTransparency = 1
            local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = sl.Title .. ": " .. sl.Default
            l.TextColor3 = Color3.fromRGB(255, 255, 255); l.Font = "Gotham"; l.TextSize = 12; l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
            local b = Instance.new("TextButton", f); b.Size = UDim2.new(1, 0, 0, 6); b.Position = UDim2.new(0, 0, 0.7, 0); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.Text = ""
            local fill = Instance.new("Frame", b); fill.Size = UDim2.new((sl.Default-sl.Min)/(sl.Max-sl.Min), 0, 1, 0); fill.BackgroundColor3 = ThemeColor
            local drag = false
            local function up()
                local p = math.clamp((UserInputService:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
                local v = math.floor(sl.Min + (sl.Max - sl.Min) * p)
                fill.Size = UDim2.new(p, 0, 1, 0); l.Text = sl.Title .. ": " .. v
                if sl.Callback then sl.Callback(v) end
            end
            b.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true up() end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
            RunService.RenderStepped:Connect(function() if drag then up() end end)
        end

        function Tab:Paragraph(p)
            local f = Instance.new("Frame", TabContainer)
            f.Size = UDim2.new(1, -10, 0, 0); f.BackgroundColor3 = Color3.fromRGB(25, 25, 25); f.AutomaticSize = "Y"; Instance.new("UICorner", f)
            local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1, -16, 0, 20); t.BackgroundTransparency = 1; t.Text = p.Title
            t.TextColor3 = ThemeColor; t.Font = "GothamBold"; t.TextSize = 12; t.TextXAlignment = "Left"
            local d = Instance.new("TextLabel", f); d.Size = UDim2.new(1, -16, 0, 0); d.AutomaticSize = "Y"; d.BackgroundTransparency = 1; d.Text = p.Desc
            d.TextColor3 = Color3.fromRGB(180, 180, 180); d.Font = "Gotham"; d.TextSize = 11; d.TextWrapped = true; d.TextXAlignment = "Left"
            Instance.new("UIListLayout", f).Padding = UDim.new(0, 2); Instance.new("UIPadding", f).PaddingLeft = UDim.new(0, 8)
        end

        function Tab:Image(i)
            local img = Instance.new("ImageLabel", TabContainer)
            img.Size = UDim2.new(1, -10, 0, 150); img.Image = i.Image; img.ScaleType = "Crop"
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, i.Radius or 9)
            if i.AspectRatio then Instance.new("UIAspectRatioConstraint", img) end
        end

        return Tab
    end

    function Window:LockedTab(opts)
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(0.9, 0, 0, 30); btn.Text = "🔒 "..opts.Title; btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.TextColor3 = Color3.fromRGB(80, 80, 80); btn.Font = "GothamSemibold"; btn.TextSize = 12
        btn.MouseButton1Click:Connect(function() Window:Notify({Title = opts.NotifyTitle, Desc = opts.NotifyDesc}) end)
    end

    function Window:Notify(n)
        local nf = Instance.new("Frame", ScreenGui)
        nf.Size = UDim2.new(0, 200, 0, 50); nf.Position = UDim2.new(1, -210, 1, -60); nf.BackgroundColor3 = Color3.fromRGB(20,20,20)
        Instance.new("UICorner", nf); Instance.new("UIStroke", nf).Color = ThemeColor
        local t = Instance.new("TextLabel", nf); t.Size = UDim2.new(1,-10,0,20); t.Position = UDim2.new(0,5,0,5); t.Text = n.Title; t.TextColor3 = ThemeColor; t.BackgroundTransparency = 1
        local d = Instance.new("TextLabel", nf); d.Size = UDim2.new(1,-10,0,20); d.Position = UDim2.new(0,5,0,25); d.Text = n.Desc; d.TextColor3 = Color3.fromRGB(200,200,200); d.BackgroundTransparency = 1
        task.delay(n.Time or 3, function() nf:Destroy() end)
    end

    return Window
end

return ALIENUI
