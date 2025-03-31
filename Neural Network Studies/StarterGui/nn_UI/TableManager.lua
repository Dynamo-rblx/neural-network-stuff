local _table = {}

function _table.NewGrid(x, y, z)
  local grid = {}
  
  if x then
    grid.X = x
    
    for i=1, x, 1 do
      grid[i] = 0;
    end
    
    if y then
      grid.Y = y

      

      if z then
        grid.Z = z

        
      end
      
    end
  end
  
end


return _table
