local _table = {}

function _table.NewGrid(x, y, z)
  local grid: {number}

  grid.X, grid.Y, grid.Z = x or -1, y or -1, z or -1

  if grid.X >= 0 then
    grid = table.create()
  end
  
end


return _table
