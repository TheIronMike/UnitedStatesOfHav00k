---@diagnostic disable: unused-function, undefined-global
--[[ Documentation
    Helios:notification(Text) -- Sends notification
    Helios:MainWindow(str: name) Maximum 1
        MainWindow:Tab(str: Name)
            Tab:Button(str: Name, func: Callback)
            Tab:Toggle(str: Name, bool: initState, func: Callback(Bool))
            Tab:Colorpicker(str: Name, Color3: initColor, func: Callback(Color3))
            Tab:Slider(str: Name, int: MinValue, int: MaxValue, func: Callback(int))
            Tab:Textbox(str: Name, bool: disapear, func: Callback(str)) -- Does what you enter disapear
            Tab:Dropdown(str: Name, tbl: tuple, func: Callback(any))
            Tab:Label(str: Label)
            Tab:Spliter() -- Literally a blank space that looks nice, meant to divy up sections.
]]
local Helios = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheIronMike/UILibrary/main/Main"))()
local Menu = Helios:MainWindow("United States of Hav00k")

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

-- Instances
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Constants
local Remotes = ReplicatedStorage:WaitForChild("remotes")

-- Settings Constants
local DestroyKeyConnection
local TeleportKeyConnection
local TargetPlayerForTeleport


-- Bank Constants
local ATMCFrame = CFrame.new(2720.35962, 53.9955444, 253.060837)
local BankAmountVariable = 0
local BankTargetVariable = LocalPlayer.Name

-- Transport Constants
local LocationsForTransport = {"WW2 Memorial", "Gun Shop", "Car Dealership", "White House", "Capitol Hill", "Mart", "Motel", "Club Vibe", "Real Estate Shop", "Helicopter Shop", "Supreme Court Building", "Lincoln Memorial"}
local LocationCFramesForTransport = {
    ["WW2 Memorial"] = CFrame.new(2397.72534, 36.334404, -1134.07581, 0.0233300999, 0.00692171045, 0.999703825, -1.12933822e-05, 0.999975979, -0.00692333141, -0.999727845, 0.000150244814, 0.0233296193),
    ["Gun Shop"] = CFrame.new(-147.97522, 43.4990692, 146.385025, 0.0218783133, 0.00121123611, 0.999759972, -3.19959923e-07, 0.999999285, -0.001211519, -0.999760687, 2.61791774e-05, 0.0218782984),
    ["Car Dealership"] = CFrame.new(2689.89893, 43.4864235, 139.400009, 0.0232238155, 0.00653500576, 0.999708951, -9.9861636e-06, 0.999978662, -0.00653653638, -0.999730289, 0.000141818076, 0.0232233852),
    ["White House"] = CFrame.new(2475.99951, 43.0000191, 1537.30005, 0.0217326283, 1.05982551e-07, 0.999763846, 4.8050901e-09, 1, -1.0611204e-07, -0.999763846, 7.11004855e-09, 0.0217326283),
    ["Capitol Hill"] = CFrame.new(-5349.73535, 43.4988136, -1123.68726, 0.0217326283, -8.04437548e-08, 0.999763846, -3.65170227e-09, 1, 8.05421365e-08, -0.999763846, -5.40123191e-09, 0.0217326283),
    ["Mart"] = CFrame.new(3794.36743, 43.4904747, 2647.78735, 0.0188753568, -0.00424987683, 0.999812841, -1.20634677e-05, 0.99999094, 0.00425086264, -0.999821901, -9.2303344e-05, 0.0188751332),
    ["Motel"] = CFrame.new(4458.29883, 43.498867, 1152.90002, 0.0217326283, 8.81863826e-08, 0.999763846, 4.01814582e-09, 1, -8.82945628e-08, -0.999763846, 5.93606986e-09, 0.0217326283),
    ["Club Vibe"] = CFrame.new(-1886.18079, 43.470192, -2137.77686, 0.7700544, -0.00419847015, -0.637964368, -7.40579526e-06, 0.999978244, -0.00658982899, 0.637978256, 0.00507924613, 0.770037651),
    ["Real Estate Shop"] = CFrame.new(4989.05078, 43.4646797, 726.149231, 0.770883024, -0.00250155176, -0.636971772, 6.62361401e-07, 0.999992251, -0.00392642757, 0.636976719, 0.00302639557, 0.770877063),
    ["Helicopter Shop"] = CFrame.new(-4816.77832, 43.4916229, 1630.0116, 0.770114779, -0.00315061864, -0.637897551, -5.2044079e-06, 0.999987781, -0.00494528329, 0.6379053, 0.00381175219, 0.770105362),
    ["Supreme Court Building"] = CFrame.new(-8294.74023, 76.4990158, -1055.17798, 0.999015689, -1.12335403e-08, -0.0443585962, 1.28290543e-08, 1, 3.56838576e-08, 0.0443585962, -3.62178092e-08, 0.999015689),
    ["Lincoln Memorial"] = CFrame.new(6842.79639, 42.7914886, -1523.32068, -0.997818768, 0.000321346597, 0.0660124347, -5.11506778e-06, 0.999987781, -0.00494514266, -0.066013217, -0.00493469322, -0.997806489),
}
local LocationSelectedForTransport = "WW2 Memorial"

