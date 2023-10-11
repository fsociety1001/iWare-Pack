print('v2')
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Crimson Craftwars", 5013109572)
getfenv().notifications = false

local themes = {
Background = Color3.fromRGB(24, 24, 24),
Glow = Color3.fromRGB(0, 0, 0),
Accent = Color3.fromRGB(10, 10, 10),
LightContrast = Color3.fromRGB(20, 20, 20),
DarkContrast = Color3.fromRGB(14, 14, 14),  
TextColor = Color3.fromRGB(255, 255, 255)
}

function Notify(...)
    local args = {...}
    local title = args[1]
    local desc = args[2]
    local bypassnotiftoggle = args[3]
    
    if bypassnotiftoggle == nil then
        bypassnotiftoggle = false
    end

    local CanSend = getfenv().notifications

    if bypassnotiftoggle == true then
        CanSend = true
    end

    if CanSend == true then
    venyx:Notify(title, desc)
    end
end

local page = venyx:addPage("Main", 5012544693)
local section1 = page:addSection("Autofarming")
local section2 = page:addSection("Character Settings")


section1:addToggle("Mob Autofarm", nil, function(value)
getfenv().mobautofarming = value
Notify("Success", string.format('Mob autofarming is now toggled %s', tostring(value)))
end)
section1:addToggle("Notifications", nil, function(value)
    getfenv().notifications = value
    Notify("Success", string.format('Notifications is now toggled %s', tostring(value)), true)
end)
section1:addToggle("Ore Autofarm", nil, function(value)
    getfenv().oreautofarming = value
    if getfenv().notifications == true then
    Notify("Success", string.format('Ore autofarming is now toggled %s', tostring(value)))
    end
 end)
section1:addButton("Goto Merchant", function()
if game.Workspace.J:FindFirstChildOfClass("Model") then
-- Found Merchant, check for player
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.J:FindFirstChildOfClass("Model").Torso.CFrame
else
    Notify('Error', "You don't have a torso.")
end
else
    Notify("Error", "The hidden merchant isn't in this server.")
end
end)
section1:addButton("God mode", function()
    
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        local args = {
            [1] = 'hit';
            [2] = {
                game.Players.LocalPlayer.Character.Humanoid;
                -9e308
            }
        }
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").RemoteFunction:InvokeServer(unpack(args))
    else
        venyx:Notify('Error', "You need to be holding a weapon.", 2)
    end
    
    end)
section2:addTextbox("Walkspeed", "16", function(value, focusLost)

    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(value)

end)
section2:addTextbox("JumpPower", "50", function(value, focusLost)

    game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(value)

end)

local theme = venyx:addPage("Theme", 5012544693)
local colors = theme:addSection("Colors")

for theme, color in pairs(themes) do
colors:addColorPicker(theme, color, function(color3)
venyx:setTheme(theme, color3)
end)
end

-- load
venyx:SelectPage(venyx.pages[1], true)


function kill(humanoid, remote)
    local args = {
        [1] = 'hit';
        [2] = {
            humanoid;
            math.huge
        }
    }
    remote:InvokeServer(unpack(args))
end


while wait() do
    local character = game.Players.LocalPlayer.Character
    
    if character then
        local tool = character:FindFirstChildOfClass("Tool")

        if tool and tool:FindFirstChildOfClass("RemoteFunction") then
            
            if getfenv().mobautofarming == true then
                for i, v in pairs(workspace:GetDescendants()) do
                    delay(0, function()
                    if v.Name == 'Humanoid' and not game.Players:GetPlayerFromCharacter(v.Parent) then
                        kill(v, tool:FindFirstChildOfClass('RemoteFunction'))
                    end
                end)
                end
                
            end
            if getfenv().oreautofarming == true then
            for i, v in pairs(workspace:GetDescendants()) do
                delay(0, function()
                    if v.Name == 'Ore' then
                        kill(v, tool:FindFirstChildOfClass('RemoteFunction'))
                    end
                end)
                end

            end
        end
    end
end
