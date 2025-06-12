local KeySets = {}
KeySets.__index = KeySets

function KeySets.new(Instance)
    local KeySet = setmetatable({}, KeySets)

    KeySet.Instance = Instance
    KeySet.Keyframes = {}

    return KeySet
end


return KeySets