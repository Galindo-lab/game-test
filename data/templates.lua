-- TEMPLATES

templates = {
   [64] = {
	  s = 100,				-- sprite
	  m = function(x,y)		-- funcion de x y y, retorna 2 valores
		 return x-1,math.cos(x/10)*0.5 + y ;
	  end
   },
}