-- Gun Constants
local GunshopCFrame = CFrame.new(-23.4904385, 54.6723785, 162.2146, -0.999147832, 0.000116927971, -0.0412756391, -1.03344773e-05, 0.999995232, 0.00308363303, 0.041275803, 0.00308143254, -0.999143064)
local GunOptions = {"AWM", "AS50", "M14", "Tommy Gun", "SPAS-12", "AK-105", "M16", "USP", "SL8", "FAL", "MP5K", "RPK-74"}
local GunPackUnlocks = {"AWM", "AS50", "SPAS-12", "AK-105", "FAL", "MP5K", "RPK-74"}
local GunPackID = 7006570
local GunCosts = {
    ["AWM"] = 0,
    ["AS50"] = 0,
    ["M14"] = 650,
    ["Tommy Gun"] = 450,
    ["SPAS-12"] = 0,
    ["AK-105"] = 0,
    ["M16"] = 550,
    ["USP"] = 50,
    ["SL8"] = 350,
    ["FAL"] = 0,
    ["MP5K"] = 0,
    ["RPK-74"] = 0,
}
local SelectedGun = "M14"

-- Illegal Gun Store
local IllegalGunList = {"Duct Tape", "Prisoner Disguise", "Makarov", "AK-47"}
local IllegalPriceList = {
    ["Duct Tape"] = 125,
    ["Prisoner Disguise"] = 1,
    ["Makarov"] = 50,
    ["AK-47"] = 290,
}
local IllegalGunSelection = "Duct Tape"
local IllegalGunStoreCFrame = CFrame.new(-7997.30078, 88.0444946, -59.4273376, 0.0488396585, 0.0037649197, -0.998799562, -1.36487133e-05, 0.999992907, 0.00376875023, 0.998806655, -0.000170421816, 0.0488393642)

-- Hacker Store
local HackerGunStoreCFrame = CFrame.new(3953.0105, 54.5998917, -2351.16797, 0.998504162, 1.01816131e-05, -0.0546758622, -9.03107562e-08, 1, 0.000184246965, 0.0546758622, -0.000183965458, 0.998504162)
local HackerGunList = {"Hack"}

-- Bomb Store
local BombItemSelection
local BombShopCFrame = CFrame.new(6574.73389, 42.4794579, 186.288727, -0.957307696, -0.00134941505, 0.289067596, -1.77687652e-05, 0.99998939, 0.00460934127, -0.289070725, 0.00440742774, -0.957297564)
local BombShopList = {"TouchMine", "C4", "Dynamite"}
local BombShopPrices = {
    ["TouchMine"] = 500;
    ["C4"] = 800;
    ["Dynamite"] = 250;
}

-- Hacking Store
local HackItemSelected
local HackShopCFrame = CFrame.new(3956.12109, 54.5718307, -2354.34375, 0.999143243, 0.000299725478, 0.0413843021, -9.35609296e-06, 0.999975383, -0.00701647019, -0.0413853861, 0.007010072, 0.999118626)
local HackShopList = {"Criminal Placement", "Hack"}
local HackShopPrices = {
    ["Criminal Placement"] = 400,
    ["Hack"] = 200,
}

