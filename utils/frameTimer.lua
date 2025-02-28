local FrameTimer = {}
FrameTimer.__index = FrameTimer

function FrameTimer:new(frameRate, totalFrames)
    local obj = {
        frameRate = frameRate or 10, -- 默认每秒10帧
        elapsedTime = 0,
        currentFrame = 1,
        totalFrames = totalFrames or 1
    }
    setmetatable(obj, FrameTimer)

    self.frameTime = 1 / obj.frameRate

    return obj
end

function FrameTimer:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= self.frameTime then
        self.elapsedTime = self.elapsedTime - self.frameTime
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > self.totalFrames then
            self.currentFrame = 1  -- 循环播放
        end
    end
end

return FrameTimer
