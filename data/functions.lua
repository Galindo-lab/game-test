
-- FUNCIONES REESCRITAS 

function f(...)
   return ...
end

floor = math.floor

function nbtn(value)
   if btn(value) then return 1 else return 0 end
end

function nbtnp(value)
   if btnp(value) then return 1 else return 0 end
end

function toBits(num)
   -- https://stackoverflow.com/questions/9079853/lua-print-integer-as-a-binary/9080080
   -- returns a table of bits, least significant first.
   local t={} -- will contain the bits
   while num > 0 do
	  rest = math.fmod(num, 2)
	  t[#t+1] = math.floor(rest)
	  num=(num - rest) / 2
   end
   return t
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


-- TODO: simplificar todo esto, sepuede crear una funcion para simplificar este proceso

function overlap( ax,ay,aw,ah,  bx,by,bw,bh )
   return (ax+aw > bx)
      and (ax < bx+bw)
      and (ay+ah > by)
      and (ay < by+bh)
end

function overlapSpriteGroup(a, b, bgs)
   return overlap( a.x, a.y, a.w, a.h,
                   b.x, b.y, bgs, bgs )
end

function overlapSprites(a, b)   -- elementos individuales
   return overlap( a.x, a.y, a.w, a.h,
                   b.x, b.y, b.w, b.h )
end

-- function overlapGroups(ag, id)

function overlapGroups(ag, id, bg) -- grupo & grupo
   local a, b = ag.list, bg.list
   local a_size, b_size = ag.size, bg.size
   local al, ar, at, ab = a[id].x, a[id].x+a_size, a[id].y, a[id].y+b_size

   for i = 1, #b do
      local bix, biy = b[i].x, b[i].y

      if b[i].alive
         and ar > bix
         and al < bix+b_size
         and ab > biy
         and at < biy+b_size
      then
         return true, i
      end

   end
  
   return false, -1
  
end