-- Car Store
local CarsList = {"BMW M5", "Ford Mustang Shelby GT500", "Van", "Crown Vic", "Benz S65 AMG Convertible", "Retro Ford Explorer", "Ford Explorer", "Dodge Charger", "Cadillac Escalade", "Honda Civic", "Taxi", "Audi A8", "Ford F-150", "Lexus LX", "Land Cruiser"}
local ExoticCarsList = {"Phantom", "Lamborghini Aventador", "Aston Martin DB10", "Ford GT", "La Ferrari", "Mercedes G Wagon"}
local CarPrices = {
    ["BMW M5"] = 2200,
    ["Ford Mustang Shelby GT500"] = 3500,
    ["Van"] = 650,
    ["Crown Vic"] = 500,
    ["Benz S65 AMG Convertible"] = 2700,
    ["Retro Ford Explorer"] = 300,
    ["Ford Explorer"] = 700,
    ["Dodge Charger"] = 1300,
    ["Cadillac Escalade"] = 2500,
    ["Honda Civic"] = 500,
    ["Taxi"] = 575,
    ["Audi A8"] = 3500,
    ["Ford F-150"] = 775,
    ["Lexus LX"] = 5000,
    ["Land Cruiser"] = 2500,
}
local ExoticCarPrices = {
    ["Phantom"] = 500,
    ["Lamborghini Aventador"] = 500,
    ["Aston Martin DB10"] = 500,
    ["Ford GT"] = 500,
    ["La Ferrari"] = 500,
    ["Mercedes G Wagon"] = 500,
}
local SelectedCarNormal
local SelectedCarExotic
local SelectedCarToSpawn
local ExoticCarGamepassID = 7006549
local CarShopCFrame = CFrame.new(2745.96582, 54.0710983, 279.605408, -0.973617375, -0.00156753196, -0.228181049, -8.46007788e-06, 0.999976635, -0.0068334653, 0.228186443, -0.00665125297, -0.973594666)
local CarSpawnCFrame = CFrame.new(2693.15405, 53.9715729, 181.84761, -0.00333632505, -0.00695545645, -0.999970257, -8.99662973e-06, 0.999975801, -0.0069554653, 0.999994457, -1.42081608e-05, -0.00333630666)
-- Hooks

-- Functions
local function CheckGamepass(Pack, Item, Id)
    if Pack == "Gun" and Id == GunPackID then
        for __, Gun in next, GunPackUnlocks do
            if Gun == Item then
                return true
            end
        end
    end
    return false
end

local function HideCharacter(Visibility)
    local Character = LocalPlayer.Character

    if Character then
        for __, Object in next, Character:GetChildren() do
            if Object then
                if Object:IsA("BasePart") and Object.Name ~= "HumanoidRootPart" then
                    if Visibility then
                        Object.Transparency = 1
                        if Object.Name == "Head" then
                            Object.face.Transparency = 1
                        end
                    else
                        Object.Transparency = 0
                        if Object.Name == "Head" then
                            Object.face.Transparency = 0
                        end
                    end
                end
            end
        end
    end
    return true
end

local function FireRemote(RemoteName, ...)
    if Remotes:FindFirstChild(RemoteName) then
        Remotes:FindFirstChild(RemoteName):FireServer(...)
    end
end

local function MoveCharacter(Goal, Return, Callback)
    Camera.CameraType = Enum.CameraType.Fixed
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local PreviousCFrame = Character.PrimaryPart.CFrame

    local TweenInformation = TweenInfo.new(0.05, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    local CharacterTween = TweenService:Create(Character.PrimaryPart, TweenInformation, {CFrame = Goal})

    HideCharacter(true)
    Character.PrimaryPart.Anchored = true
    CharacterTween:Play()
    CharacterTween.Completed:Connect(function(playbackState)
        Character.PrimaryPart.Anchored = false
        task.wait(0.22)
        Callback()
        if Return then
            local NewCharacterTween = TweenService:Create(Character.PrimaryPart, TweenInformation, {CFrame = PreviousCFrame})
            
            task.wait(0.1)
            Character.PrimaryPart.Anchored = true
            NewCharacterTween:Play()

            NewCharacterTween.Completed:Connect(function()
                task.wait()
                Camera.CameraType = Enum.CameraType.Custom
                Character.PrimaryPart.Anchored = false
                HideCharacter(false)
                return true
            end)
            return true
        else
            Camera.CameraType = Enum.CameraType.Custom
            HideCharacter(false)
            return true
        end
    end)
end
-- Menu Declarations
-- Config Tab
local ConfigurationTab = Menu:Tab("Config")
local DestroyUI = ConfigurationTab:Button("Destroy UI", function()
    CoreGui.helioslib:Destroy()
end)
local DestroyUIKeybind = ConfigurationTab:Textbox("Destroy UI Key", false, function(Text)
    if Enum.KeyCode[Text] then
        if DestroyKeyConnection then
            DestroyKeyConnection:Disconnect()
        end

        DestroyKeyConnection = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
            if inputObject.KeyCode == Enum.KeyCode[Text] and not gameProcessed then
                CoreGui.helioslib:Destroy()
                DestroyKeyConnection:Disconnect()
            end
        end)
    end
end)
ConfigurationTab:Spliter()
local TPLabel = ConfigurationTab:Label("Teleport Control")
local TargetForTeleport = ConfigurationTab:Textbox("Teleport Target", false, function(Text)
    local Target
    for __, Player in next, Players:GetPlayers() do
        if string.lower(Player.Name) == string.lower(Text) then
            Target = Player
        end
    end
    if Target then
        TargetPlayerForTeleport = Target
    else
        Helios:notification("Player not found! Did you type their name right?")
    end
end)
local TeleportKeybind = ConfigurationTab:Textbox("Teleport Keybind", false, function(Text)
    if Enum.KeyCode[Text] then
        if TeleportKeyConnection then
            TeleportKeyConnection:Disconnect()
        end

        TeleportKeyConnection = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
            if inputObject.KeyCode == Enum.KeyCode[Text] and not gameProcessed then
                local Location = TargetPlayerForTeleport.Character.PrimaryPart.CFrame
                local NewLocation = CFrame.new(Location * Vector3.new(0,4,0))

                MoveCharacter(NewLocation, false, function() end)
            end
        end)
    end
