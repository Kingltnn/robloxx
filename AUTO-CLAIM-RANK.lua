local save = require(game:GetService("ReplicatedStorage").Library.Client.Save).Get
local network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local rankCmds = require(game:GetService("ReplicatedStorage").Library.Client.RankCmds)

while task.wait(15) do
    local totalStars = 0
    for i,v in require(game:GetService("ReplicatedStorage").Library.Directory.Ranks)[rankCmds.GetTitle()]["Rewards"] do
        totalStars += v["StarsRequired"]
        if save()["RankStars"] >= totalStars and not save()["RedeemedRankRewards"][tostring(i)] then
            network.Fire("Ranks_ClaimReward", i)
            task.wait(.5)
        end
    end
end
