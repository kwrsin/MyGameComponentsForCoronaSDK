local utf8 = require('plugin.utf8')

local M = {}

function M.createBBS(parant, x, y, rows, cols, font_name, size, frame_path, command_queue)
  local characters = {}
  for row = 1, rows do
    for col = 1, cols do
      local character = display.newText(parant, "C", (col - 1) * size, (row - 1) * size, font_name, size)
      -- if col == 1 then
      --   character.is_line_head = true
      -- else
      --   character.is_line_head = false
      -- end
      if col == cols then
        character.is_line_end = true
      else
        character.is_line_end = false
      end
      table.insert(characters, character)
    end
  end

  M.rows = rows
  M.cols = cols
  M.font_name = font_name
  M.size = size
  M.characters = characters
  M.characters_index = -1
  M.prompt_icon_path = nil
  M.timer_id_list = {}
  M.command_queue = command_queue
end

function M:clearBBS()
  for i = 1, #self.characters do
    self.characters[i].text = ""
  end
end

function M:get_next_characters_index()
  local next_index = self.characters_index + 1
  self.characters_index = next_index % (self.rows * self.cols)
  return self.characters_index + 1
end

function M:say(actor, serif, speed, sound, onAsk, onActorAction)
  local function to_serif_array(serif)
    local serif_array = {}
    for i = 1, utf8.len(serif) do
      table.insert(serif_array, utf8.sub(serif, i, i))
    end
    return serif_array
  end
  self.command_queue:regist_command(function()
    local serif_array = to_serif_array(serif)
    local timer_id = timer.performWithDelay(speed, function(event)
      local v = table.remove(serif_array, 1)
      local character = self.characters[self:get_next_characters_index()]
      if v == "\n" then
        while character.is_line_end == false do
          character = self.characters[self:get_next_characters_index()]
          if character.is_line_end then
            break
          end
        end
        -- character.text = v
      else
        character.text = v
      end
      if #serif_array <= 0 then
        self.command_queue:clear_current_command()
      end
    end, #serif_array)
    table.insert(self.timer_id_list, timer_id)
  end)

end


return M