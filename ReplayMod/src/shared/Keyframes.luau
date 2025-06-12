local Keyframes = {}
Keyframes.__index = Keyframes

function Keyframes.new(Time, CFrame)
    local Keyframe = setmetatable({}, Keyframes)

    Keyframe.Time = Time
    Keyframe.CFrame = CFrame

    return Keyframe
end

return Keyframes