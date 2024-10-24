local NarratorManager = require("com.yahaha.sdk.horrorgame.scripts.ui.NarratorManager")
local packagePrefix = "com.yahaha.community.horrorext."

---@class Conversation
---@field isShowing boolean
isShowing = false
local currentIndex
local lastIndex = -1
local currentShowTime

local narratorData = {}
narratorData.InstanceID = script.GetInstanceId()
narratorData.shotType = "bottom"
narratorData.autoHideTime = 999

local function RefreshNarratorData()
    local textConfig = script.fields.content[currentIndex]
    if textConfig then
        narratorData.title = textConfig.title
        narratorData.text = textConfig.text
        narratorData.openAudio = textConfig.audio
        yahaha.EventSystem:NotifyGlobalEventNow("YaNarrator_ShowNarrator", narratorData)
        yahaha.EventSystem:NotifyObjectEventNow(script.gameObject, packagePrefix .. "ConversationIndexChanged")
    end
end

function StartConversation()
    if isShowing then
        return
    end

    isShowing = true

    currentIndex = 1
    lastIndex = -1
    currentShowTime = 0
    RefreshNarratorData()
    yahaha.EventSystem:NotifyObjectEventNow(script.gameObject, packagePrefix .. "ConversationStarted")
end

function CancelConversation()
    if not isShowing then
        return
    end
    isShowing = false
    yahaha.EventSystem:NotifyGlobalEventNow("YaNarrator_HideNarrator", narratorData)
    yahaha.EventSystem:NotifyObjectEventNow(script.gameObject, packagePrefix .. "ConversationCanceled")
end

function IsConversationIndexEquals(index)
    if not isShowing then
        return false
    end
    return index == currentIndex
end

script.OnUpdate(function (deltaTime)
    if not isShowing then
        return
    end

    local textConfig = script.fields.content[currentIndex]
    if not textConfig then
        isShowing = false
        yahaha.EventSystem:NotifyGlobalEventNow("YaNarrator_HideNarrator", narratorData)
        yahaha.EventSystem:NotifyObjectEventNow(script.gameObject, packagePrefix .. "ConversationFinished")
        return
    end
    currentShowTime = currentShowTime + deltaTime
    if currentShowTime > textConfig.showSeconds then
        currentShowTime = 0
        currentIndex = currentIndex + 1
        RefreshNarratorData()
    end
end)


local function Dispose()
    NarratorManager.DisposeNarrator(narratorData)
end

script.OnEnable(function()
    NarratorManager.Init()
end)

script.OnDispose(function()
    Dispose()
end)