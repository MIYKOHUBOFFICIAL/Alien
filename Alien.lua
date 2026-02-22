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
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    MakeDraggable(ToggleBtn)

    -- [ VENTANA PRINCIPAL ]
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(450, 320)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    -- TopBar (Título arriba)
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

    -- [ CUADRO DE RESIZE ELEGANTE ]
    local ResizeHandle = Instance.new("Frame", MainFrame)
    ResizeHandle.Size = UDim2.new(0, 10, 0, 10)
    ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ResizeHandle.ZIndex = 10
    Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(0, 2)
    local ResizeStroke = Instance.new("UIStroke", ResizeHandle)
    ResizeStroke.Color = Color3.fromRGB(120, 120, 120)
    ResizeStroke.Thickness = 1

    local function MakeResizeable(handle, target)
        local dragging, startPos, startSize
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startPos = input.Position
                startSize = target.Size
                TweenService:Create(handle, TweenInfo.new(0.2), {BackgroundColor3 = ThemeColor, Size = UDim2.new(0, 14, 0, 14)}):Play()
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - startPos
                target.Size = UDim2.new(0, math.max(300, startSize.X.Offset + delta.X), 0, math.max(200, startSize.Y.Offset + delta.Y))
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                TweenService:Create(handle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80), Size = UDim2.new(0, 10, 0, 10)}):Play()
            end
        end)
    end
    MakeResizeable(ResizeHandle, MainFrame)

    -- Fondo Animado Meguna / Astolfo
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
                for y = 0, 5 do
                    for x = 0, 5 do
                        Background.ImageRectOffset = Vector2.new(x * 640, y * 480)
                        task.wait(1/12)
                    end
                end
            end
        end)
    elseif Config.SelectBackground == "Astolfo" then
        task.spawn(function()
            local assetId = GetAsset("https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Roblox/refs/heads/main/TSB/Stuff/Utility/Techs/spritesheet-table-320-240%20(1).png", "femboy_anim_new.png")
            Background.Image = assetId
            Background.ImageRectSize = Vector2.new(320, 240)
            local cols, totalFrames = 9, 78
            while true do
                for i = 0, totalFrames - 1 do
                    Background.ImageRectOffset = Vector2.new((i % cols) * 320, math.floor(i / cols) * 240)
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
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 4)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -135, 1, -40)
    ContentArea.Position = UDim2.new(0, 135, 0, 40)
    ContentArea.BackgroundTransparency = 1

    local function MainDraggable(gui)
        local dragging, dragInput, dragStart, startPos
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end
    MainDraggable(MainFrame)

    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

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
        local List = Instance.new("UIListLayout", TabContainer); List.Padding = UDim.new(0, 6)
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

        function Tab:Section(s)
            local Sec = Instance.new("TextLabel", TabContainer)
            Sec.Size = UDim2.new(1, -10, 0, 20)
            Sec.BackgroundTransparency = 1
            Sec.Text = s.Title:upper()
            Sec.TextColor3 = ThemeColor
            Sec.Font = "GothamBold"; Sec.TextSize = 11; Sec.TextXAlignment = "Left"
        end

        function Tab:Button(b)
            local Btn = Instance.new("TextButton", TabContainer)
            Btn.Size = UDim2.new(1, -10, 0, 32); Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Btn.Text = b.Title; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = "Gotham"; Btn.TextSize = 12
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)
            Btn.MouseButton1Click:Connect(function() if b.Callback then b.Callback() end end)
        end

        function Tab:Paragraph(p)
            local PFrame = Instance.new("Frame", TabContainer)
            PFrame.Size = UDim2.new(1, -10, 0, 0); PFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); PFrame.AutomaticSize = "Y"
            Instance.new("UICorner", PFrame).CornerRadius = UDim.new(0, 5)
            Instance.new("UIListLayout", PFrame).Padding = UDim.new(0, 2)
            local T = Instance.new("TextLabel", PFrame)
            T.Size = UDim2.new(1, -16, 0, 20); T.BackgroundTransparency = 1; T.Text = p.Title; T.TextColor3 = ThemeColor; T.Font = "GothamBold"; T.TextSize = 12; T.TextXAlignment = "Left"
            local D = Instance.new("TextLabel", PFrame)
            D.Size = UDim2.new(1, -16, 0, 0); D.AutomaticSize = "Y"; D.BackgroundTransparency = 1; D.Text = p.Desc; D.TextColor3 = Color3.fromRGB(180, 180, 180); D.Font = "Gotham"; D.TextSize = 11; D.TextWrapped = true; D.TextXAlignment = "Left"
            Instance.new("UIPadding", PFrame).PaddingLeft = UDim.new(0, 8)
        end

        function Tab:Image(i)
            local img = Instance.new("ImageLabel", TabContainer)
            img.Size = UDim2.new(1, -10, 0, 150); img.Image = i.Image; img.ScaleType = "Crop"
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, i.Radius or 9)
            if i.AspectRatio then Instance.new("UIAspectRatioConstraint", img) end
        end

        function Tab:Toggle(t)
            local f = Instance.new("Frame", TabContainer)
            f.Size = UDim2.new(1,-10,0,32); f.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", f).CornerRadius = UDim.new(0,5)
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1,-45,1,0); l.Position = UDim2.new(0,10,0,0); l.BackgroundTransparency = 1; l.Text = t.Title; l.TextColor3 = Color3.fromRGB(255,255,255); l.Font = "Gotham"; l.TextSize = 12; l.TextXAlignment = "Left"
            local s = Instance.new("TextButton", f)
            s.Size = UDim2.new(0,28,0,14); s.Position = UDim2.new(1,-38,0.5,-7); s.BackgroundColor3 = Color3.fromRGB(50,50,50); s.Text = ""; Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
            local d = Instance.new("Frame", s); d.Size = UDim2.new(0,10,0,10); d.Position = UDim2.new(0,2,0.5,-5); d.BackgroundColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", d).CornerRadius = UDim.new(1,0)
            local state = t.Default or false
            local function up()
                TweenService:Create(d, TweenInfo.new(0.2), {Position = state and UDim2.new(1,-12,0.5,-5) or UDim2.new(0,2,0.5,-5)}):Play()
                TweenService:Create(s, TweenInfo.new(0.2), {BackgroundColor3 = state and ThemeColor or Color3.fromRGB(50,50,50)}):Play()
                if t.Callback then t.Callback(state) end
            end
            up(); s.MouseButton1Click:Connect(function() state = not state; up() end)
        end

        return Tab
    end

    function Window:LockedTab(opts)
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(0.9,0,0,30); btn.Text = "🔒 "..opts.Title; btn.BackgroundColor3 = Color3.fromRGB(20,20,20); btn.TextColor3 = Color3.fromRGB(80,80,80); btn.Font = "GothamSemibold"; btn.TextSize = 12
        btn.MouseButton1Click:Connect(function() Window:Notify({Title = opts.NotifyTitle, Desc = opts.NotifyDesc}) end)
    end

    function Window:Notify(n) print(n.Title..": "..n.Desc) end

    return Window
end

return ALIENUI
