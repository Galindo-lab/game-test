-- ROOMS

rooms = {

   -- GAME LOOP 
   inGame = {
	  onCreate = function(self)
		 -- duracion del cooldown
		 self.cooldownDutarion = 200;
		 -- evitar que se auto dispare al inicio 
		 self.cooldown = time() + self.cooldownDutarion;

		 -- tiempe de generacion entre enemigos
		 self.enemyTimerDuration = 200
		 self.enemyTimer = time() + 3000
		 

		 OVR = function()
			rect(0,0,SCREEN_WIDTH,SPRITE_SIZE-1,8)
			print( "SCORE: 000000 ", 8, 1, 15 , true )
		 end

	  end,
	  
	  onStep = function(self)
		 player.x = player.x + actions.moveX()
		 player.y = player.y + actions.moveY()

		 -- llamar al valor cada ejecucion, es mas rapido que recalcular
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
            elseif t == 1 then trace("test")
            else registro(enemies, t, num ) end

			self.enemyTimer = d + self.enemyTimerDuration
		 end
         
	  end,

	  Draw = function(self)
		 cls()
		 spr(moon_sprite,200,10,5,2,0,0,2,2)
		 
		 iterate(arrows,function(foo, id)
					-- verificar que la flecha exista y se encuentra en
					-- el viewport
					if foo.alive and foo.x < SCREEN_WIDTH then
					   -- sí se existe y esta en el viewport entonces se
					   -- mueve a la derecha y se dibuja su sprite
					   foo.x = foo.x + arrows.hspd
					   spr(arrow_sprite, foo.x, foo.y,0)
					   -- sí existe pero no esta en el el viewport
					elseif foo.alive then
					   kill(arrows, id)
					end
		 end)

		 iterate(enemies, function(foo, id)
                    trace(foo.t)
					foo.x, foo.y = templates[foo.t].m(foo.x,foo.y)
					spr(foo.t, foo.x, foo.y)
		 end)
		 
		 spr(player_sprite,player.x,player.y,0);
		 
	  end
   },

   -- MAIN MENU
   menu = {
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
   },




}
