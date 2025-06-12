local module = {}
module.__index = module

function module.GetFrame(KeySet, Time, CurrentFrame)
    local Frame = nil
    for _,v in KeySet:GetChildren() do
        if v.Name ~= "Instance" then
            local FrameTime = v:GetAttribute("Time")
            local BiggerThanCurrent = true

            if CurrentFrame then
                if FrameTime <= CurrentFrame:GetAttribute("Time") then
                    BiggerThanCurrent = false
                end  
            end
            

            if BiggerThanCurrent == true then
                if FrameTime >= Time then
                    if Frame then
                        if FrameTime < Frame:GetAttribute("Time") then
                            Frame = v
                        end
                    else
                        Frame = v
                    end
                end
            end
        end
    end

    return Frame
end

function module.GetPosition(KeySet, Time)
    local CurrentFrame : CFrameValue = module.GetFrame(KeySet, Time)
    local NextFrame : CFrameValue = module.GetFrame(KeySet, Time, CurrentFrame)

    local LerpPercent

    if CurrentFrame:GetAttribute("Time") ~= NextFrame:GetAttribute("Time") then
        LerpPercent = (Time-CurrentFrame:GetAttribute("Time"))/(NextFrame:GetAttribute("Time")-CurrentFrame:GetAttribute("Time"))
    else
        LerpPercent = 1
    end

    local Position = CurrentFrame.Value:Lerp(NextFrame.Value, LerpPercent)

    return Position
end

function module.ReplaySingleFrame(File : Folder, Time : number, clones)
    local Clones = {}
    for _,v : ObjectValue in File:GetChildren() do

        local Archivable = v:FindFirstChild("Instance").Archivable

        if Archivable == false then
            v:FindFirstChild("Instance").Archivable = true
        end
        local Part = v:FindFirstChild("Instance"):Clone()
        Part.Parent = workspace
        v:FindFirstChild("Instance").Archivable = Archivable

        if Part:IsA("BasePart") then
            Part.Anchored = true
        end

        for _,v in pairs(Part:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = true
            end
        end

        table.insert(Clones, Part)

        local Position = module.GetPosition(v, Time)

        if Part:IsA("BasePart") then
            Part.Position = Position
        elseif Part:IsA("Model") then
            Part:PivotTo(Position)
        end
    end

    return Clones
end

return module