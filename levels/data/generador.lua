
file = io.open("1.csv", "r")

lista = {}
level = {}
esp = {}

for i=1,16 do
   table.insert(lista,file:read())
end

esp = file:read()

for i, v in ipairs(lista) do

   for j = 1, #v do
	  local pos = j
	  local foo = tonumber( string.sub(v, pos,pos) )

	  if level[j] == nil then
		 level[j] = foo
	  else
		 level[j] = level[j] + foo * 2^(i-1)
	  end
   end
   
end

print("level = {")

for i = 1, #level do
   print(
	  string.format(
		 " { %s, 0x%0.4x } ",
		 tonumber(string.byte(string.sub(esp, i,i))),
		 level[i]
	  )
   )
end
print("}")

file:close() 