end)

local TeleportButton = ConfigurationTab:Button("Teleport", function()
    local Location = TargetPlayerForTeleport.Character.PrimaryPart.CFrame
    local NewLocation = CFrame.new(Location * Vector3.new(0,4,0))
    MoveCharacter(NewLocation, false, function() end)
end)
-- Bank Tab
local BankingTab = Menu:Tab("Bank")
BankingTab:Label("ATM")
local BankAmount = BankingTab:Textbox("Amount", false, function(Text)
    BankAmountVariable = Text
end)
local BankTarget = BankingTab:Textbox("Recipient", false, function(Text)
    BankTargetVariable = Text
end)
local TransferMoneyToPlayer = BankingTab:Button("Transfer Money", function()
    MoveCharacter(ATMCFrame, true, function()
        rconsoleprint(BankAmountVariable)
        if tonumber(BankAmountVariable) and tonumber(BankAmountVariable) ~= nil then
            if BankTargetVariable and Players:FindFirstChild(BankTargetVariable) then
                FireRemote("finance", "transfer", tonumber(BankAmountVariable), BankTargetVariable)
            end
        end
    end)
end)
local DepositMoney = BankingTab:Button("Deposit", function()
    MoveCharacter(ATMCFrame, true, function()
        if tonumber(BankAmountVariable) and tonumber(BankAmountVariable) ~= nil then
            FireRemote("finance", "deposit", tonumber(BankAmountVariable))
        end
    end)
end)
local WithdrawMoney = BankingTab:Button("Withdraw", function()
    MoveCharacter(ATMCFrame, true, function()
        if tonumber(BankAmountVariable) and tonumber(BankAmountVariable) ~= nil then
            FireRemote("finance", "withdraw", tonumber(BankAmountVariable))
        end
    end)
end)
BankingTab:Spliter()
BankingTab:Label("Fast Statements")
local DepositAll = BankingTab:Button("Deposit All", function()
    MoveCharacter(ATMCFrame, true, function()
        FireRemote("finance", "depositAll")
    end)
end)

local WithdrawAll = BankingTab:Button("Withdraw All", function()
    MoveCharacter(ATMCFrame, true, function()
        FireRemote("finance", "withdrawAll")
    end)
end)

-- Transport Tab
local TransportTab = Menu:Tab("Metro")
local TransportDrownDown = TransportTab:Dropdown("Location", LocationsForTransport, function(Selected)
    LocationSelectedForTransport = Selected
end)
local Transport = TransportTab:Button("Go", function()
    MoveCharacter(LocationCFramesForTransport[LocationSelectedForTransport], false, function() end)
end)

-- Gun Tab
local GunTableFrames = {}
local GunTab = Menu:Tab("Gun Shop")
GunTab:Label("Legal Gun Store")
local GunSelection = GunTab:Dropdown("Gun Selection", GunOptions, function(Selection)
    SelectedGun = Selection

    local HasGamepass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, GunPackID)
    local RequiresGamepass = CheckGamepass("Gun", Selection, GunPackID)
    if not HasGamepass and RequiresGamepass then
        GunTableFrames.Price:Change("Weapon not unlocked!")
        Helios:notification("Warning: You do not have the gamepass for this weapon! People will be able to find out you're cheating!")
    else
        GunTableFrames.Price:Change("Price: " .. GunCosts[Selection])
    end
end)

