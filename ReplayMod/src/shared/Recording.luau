local RunService = game:GetService("RunService")
local ReplayMod = {}
ReplayMod.__index = ReplayMod
local KeySets = require(game.ReplicatedStorage.Shared.KeySets)
local Keyframes = require(game.ReplicatedStorage.Shared.Keyframes)

local DefaultConfig = {InstanceSet = {}, FixPlayerRigs = true}

function ReplayMod.CreateReplay(config)
    local Replay = setmetatable({}, ReplayMod)

    Replay.Name = "New Replay"
    Replay.KeySets = {}
    Replay.Config = config or DefaultConfig
    Replay.CurrentTime = 0
    Replay.Length = 0
    Replay.Recording = false
    Replay.InstancesToRecord = Replay.Config.InstanceSet

    return Replay
end

function ReplayMod:StartRecording()
    RunService:BindToRenderStep("Replay: " .. self.Name, 1, function(delta)
        -- Control Timer 
        self.CurrentTime += delta
        self.Length = self.CurrentTime

        -- If Keyset doesnt exist then create it
        for _,i in self.InstancesToRecord do
            local AlrInSet = false
            for _,v in self.KeySets do
                if i == v.Instance then
                    AlrInSet = true
                end
            end

            if AlrInSet == false then
                table.insert(self.KeySets, KeySets.new(i))
            end
        end

        -- Insert Keyframes
        for _,v in self.KeySets do
            if v.Instance:IsA("BasePart") then
                table.insert(v.Keyframes, Keyframes.new(self.CurrentTime, v.Instance.CFrame))
            elseif v.Instance:IsA("Model") then
                if v.Instance.PrimaryPart then
                    table.insert(v.Keyframes, Keyframes.new(self.CurrentTime, v.Instance.PrimaryPart.CFrame))
                end
            end
        end
    end)
end

function ReplayMod:StopRecording()
    RunService:UnbindFromRenderStep("Replay: " .. self.Name)
end

function ReplayMod:SaveRecording()
    print("saving")
    local newsavefolder = Instance.new("Folder")
    newsavefolder.Name = "ReplayModSaves"

    local saves = game.ReplicatedStorage:FindFirstChild("ReplayModSaves") or newsavefolder

    saves.Parent = game.ReplicatedStorage

    local file = Instance.new("Folder")
    file.Name = self.Name
    file:SetAttribute("Name", self.Name)
    file:SetAttribute("Length", self.Length)
    file:SetAttribute("Date", os.time())
    file.Parent = saves

    for _,i in self.KeySets do
        print(i)

        local Part = i.Instance
        
        local Keyset = Instance.new("ObjectValue")
        Keyset.Name = Part.Name
        Keyset.Value = Part

        local OgValue = Part.Archivable
        Part.Archivable = true

        local IsHuman = false
        for _,v in game.Players:GetPlayers() do
            if v.Character == Part then
                IsHuman = true
            end
        end

        if (self.Config.FixPlayerRigs == false) or (IsHuman == false)  then
            local Clone = Part:Clone()
            Clone.Parent = Keyset
            Clone.Name = "Instance"
        else
            local Clone = Part:Clone()
            Clone.Parent = Keyset
            Clone.Name = "Instance"
        end


        Part.Archivable = OgValue
        

        for _,v in i.Keyframes do
            local key = Instance.new("CFrameValue")
            key.Value = v.CFrame
            key:SetAttribute("Time", v.Time)
            key.Parent = Keyset
        end

        Keyset.Parent = file
        task.wait()
    end
    print("saved!")

    return file
end

return ReplayMod