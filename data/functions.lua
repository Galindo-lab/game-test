
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