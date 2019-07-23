return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.17.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 9,
  height = 10,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 15,
  backgroundcolor = { 0, 128, 64 },
  properties = {},
  tilesets = {
    {
      name = "tilemap",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "tilemap.PNG",
      imagewidth = 256,
      imageheight = 1024,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 256,
      tiles = {
        {
          id = 0,
          properties = {
            ["bodyType"] = "static"
          },
          probability = 0.3,
          objectGroup = {
            type = "objectgroup",
            name = "rock_collider",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {
              ["aaa"] = "12"
            },
            objects = {}
          }
        },
        {
          id = 27,
          properties = {
            ["behavior"] = "user_define.behaviors.player_behavior"
          },
          objectGroup = {
            type = "objectgroup",
            name = "hoh",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {},
            objects = {}
          },
          animation = {
            {
              tileid = 27,
              duration = 1000
            },
            {
              tileid = 60,
              duration = 1000
            }
          }
        },
        {
          id = 30,
          properties = {
            ["bodyType"] = "dynamic"
          },
          objectGroup = {
            type = "objectgroup",
            name = "taru",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {},
            objects = {}
          },
          animation = {
            {
              tileid = 48,
              duration = 1000
            },
            {
              tileid = 49,
              duration = 1000
            }
          }
        },
        {
          id = 31,
          properties = {
            ["bodyType"] = "dynamic"
          },
          objectGroup = {
            type = "objectgroup",
            name = "takarabako",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {
              ["bounce"] = 0.80000000000000004,
              ["density"] = 10,
              ["friction"] = "0.2"
            },
            objects = {}
          }
        }
      }
    },
    {
      name = "chara",
      firstgid = 257,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "chara.png",
      imagewidth = 1024,
      imageheight = 512,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 512,
      tiles = {
        {
          id = 64,
          animation = {
            {
              tileid = 64,
              duration = 100
            },
            {
              tileid = 65,
              duration = 100
            }
          }
        }
      }
    },
    {
      name = "test_frame",
      firstgid = 769,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "test_frame.png",
      imagewidth = 48,
      imageheight = 48,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 9,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "tilelayer_1",
      x = 0,
      y = 0,
      width = 9,
      height = 10,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 0, 31, 0, 0, 0, 0, 1,
        1, 1, 0, 0, 0, 32, 0, 0, 1,
        1, 1, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 0, 0, 32, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 31, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "objectgroup",
      name = "objectlayer_1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 4,
          name = "hoge",
          type = "player",
          shape = "rectangle",
          x = 191,
          y = 184,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 28,
          visible = true,
          properties = {
            ["bodyType"] = "dynamic"
          }
        }
      }
    }
  }
}
