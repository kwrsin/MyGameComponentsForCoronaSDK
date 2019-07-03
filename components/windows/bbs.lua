local utf8 = require('plugin.utf8')

local M = {}

function M.createBBS(parant, x, y, rows, cols, font_name, size, frame_path, command_queue)
  local offset_group = display.newGroup()
  local characters = {}
  for row = 1, rows do
    for col = 1, cols do
      local xx = (col - 1) * size
      local yy = (row - 1) * size
      local character = display.newText(offset_group, "", xx, yy, font_name, size)
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
      character.init_x = xx
      character.init_y = yy
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
  M.characters_offset = 0
  M.command_queue = command_queue
end

function M:clearBBS()
  self.command_queue:regist_command(function()
    timer.performWithDelay(500, function()
      for i = 1, #self.characters do
        self.characters[i].text = "X"
        self.characters[i].x = self.characters[i].init_x
        self.characters[i].y = self.characters[i].init_y
      end

      self.output_count = 0
      self.characters_index = -1
      for i in pairs (self.timer_id_list) do
        self.timer_id_list[i] = nil
      end
      self.offset_group.y = 0
      self.characters_offset = 0
      self.command_queue:clear_current_command()

    end)
  end)
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
        transition.to(self.offset_group, {time=100, y=-self.size * (self.characters_offset + 1), transition=easing.linear, onComplete=function()
          local characters_offset = self.characters_offset
          for i = 1, self.cols do
            local character = self.characters[(characters_offset * self.cols) + i]
            character.text = "ー"
            character.y = character.y + (self.rows * self.size)
          end

          self.characters_offset = (self.characters_offset + 1) % self.rows
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