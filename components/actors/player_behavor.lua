local M = require("components.actors.base_behavor")()


function M:Defensive()
    print("oraoraora")
    coroutine.yield()

    return M:Offensive()
end

function M:Offensive()
    print("mudamudamuda")
    coroutine.yield()

    return M:Defensive()
end





return M