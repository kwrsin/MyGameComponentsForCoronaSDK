local utf8 = require('plugin.utf8')

local M = {}

function M.createBBS(parant, x, y, rows, cols, font_name, size, frame_path, command_queue)
  local offset_group = display.newGroup()
  local characters = {}
  for row = 1, rows do
    for col = 1, cols do
      local character = display.newText(offset_group, "C", (col - 1) * size, (row - 1) * size, font_name, size)
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

  if parent then
    parent:insert(offset_group)
  end

  M.rows = rows
  M.cols = cols
  M.font_name = font_name
  M.size = size
  M.characters = characters
  M.output_count = 0
  M.characters_index = -1
  M.prompt_icon_path = nil
  M.timer_id_list = {}
  M.offset_group = offset_group
  M.command_queue = command_queue
  M.reorder_index = 0
end

function M:clearBBS()
  for i = 1, #self.characters do
    self.characters[i].text = ""
  end
  -- self.characters_index = -1
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
      local next_characters_index = self:get_next_characters_index()
      local character = self.characters[next_characters_index]
      if v == "\n" then
        while character.is_line_end == false do
          next_characters_index = self:get_next_characters_index()
          character = self.characters[next_characters_index]
          self.output_count = self.output_count + 1
          if character.is_line_end then
            break
          end
        end
        -- character.text = v
      else
        character.text = v
        self.output_count = self.output_count + 1
      end

      -- scroll line by line
      if self.output_count > (self.rows - 1) * self.cols and character.is_line_end then
        transition.to(self.offset_group, {time=100, y=-self.size * (self.reorder_index + 1), transition=easing.linear, onComplete=function()
          local reorder_index = self.reorder_index
          for i = 1, self.cols do
            local character = self.characters[(reorder_index * self.cols) + i]
            character.text = "-"
            character.y = character.y + (self.rows * self.size)
          end

          self.reorder_index = (self.reorder_index + 1) % self.rows
        end})
      end
      if #serif_array <= 0 then
        self.command_queue:clear_current_command()
      end
    end, #serif_array)
    table.insert(self.timer_id_list, timer_id)
  end)

end


return M