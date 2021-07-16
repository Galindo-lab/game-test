-- VARIABLES

rooms = {}

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
   size = 8,
   list = {},
   free = {},
}

function create(factory,x,y,t)
   if #factory.free > 0 then
	  -- sí hay un espacio libre en la pila tomar ese espacio y
	  -- reutilizar ese indice
	  local foo = table.remove(factory.free)
	  factory.list[foo] = {x=x, y=y, t=t,  alive=true};
   else
	  -- sí no crear un nuevo registro en arrows 
	  table.insert(factory.list, {x=x, y=y, t=t, alive=true})
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

function registro(factory, t, num)
   local i = 1
   -- returns a table of bits, least significant first.

   while num > 0 do
      local rest = math.fmod(num, 2)

      if rest == 1 then
         create(factory,SCREEN_WIDTH + 8, i * 8, t)
      end
      
      num=(num - rest) / 2
      i = i + 1 
   end
   
end
