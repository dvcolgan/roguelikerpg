return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 15,
  height = 9,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 4,
  properties = {},
  tilesets = {
    {
      name = "rpgtiles",
      firstgid = 1,
      filename = "rpgtiles.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../assets/tilesheet.png",
      imagewidth = 512,
      imageheight = 512,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 15,
      height = 9,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164,
        164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164, 164,
        161, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 162, 163,
        178, 178, 178, 178, 178, 81, 82, 82, 82, 83, 178, 178, 178, 178, 178,
        178, 178, 178, 178, 178, 97, 98, 98, 98, 99, 178, 178, 178, 178, 178,
        178, 178, 178, 178, 178, 97, 98, 98, 98, 99, 178, 178, 178, 178, 178,
        178, 178, 178, 178, 178, 113, 130, 98, 129, 115, 178, 178, 178, 178, 178,
        178, 178, 178, 178, 178, 178, 97, 98, 99, 178, 178, 178, 178, 178, 178,
        178, 178, 178, 178, 178, 178, 97, 98, 99, 178, 178, 178, 178, 178, 178
      }
    },
    {
      type = "objectgroup",
      name = "npcs",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          id = 3,
          name = "Pile of Wood",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 160,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 165,
          visible = true,
          properties = {
            ["Dialog"] = "Hello friend, I am wood."
          }
        }
      }
    }
  }
}
