

-- CONSTANTES GLOBALES

SCREEN_WIDTH       = 240
SCREEN_HEIGHT      = 136

HALF_SCREEN_WIDTH  = 120
HALF_SCREEN_HEIGHT = 68

SPRITE_SIZE        = 8

-- SPRITES

player_sprite = 256
moon_sprite   = 270
title_sprite  = 261
cursor_sprite = 488
arrow_sprite  = 257

enemy_sprites = 272				--  Hay multiples eneigos [272, 285]


















-- FUNCIONES REESCRITAS 

function f(...)
  return ...
end

function nbtn(value)
   if btn(value) then return 1 else return 0 end
end

function nbtnp(value)
   if btnp(value) then return 1 else return 0 end
end   

function setOvr(foo)
   OVR = foo
end


function switchRoom(room)
   TIC = function()
	  room:onCreate()
	  TIC = function()
		 room:onStep()
		 room:Draw()
	  end
   end
end





















-- ACTIONS

actions = {
   moveMenu = function() return nbtnp(1) - nbtnp(0); end,
   moveX    = function() return nbtn(3) - nbtn(2); end,
   moveY    = function() return nbtn(1) - nbtn(0); end,
   fire     = function() return btn(4); end, 
}




























-- VARIABLES

player = {
   x = 0, y = 0,				-- coordenadas
   hspd = 0, vspd = 0,			-- velocidad horizontal y vertical
   w = 8, h = 8,				-- width y height
}

arrows = {
   hspd = 5,		-- velocidad de las flechas
   size = 8,		-- width and height
   list = {},		-- lista de arrow
   free = {},		-- stack de espacios libres en la lista de flechas
}

enemies = {
   ptyp = {
	  {
		 s = 100,				-- sprite
		 m = function(x,y)		-- funcion de x y y, retorna 2 valores
			return x-1,y;
		 end
	  },
   },
   
   size = 8,
   list = {},
   free = {},
}

function create(factory,x,y)
   if #factory.free > 0 then
	  -- sí hay un espacio libre en la pila tomar ese espacio y
	  -- reutilizar ese indice
	  local foo = table.remove(factory.free)
	  factory.list[foo] = {x=x, y=y, alive=true};
   else
	  -- sí no crear un nuevo registro en arrows 
	  table.insert(factory.list, {x=x, y=y, alive=true})
   end
end

function kill(factory,id)
   -- cambiar su estado de vivo a muerto
   factory.list[id].alive = false;
   --  añadir su indice a la pila de espacios libres
   table.insert(factory.free, id)
end

function iterate(factory, actions)
   for i = 0, #factory.list do
	  local foo = factory.list[i] or nil
	  
	  if foo ~= nil then
		 actions(foo, i)
	  end
   end
end















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

		 trace("Scene = ingame")
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
		 
		 
	  end,
	  
	  Draw = function(self)
		 cls()
		 spr(moon_sprite,200,10,5,2,0,0,2,2)
		 
		 iterate(arrows, function(foo, id)
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
		 
		 spr(player_sprite,player.x,player.y,0);

		 -- UI
		 
		 

		 -- print( string.format([[
-- arrows:%.0f,%.0f
-- ]],#arrows.list, #arrows.free), 0, 0, 15, true)
		 
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





















-- TIC
function TIC()
   switchRoom(rooms.menu);
end

-- spr(id,x,y,colorkey=-1,scale=1,flip=0,rotate=0,w=1,h=1)
