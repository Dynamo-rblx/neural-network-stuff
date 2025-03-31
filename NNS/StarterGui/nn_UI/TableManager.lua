--// CONSTANTS
local START_VALUE = {0}

--// USEFUL FUNCTIONS
local function createGrid(size)
  local grid = {}

  for iterator_x, size.X do
    grid[iterator_x] = {}

    if size.Y > 0 then
      for iterator_y, size.Y do
        grid[iterator_x][1] = iterator_y
      end
    end

    if size.Z > 0 then
      for iterator_z, size.Z do
        grid[iterator_x][2] = iterator_z
      end
    end

  end

  --[[
  Returns:
  grid = {
  [x] = {y,z},
  [x] = {y,z},
  [x] = {y,z}
  }
  ]]

  return grid
end

--// MODULE
local _table = {}

--// CREATE NEW GRID (1D, 2D, 3D)
function _table.NewGrid(x, y, z)
  if not(x) or x < 0 then error("Invalid x parameter: "..x) end

  local self = {}

  self.Size = {
    ["X"] = x or -1,
    ["Y"] = y or -1,
    ["Z"] = z or -1
  }

  if self.Size.X >= 0 then
    self.Grid = createGrid(self.Size)
  end
  
  return self
end


return _table
