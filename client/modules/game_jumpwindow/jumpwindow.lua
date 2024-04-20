jumpWindow = nil
jumpButton = nil
jumpUpdateEvent = nil

paddingTop = 10
paddingBottom = 10
buttonWidth = 1
buttonHeight = 1

function init()
    jumpwindowButton = modules.client_topmenu.addLeftGameButton('jumpwindowButton', tr('Jump Window'), '/images/topbuttons/hotkeys', toggle)

    jumpWindow = g_ui.displayUI('jumpwindow')
    jumpWindow:setVisible(false)

    connect(g_game, { onGameEnd = destroyWindow })

    jumpButton = jumpWindow:getChildById("jumpButton")
    buttonWidth = jumpButton:getWidth()
    buttonHeight = jumpButton:getHeight()
    paddingTop = jumpWindow:getPaddingTop()
    paddingBottom = jumpWindow:getPaddingBottom()
    paddingLeft = jumpWindow:getPaddingLeft()
    paddingRight = jumpWindow:getPaddingRight()
    resetJumpButton()

    jumpUpdateEvent = cycleEvent(updateButton, 80)
end

function show()
  jumpWindow:show()
  jumpWindow:raise()
  jumpWindow:focus()
end

function hide()
  jumpWindow:hide()
end

function toggle()
  if not jumpWindow:isVisible() then
    show()
  else
    hide()
  end
end

function terminate()
    disconnect(g_game, { onGameEnd = destroyWindow })

    destroyWindow()

    jumpUpdateEvent:cancel()
end

function destroyWindow()
    jumpWindow:destroy()
end

-- make the button scroll across the window
function updateButton()
    local wx = jumpWindow:getX()
    local x = jumpButton:getX() - wx
    x = x - 10
    if x < paddingLeft then
        resetJumpButton()
    else
        jumpButton:setX(wx + x)
    end
end

-- reset the button to the right edge with a random vertical position
function resetJumpButton()
    local wx = jumpWindow:getX()
    local wy = jumpWindow:getY()
    local width = jumpWindow:getWidth()
    local height = jumpWindow:getHeight()
    local x = wx + width - buttonWidth - paddingRight
    local y = wy + math.random(margin + paddingTop, height - buttonHeight - paddingBottom)
    jumpButton:setX(x)
    jumpButton:setY(y)
end
