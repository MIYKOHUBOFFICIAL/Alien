local ALIENUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

local function GetAsset(url, fileName)
    if not isfile(fileName) then
        pcall(function()
            local res = game:HttpGet(url)
            writefile(fileName, res)
        end)
    end
    return getcustomasset(fileName)
end

function ALIENUI:CreateWindow(Config)
    local Window = {}
    local ThemeColor = Config.SelectBackground == "Meguna" and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 105, 180)
    
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "ALIEN_UI"

    local ToggleBtn = Instance.new("TextButton", ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    ToggleBtn.Text = Config.ToggleName or "ALIEN"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToggleBtn.TextColor3 = ThemeColor
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", ToggleBtn).Color = ThemeColor

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.fromOffset(450, 320)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.ClipsDescendants = true
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
    ResizeHandle.Position = UDim2.new(1, -12, 1, -12)
    ResizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ResizeHandle.ZIndex = 10
    Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(1, 0)

    local Background = Instance.new("ImageLabel", MainFrame)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundTransparency = 1
    Background.ImageTransparency = Config.BackgroundImageTransparency or 0.6
    Background.ScaleType = Enum.ScaleType.Crop
    Background.ZIndex = 0

    if Config.SelectBackground == "Astolfo" then
        task.spawn(function()
            local assetId = GetAsset("https://raw.githubusercontent.com/MIYKOHUBOFFICIAL/Roblox/refs/heads/main/TSB/Stuff/Utility/Techs/spritesheet-table-320-240%20(1).png", "femboy_anim.png")
            Background.Image = assetId
            Background.ImageRectSize = Vector2.new(320, 240)
            local cols = 9
            local total = (8 * 9) + 6
            while true do
                for i = 0, total - 1 do
                    Background.ImageRectOffset = Vector2.new((i % cols) * 320, math.floor(i / cols) * 240)
                    task.wait(1/12)
                end
            end
        end)
    end

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 130, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundTransparency = 1
    local SidebarList = Instance.new("UIListLayout", Sidebar)
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -140, 1, -45)
    ContentArea.Position = UDim2.new(0, 135, 0, 40)
    ContentArea.BackgroundTransparency = 1

    local NotifContainer = Instance.new("Frame", ScreenGui)
    NotifContainer.Size = UDim2.new(0, 220, 1, -20)
    NotifContainer.Position = UDim2.new(1, -230, 0, 10)
    NotifContainer.BackgroundTransparency = 1
    Instance.new("UIListLayout", NotifContainer).VerticalAlignment = Enum.VerticalAlignment.Bottom

    function Window:Notify(opts)
        local n = Instance.new("Frame", NotifContainer)
        n.Size = UDim2.new(1, 0, 0, 50)
        n.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", n)
        Instance.new("UIStroke", n).Color = ThemeColor
        local t = Instance.new("TextLabel", n)
        t.Size = UDim2.new(1, -10, 0, 20)
        t.Position = UDim2.new(0, 10, 0, 5)
        t.Text = opts.Title; t.TextColor3 = ThemeColor; t.Font = "GothamBold"; t.TextSize = 12; t.BackgroundTransparency = 1; t.TextXAlignment = "Left"
        local d = Instance.new("TextLabel", n)
        d.Size = UDim2.new(1, -10, 0, 20)
        d.Position = UDim2.new(0, 10, 0, 22)
        d.Text = opts.Desc; d.TextColor3 = Color3.fromRGB(200, 200, 200); d.Font = "Gotham"; d.TextSize = 11; d.BackgroundTransparency = 1; d.TextXAlignment = "Left"
        task.delay(opts.Time or 3, function() n:Destroy() end)
    end

    local dragging, startPos, startSize
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = true; startPos = input.Position; startSize = MainFrame.Size
            TweenService:Create(ResizeHandle, TweenInfo.new(0.2), {BackgroundColor3 = ThemeColor}):Play()
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPos
            MainFrame.Size = UDim2.new(0, math.max(350, startSize.X.Offset + delta.X), 0, math.max(250, startSize.Y.Offset + delta.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(input) dragging = false; TweenService:Create(ResizeHandle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play() end)

    local function Drag(obj)
        local d, s, sp
        obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; s = i.Position; sp = obj.Position end end)
        UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - s
            obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function() d = false end)
    end
    Drag(MainFrame); Drag(ToggleBtn)
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    local Tabs = {}; local First = true
    function Window:Tab(opts)
        local Tab = {}
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(0.9, 0, 0, 30); btn.Text = opts.Title; btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.TextColor3 = First and ThemeColor or Color3.fromRGB(150,150,150); btn.BackgroundTransparency = First and 0 or 1
        btn.Font = "GothamSemibold"; btn.TextSize = 12; Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

        local container = Instance.new("ScrollingFrame", ContentArea)
        container.Size = UDim2.new(1, 0, 1, 0); container.BackgroundTransparency = 1; container.Visible = First
        container.ScrollBarThickness = 0; container.CanvasSize = UDim2.new(0,0,0,0)
        local list = Instance.new("UIListLayout", container); list.Padding = UDim.new(0,6)
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() container.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y+10) end)

        table.insert(Tabs, {b = btn, c = container}); First = false
        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(Tabs) do v.c.Visible = false; v.b.BackgroundTransparency = 1; v.b.TextColor3 = Color3.fromRGB(150,150,150) end
            container.Visible = true; btn.BackgroundTransparency = 0; btn.TextColor3 = ThemeColor
        end)

        function Tab:Section(s)
            local l = Instance.new("TextLabel", container)
            l.Size = UDim2.new(1, 0, 0, 20); l.Text = s.Title:upper(); l.TextColor3 = ThemeColor; l.Font = "GothamBold"; l.TextSize = 11; l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
        end

        function Tab:Button(b)
            local bt = Instance.new("TextButton", container)
            bt.Size = UDim2.new(1, -10, 0, 32); bt.BackgroundColor3 = Color3.fromRGB(25,25,25); bt.Text = b.Title; bt.TextColor3 = Color3.fromRGB(255,255,255); bt.Font = "Gotham"; bt.TextSize = 12
            Instance.new("UICorner", bt).CornerRadius = UDim.new(0,5)
            bt.MouseButton1Click:Connect(function() if b.Callback then b.Callback() end end)
        end

        function Tab:Toggle(t)
            local f = Instance.new("Frame", container)
            f.Size = UDim2.new(1,-10,0,32); f.BackgroundColor3 = Color3.fromRGB(25,25,25)
            Instance.new("UICorner", f).CornerRadius = UDim.new(0,5)
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1,-40,1,0); l.Position = UDim2.new(0,10,0,0); l.Text = t.Title; l.TextColor3 = Color3.fromRGB(255,255,255); l.Font = "Gotham"; l.TextSize = 12; l.BackgroundTransparency = 1; l.TextXAlignment = "Left"
            local s = Instance.new("TextButton", f)
            s.Size = UDim2.new(0,28,0,14); s.Position = UDim2.new(1,-35,0.5,-7); s.BackgroundColor3 = Color3.fromRGB(50,50,50); s.Text = ""
            Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
            local d = Instance.new("Frame", s); d.Size = UDim2.new(0,10,0,10); d.Position = UDim2.new(0,2,0.5,-5); d.BackgroundColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", d).CornerRadius = UDim.new(1,0)
            local state = t.Default or false
            local function up() 
                TweenService:Create(d, TweenInfo.new(0.2), {Position = state and UDim2.new(1,-12,0.5,-5) or UDim2.new(0,2,0.5,-5)}):Play()
                TweenService:Create(s, TweenInfo.new(0.2), {BackgroundColor3 = state and ThemeColor or Color3.fromRGB(50,50,50)}):Play()
                if t.Callback then t.Callback(state) end
            end
            up(); s.MouseButton1Click:Connect(function() state = not state; up() end)
        end

        function Tab:Paragraph(p)
            local f = Instance.new("Frame", container)
            f.Size = UDim2.new(1,-10,0,0); f.BackgroundColor3 = Color3.fromRGB(25,25,25); f.AutomaticSize = "Y"
            Instance.new("UICorner", f).CornerRadius = UDim.new(0,5)
            local l = Instance.new("UIListLayout", f); l.Padding = UDim.new(0,2); l.HorizontalAlignment = "Center"
            local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,-16,0,20); t.Text = p.Title; t.TextColor3 = ThemeColor; t.Font = "GothamBold"; t.TextSize = 12; t.BackgroundTransparency = 1; t.TextXAlignment = "Left"
            local d = Instance.new("TextLabel", f); d.Size = UDim2.new(1,-16,0,0); d.AutomaticSize = "Y"; d.Text = p.Desc; d.TextColor3 = Color3.fromRGB(180,180,180); d.Font = "Gotham"; d.TextSize = 11; d.BackgroundTransparency = 1; d.TextXAlignment = "Left"; d.TextWrapped = true
            Instance.new("UIPadding", f).PaddingTop = UDim.new(0,5); Instance.new("UIPadding", f).PaddingBottom = UDim.new(0,5)
        end

        function Tab:Image(i)
            local img = Instance.new("ImageLabel", container)
            img.Size = UDim2.new(1,-10,0,150); img.Image = i.Image; img.ScaleType = "Crop"
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, i.Radius or 5)
            if i.AspectRatio then Instance.new("UIAspectRatioConstraint", img).AspectRatio = 1.5 end
        end

        return Tab
    end

    function Window:LockedTab(opts)
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(0.9,0,0,30); btn.Text = "🔒 " .. opts.Title; btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        btn.TextColor3 = Color3.fromRGB(100,100,100); btn.BackgroundTransparency = 0.5; btn.Font = "GothamSemibold"; btn.TextSize = 12
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
        btn.MouseButton1Click:Connect(function() Window:Notify({Title = opts.NotifyTitle, Desc = opts.NotifyDesc}) end)
    end

    return Window
end

return ALIENUI
