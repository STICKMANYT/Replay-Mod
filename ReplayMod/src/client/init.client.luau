local Recording = require(game.ReplicatedStorage.Shared.Recording)
local config = {InstanceSet = {}, FixPlayerRigs = true}

wait(5)

for _,v in game.Players:GetPlayers() do
    table.insert(config.InstanceSet, v.Character)
end

local Replay = Recording.CreateReplay(config)
Replay.Name = "Test Replay"
Replay:StartRecording()
wait(2.5)
Replay:StopRecording()
local save = Replay:SaveRecording()

local Replaying = require(game.ReplicatedStorage.Shared.Replaying)
Replaying.ReplaySingleFrame(save, 1)