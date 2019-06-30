local M = {}

function M:load_tilemap(layer_object, path, map_options, physics)
  local function separate_path(pt)
    local directory
    local filename
    local p = string.gsub(pt, "%.", "/")
    local idx = string.find(p, "%/", -#p)
    directory = string.sub(p, 1, idx - 1)
    if directory then
      directory = directory .. "/"
    end
    filename = string.sub(p, idx + 1, #p)

    return directory, filename
  end


  local d, f = separate_path(path)
  self.tilemap = require(path)
  self.tilemap.layer_objects = display.newGroup()
  self.physics = physics

  self:create_tileset_objects(d)

  self:create_layer_objects(layer_object, map_options)

  return self.tilemap
end


function M:create_tileset_objects(directory)
  local function get_sheet_options(tileset)
    local frames = {}
    local columns = math.floor(tileset.imagewidth / tileset.tilewidth)
    local rows = math.floor(tileset.imageheight / tileset.tileheight)

    for row = 1, rows do
      for column = 1, columns do
        local frame = {}
        frame.x = (column - 1) * tileset.tilewidth
        frame.y = (row - 1) * tileset.tileheight
        frame.width = tileset.tilewidth
        frame.height = tileset.tileheight
        table.insert(frames, frame)
      end
    end

    return {
      frames = frames
    }
  end

  for i, t in ipairs(self.tilemap.tilesets) do
    local sheetOptions = get_sheet_options(t)
    local objectSheet = graphics.newImageSheet(directory .. t.image, sheetOptions)
    t.object_sheet = objectSheet
  end
end

function M:create_layer_objects(layer_object, map_options)
  local function get_tileset(gid)
    local offset = 0
    local tileset_id = 1
    for i, t in ipairs(self.tilemap.tilesets) do
      if gid >= t.firstgid and gid <= t.tilecount + offset then
        return t, tileset_id
      end
      tileset_id = tileset_id + 1 
      offset = offset + t.tilecount
    end
    return nil, tileset_id
  end

  local function get_tile(local_id, tiles)
    local local_id_ = local_id - 1
    for i, tile in ipairs(tiles) do
      if tile.id == tonumber(local_id_) then
        return tile
      end
    end
    return nil
  end

  local function create_game_object(layer_object, local_id, width, height, tile, object_sheet, onTouch)
    local object
    if tile == nil or not tile.animation then
      object = display.newImageRect(layer_object, object_sheet, local_id, width, height)
    elseif tile.animation then
      local sequences = {}
      for i, anim in ipairs(tile.animation) do
        local seq = {}
        seq.name = tostring(i - 1)
        seq.frames = {anim.tileid + 1}
        -- seq.count = 1
        seq.time = anim.duration
        seq.loopCount = 1
        table.insert(sequences, seq)
      end
      object = display.newSprite(layer_object, object_sheet, sequences)
      object.seq_index = 0
      object:play()
      local function spriteListener(event)
        local sp = event.target
        if event.phase == "ended" then
          sp.seq_index = sp.seq_index + 1
          local next_index = sp.seq_index % #sequences

          local seq_name = tostring(next_index)
          sp:setSequence(seq_name)
          sp:play()
        end
      end
      object:addEventListener("sprite", spriteListener)
    end

    if onTouch then
      object:addEventListener('touch', onTouch)
    end

    return object
  end

  local function addBody(game_object, body_type, objectGroup)
    local body_type = body_type or "static"
    if  #objectGroup.objects > 0 then
    else
      self.physics.addBody(game_object, body_type, objectGroup.properties)
    end
  end

  local function create_tile(layer_object, gid, row, col, grid_id, layer_id, onCreateGameObject, onTouch, onLocalCollision, onPreCollision, onPostCollision)
    local game_object = nil
    local tileset, tileset_id = get_tileset(gid)
    local layer = self.tilemap.layers[layer_id]
    local width = tileset.tilewidth
    local height = tileset.tileheight
    local local_id = gid - tileset.firstgid + 1
    local tile = get_tile(local_id, tileset.tiles)
    if onCreateGameObject then
      game_object = onCreateGameObject(layer_object, local_id, width, height, tile, tileset.object_sheet, layer, onTouch)
    end
    if game_object == nil then
      game_object = create_game_object(layer_object, local_id, width, height, tile, tileset.object_sheet, onTouch)
    end

    if game_object == nil then
      print(string.format("could not create a game object %d", gid))
      return nil
    end
    game_object.x = (col - 1) * width
    game_object.y = (row - 1) * height
    game_object.identifier = grid_id
    game_object.layer_name = layer.name
    game_object.gid = gid
    game_object.tileset_id = tileset_id


    if self.physics then
      if tile and tile.objectGroup and tile.properties then          
        addBody(game_object, tile.properties.bodyType, tile.objectGroup)
        if onLocalCollision then
          game_object.collision = onLocalCollision
          game_object:addEventListener("collision")
        end
        if onPreCollision then
          game_object.collision = onPreCollision
          game_object:addEventListener("preCollision")
        end
        if onPostCollision then
          game_object.collision = onPostCollision
          game_object:addEventListener("postCollision")
        end
      end
    end

    return game_object
  end

  local function create_tiles(layer_object, layer_id, options)
    local function onParse(data) return data end
    local onCreateGameObject = nil
    local onTouch = nil
    local onLocalCollision = nil
    local onPreCollision = nil
    local onPostCollision = nil
    local l = self.tilemap.layers[layer_id]
    local game_objects = {}
    if options then
      if options.onParse then
        onParse = options.onParse
      end

      if options.onCreateGameObject then
        onCreateGameObject = options.onCreateGameObject
      end

      if options.onTouch then
        onTouch = options.onTouch
      end

      if options.onLocalCollision then
        onLocalCollision = options.onLocalCollision
      end

      if options.onPreCollision then
        onPreCollision = options.onPreCollision
      end

      if options.onPostCollision then
        onPostCollision = options.onPostCollision
      end
    end

    local text_data = onParse(l.data)
    local inc = 1
    for i = 1, l.height do
      for j = 1, l.width do
        local game_object = nil
        if text_data[inc] > 0 then
          game_object = create_tile(layer_object, text_data[inc], i, j, inc, layer_id, onCreateGameObject, onTouch, onLocalCollision, onPreCollision, onPostCollision)
        end
        table.insert(game_objects, game_object)
        inc = inc + 1
      end
    end
    return game_objects
    
  end

  local function create_tilelayer(layer_object, layer_id, options)
    if self.tilemap.orientation == "orthogonal" then
      self.tilemap.layers[layer_id].game_objects = create_tiles(layer_object, layer_id, options)
    elseif self.tilemap.orientation == "hexagonal" then
    end
  end

  local function create_objectlayer(layer_object, layer_id, options)
    local game_objects = {}
    local l = self.tilemap.layers[layer_id]
    local onCreateGameObject = nil
    local onTouch = nil
    local onLocalCollision = nil
    local onPreCollision = nil
    local onPostCollision = nil

    if options then
      if options.onCreateGameObject then
        onCreateGameObject = options.onCreateGameObject
      end

      if options.onTouch then
        onTouch = options.onTouch
      end

      if options.onLocalCollision then
        onLocalCollision = options.onLocalCollision
      end

      if options.onPreCollision then
        onPreCollision = options.onPreCollision
      end
      
      if options.postCollision then
        postCollision = options.postCollision
      end
    end
    for i, object in ipairs(l.objects) do
      local game_object = nil
      local gid = object.gid
      local tileset, tileset_id = get_tileset(gid)
      local width = tileset.tilewidth
      local height = tileset.tileheight
      local local_id = gid - tileset.firstgid + 1
      local tile = get_tile(local_id, tileset.tiles)
      if onCreateGameObject then
        game_object = onCreateGameObject(layer_object, local_id, width, height, tile, tileset.object_sheet, l, onTouch)
      end
      if game_object == nil then
        game_object = create_game_object(layer_object, local_id, width, height, tile, tileset.object_sheet, onTouch)
      end

      if game_object == nil then
        print(string.format("could not create a game object %d", gid))
        return nil
      end

      game_object.x = object.x
      game_object.y = object.y
      game_object.identifier = i
      game_object.layer_name = l.name
      game_object.gid = gid
      game_object.tileset_id = tileset_id

      if self.physics then
        if tile and tile.objectGroup and object.properties then
          addBody(game_object, object.properties.bodyType, tile.objectGroup)
          if onLocalCollision then
            game_object.collision = onLocalCollision
            game_object:addEventListener("collision")
          end
          if onPreCollision then
            game_object.collision = onPreCollision
            game_object:addEventListener("preCollision")
          end
          if onPostCollision then
            game_object.collision = onPostCollision
            game_object:addEventListener("postCollision")
          end
        end
      end

      table.insert(game_objects, game_object)
    end
    self.tilemap.layers[layer_id].game_objects = game_objects
  end

  for i, l in ipairs(self.tilemap.layers) do
    local opt
    if map_options then
      for k, v in pairs(map_options) do
        if(l.name == k) then
            opt = v
          break
        end
      end
    end

    if l.type == "tilelayer" then
      create_tilelayer(layer_object, i, opt)
    elseif l.type == "objectgroup" then
      create_objectlayer(layer_object, i, opt)
    elseif l.type == "imagelayer" then
    end

    l.layer_object = layer_object
    self.tilemap.layer_objects:insert(layer_object)
  end
end

return M