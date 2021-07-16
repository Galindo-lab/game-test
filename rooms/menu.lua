rooms.menu = {
   onCreate = function(self)
      self.selected = 0
   end,
   
   onStep = function(self)
      -- mover el cursor
      self.selected = self.selected + actions.moveMenu();

      if actions.fire() then
         -- switch 
         if self.selected == 0 then switchRoom(rooms.inGame) end
      end
   end,
   
   Draw = function(self)
      cls(0)

      -- titulo 
      spr(title_sprite,120-(8*9),68,5,2,0,0,9,1)
      -- luna
      spr(moon_sprite,120-(8*2),136/5,5,2,0,0,2,2)
      -- cursor
      spr(cursor_sprite,120-(8*5),68+23+(8 * self.selected))

      -- texto
      print("Press any key",240/2-(8*4),68+24)	  
   end,
}
   
