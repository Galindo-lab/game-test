rooms.inGame = {
   
   onCreate = function(self)    -- --------------------------------------------
      -- duracion del cooldown
      self.cooldownDutarion = 200;
      -- evitar que se auto dispare al inicio 
      self.cooldown = time() + self.cooldownDutarion;

      -- tiempe de generacion entre enemigos
      self.enemyTimerDuration = 200
      self.enemyTimer = time() + 3000

      -- reiniciar el score
      pmem(player_score,0)

      -- center player
      player.x = SCREEN_WIDTH/4
      player.y = SCREEN_HEIGHT/2

      OVR = function()
         rect(0,0,SCREEN_WIDTH,SPRITE_SIZE-1,8)
         print( string.format("SCORE:%06d d:%4.f", pmem(player_score), time())

                , 8, 1, 15 , true )
      end

   end,













   


   
   
   onStep = function(self)      -- --------------------------------------------
      player.x = player.x + actions.moveX()
      player.y = player.y + actions.moveY()

      -- llamar al valor cada ejecucion
      -- el valor de la funcion cada ciclo
      local d = time();

      -- disparar flechas a intervalos de 200 milisegundos
      if actions.fire() and self.cooldown < d then
         create(arrows, player.x, player.y);
         self.cooldown = d + self.cooldownDutarion;
      end

      

      -- mantener al jugador en el viewport siempre
      local left_border = 0
      local right_border = SCREEN_WIDTH - player.w
      local upper_border = 8
      local button_border = SCREEN_HEIGHT - player.h
      
      if player.x <= 0 then
         player.x = 0
      elseif player.x >= right_border then
         player.x = right_border
      end

      if player.y <= upper_border then
         player.y = upper_border
      elseif player.y >= button_border then
         player.y = button_border
      end


      -- crear enemigos
      if self.enemyTimer < d and #level > 0 then
         local bar = table.remove(level,1)
         local t = bar[1]
         local num = bar[2]

         if     t == 0 then self.enemyTimerDuration = num
         elseif t == 1 then trace("")
         else registro(enemies, t, num ) end

         self.enemyTimer = d + self.enemyTimerDuration
      end
      
   end,



















   






   

   Draw = function(self)        -- --------------------------------------------

      local d = time();
      
      cls()
      spr(moon_sprite,200,10,5,2,0,0,2,2)
      
      iterate(arrows,function(foo, id) -- flechas
                 -- eliminar si se sale del viewport
                 if foo.x < SCREEN_WIDTH then 
                    spr(arrow_sprite, foo.x, foo.y,0)
                    foo.x = foo.x + arrows.hspd
                 else
                    kill(arrows, id)
                 end
      end)

      iterate(enemies, function(foo, id) -- enemigos                 
                 if foo.x > 0 then
                    foo.x, foo.y = templates[foo.t].m(foo.x,foo.y)
                    spr(foo.t, foo.x, foo.y, 0)
                 else
                    kill(enemies, id)
                 end

                 -- colision de enemigos y fechas
                 local colided, selected = overlapGroups(enemies, id, arrows)
                 
                 if colided then
                    pmem(player_score, pmem(player_score)+10)
                    kill(enemies, id)
                    kill(arrows, selected)
                 end

                 -- colision con el jugador
                 -- TODO: todavia falta implementar la colicion, este solo es
                 --       codigo placeholder.
                 if overlapSpriteGroup( player, foo, enemies.size) then
                    reset()
                 end
      end)

      if floor(d) % 2 == 0 then
         spr(player_halo, player.x, player.y-8, 0)
      end
      
      spr(player_sprite,player.x,player.y,0);
      
   end
}
