rooms.menu = {
   onCreate = function(self)
      self.selected = 0
      poke(0x03FF8, 1)

      OVR = function()
         rect(0,0,SCREEN_WIDTH,SPRITE_SIZE-1,8)
         print( string.format("SCORE:%06d ", pmem(player_score))
                , 8, 1, 15 , true )
      end
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
      
      local d = time();

      -- titulo 
      spr(title_sprite,120-(8*9),68,5,2,0,0,9,1)
      
      -- luna
      spr(moon_sprite,120-(8*2),136/5,5,2,0,0,2,2)
      -- cursor
      if math.floor(d*0.005) % 2 == 0 then
         spr(cursor_sprite,120-(8*5),68+23+(8 * self.selected))
      end

      -- texto
      print("Press any key",240/2-(8*4),68+24)	  
   end,
}
   
