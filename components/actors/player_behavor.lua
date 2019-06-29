local M = require("components.actors.base_behavor")()

M.object_sheets_index = 2
M.sequences = {
  { name="up",    sheet_number=2, frames={ 0 + 1,  0 + 2}, time=220, loopCount=0 },
  { name="right", sheet_number=2, frames={32 + 1, 32 + 2}, time=220, loopCount=0 },
  { name="down",  sheet_number=2, frames={64 + 1, 64 + 2}, time=220, loopCount=0 },
  { name="left",  sheet_number=2, frames={96 + 1, 96 + 2}, time=220, loopCount=0 }
}

function M:Defensive()
    print("oraoraora")
    -- M:up()
    coroutine.yield()

    return M:Offensive()
end

function M:Offensive()
    print("mudamudamuda")
    -- M:down()
    coroutine.yield()

    return M:Defensive()
end


return M