GunTableFrames.Price = GunTab:Label("Price: ")
GunTableFrames.Purchase = GunTab:Button("Buy Gun", function()
    MoveCharacter(GunshopCFrame, true, function()
        FireRemote("finance", "processPurchase", SelectedGun, "tools", "Gun")
    end)
end)
GunTab:Spliter()
-- Illegal Guns
local IllegalGunFrames = {}
GunTab:Label("Illegal Gun Store")
local IllegalGunSelection = GunTab:Dropdown("Item Selection", IllegalGunList, function(Selected)
    IllegalItemSelection = Selected
    IllegalGunFrames.IllegalItemPrice:Change("Price: " .. IllegalPriceList[Selected])
end)
IllegalGunFrames.IllegalItemPrice = GunTab:Label("Price: ")
IllegalGunFrames.PurchaseIllegalItem = GunTab:Button("Buy Item", function()
    MoveCharacter(IllegalGunStoreCFrame, true, function()
        FireRemote("finance", "processPurchase", IllegalItemSelection, "tools", "Dealer")
    end)
end)
-- Bomb Store
GunTab:Spliter()
local BombGunFrames = {}
GunTab:Label("Bombs Store")
local BombSelection = GunTab:Dropdown("Bomb Selection", BombShopList, function(Selected)
    BombItemSelection = Selected
    BombGunFrames.BombItemPrice:Change("Price: " .. BombShopPrices[Selected])
end)
BombGunFrames.BombItemPrice = GunTab:Label("Price: ")
BombGunFrames.PurchaseBomb = GunTab:Button("Buy Item", function()
    MoveCharacter(BombShopCFrame, true, function()
        FireRemote("finance", "processPurchase", BombItemSelection, "tools", "Dealer")
    end)
end)
GunTab:Spliter()
local HackingStoreFrames = {}
GunTab:Label("Criminal Store")
local HackSelection = GunTab:Dropdown("Item Selection", HackShopList, function(Selected)
    HackItemSelected = Selected
    HackingStoreFrames.HackItemPrice:Change("Price: " .. HackShopPrices[Selected])
end)
HackingStoreFrames.HackItemPrice = GunTab:Label("Price: ")
HackingStoreFrames.PurchaseHack = GunTab:Button("Buy Item", function()
    MoveCharacter(HackShopCFrame, true, function()
        FireRemote("finance", "processPurchase", HackItemSelected, "tools", "Dealer")
    end)
end)

-- Car Store
local CarTab = Menu:Tab("Car Control")
local CarTableFrames = {}
local CarLabel = CarTab:Label("Car Store")
local CarSelectionFunction = CarTab:Dropdown("Normal Car Selection", CarsList, function(Selection)
    SelectedCarNormal = Selection
    CarTableFrames.Price:Change("Price: " .. CarPrices[Selection])
end)
CarTableFrames.Price = CarTab:Label("Price: ")
CarTableFrames.Purchase = CarTab:Button("Purchase Car", function()
    MoveCharacter(CarShopCFrame, true, function()
        FireRemote("finance", "processPurchase", SelectedCarNormal, "cars", "Car")
    end)
end)
CarTab:Spliter()
local ExoticCarTableFrames = {}
local ExoticCarSelectionFunction = CarTab:Dropdown("Exotic Car Selection", ExoticCarsList, function(Selection)
    SelectedCarExotic = Selection
    local HasGamepass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, ExoticCarGamepassID)

    if not HasGamepass then
        Helios:notification("Warning: You do not have the gamepass for this car! People will be able to find out you're cheating!")
    end
    ExoticCarTableFrames.Price:Change("Price: " .. ExoticCarPrices[Selection])
end)
ExoticCarTableFrames.Price = CarTab:Label("Price: ")
ExoticCarTableFrames.Purchase = CarTab:Button("Purchase Exotic Car", function()
    MoveCharacter(CarShopCFrame, true, function()
        FireRemote("finance", "processPurchase", SelectedCarExotic, "cars", "Car")
    end)
end)
CarTab:Spliter()
CarTab:Label("Car Control")
local CarName = CarTab:Textbox("Car Name", false, function(Text)
    local isCar = false
    for __, name in next, CarsList do
        if Text == name then
            isCar = true
        end
    end
    for __, name in next, ExoticCarsList do
        if Text == name then
            isCar = true
        end
    end
    if isCar then
        SelectedCarToSpawn = Text
    else
        Helios:notification("Invalid car name")
    end
end)
local SpawnCar = CarTab:Button("Spawn Car", function()
    local Initial = LocalPlayer.Character.PrimaryPart.CFrame
    MoveCharacter(CarSpawnCFrame, false, function()
        task.wait(0.4)
        FireRemote("gameplay", "requestCar", SelectedCarToSpawn)
    end)
end)
--
