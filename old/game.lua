-- title:  GameTest
-- author: Galindosoft
-- desc:   My first TIC-80 game
-- script: lua

Sprite={x=0,y=0,width=8,height=8,spr=0}
Sprite.mt={}

Sprite.New=function()
	local sprt={}
	setmetatable(sprt,Sprite.mt)
	for k,v in pairs(Sprite) do
		sprt[k]=v
	end

	return sprt
end

player=Sprite.New()

player.x=80
player.y=64

player.vx=0
player.vy=0

player.spr=256
player.cooldown=0
player.arrows={}
player.score=0
player.lifes=5
player.invulnerability=0

function player:shoot()
	local time = time()/1000
	local arrow={x=self.x,y=self.y,width=8,height=8,spr=257}

	if time>self.cooldown then
		self.cooldown=time+0.2
		table.insert(self.arrows,arrow)
	end
end

function player:update()

	self.x=self.x+self.vx
    self.y=self.y+self.vy


	for i, arrow in ipairs(self.arrows) do
		arrow.x=arrow.x+7
		if arrow.x>=232 then table.remove(self.arrows,i)end
	end
end

function player:X() return self.x+self.vx end
function player:Y() return self.y+self.vy end


camera={
	x=0,
	y=0,
	pox=120,
	poy=64,
	move=true,
}

function camera:draw()
	self.pox=math.min(120,120-self.x)
	self.poy=math.min(64,64-self.y)

	self.ccx=self.pox/8+(self.pox%8==0 and 1 or 0)
	self.ccy=self.poy/8+(self.poy%8==0 and 1 or 0)
	a=15-self.ccx
	b=8-self.ccy
	map(15-self.ccx,8-self.ccy,31,18,(self.pox%8)-8,(self.poy%8)-8,0)
end

enemies={
	list={},
	delay=0.0,
	time=0,
	t=0,
	delay=0
}

function enemies:create(x,y,type,speed)
	local enemy={x=x,y=y,width=8,height=8,type=type,speed=speed}
	table.insert(self.list,enemy)
end

function enemies:DrwAndUp()
	if self.time<=time()/1000 then
		self.time=time()/1000+self.delay
		for i,enemy in ipairs(self.list) do
			spr(enemy.type+self.t%60/30,enemy.x,enemy.y,5)
			enemy.x=enemy.x-(1*enemy.speed)

			if enemy.type==292 then
				enemy.y=(enemy.y+(math.cos(time()/700)*-0.8))
			end
		end
		self.t=self.t+1
	end
end

boss={}

boss.x=240-32
boss.y=(136-32)/2
boss.alive=true
boss.timer=0
boss.width=32
boss.height=32
boss.life=100

function boss:update()
	if self.timer <= time()/1000 then
	self.y=self.y+math.cos(time()/400)
	self.timer=time()/1000+0.003
	end
end

function boss:draw()
	spr(290,self.x,self.y,5,2,0,0,2,2)
end

local moon=Sprite.New()

moon.x=200
moon.y=10
moon.spr=270

function moon:update(level_speed)
	self.x = self.x-(0.009*level_speed)
end

function moon:draw()
	spr(self.spr,self.x,self.y,5,2,0,0,2,2)
end

function solid(x,y,bloque)
    return solids[mget((x)/bloque,(y)/bloque)]
end

function overlap(a,b)
	al=a.x
	ar=a.x+a.width
	at=a.y
	ab=a.y+a.height

	bl=b.x
	br=b.x+b.width
	bt=b.y
	bb=b.y+b.height

    if ar>bl and al<br and ab>bt and at<bb then
    	return true
    else
    	return false
    end

end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

nively={1,7,2,3,6,4,5,2,5,1,7,4,5,2,3,6,2,5,1,7,3,7,3,5,1,7,4,3,6,5,7,2,7,4,2,7,5,3,6,6,2,4,5,2,5,7,2,5,6,1,7,6,5,4,3,2,1,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,1,2,3,4,5,6,7,0}
nivelx={13,14,16,19,19,22,24,40,40,46,46,47,53,54,64,65,71,78,83,84,89,93,97,102,107,108,110,120,123,132,139,140,145,149,155,158,161,169,169,178,184,188,193,200,204,210,215,217,227,231,235,236,237,238,239,240,241,284,284,284,284,284,284,284,284,312,312,312,312,312,312,312,322,322,322,322,322,322,322,0}
nivels={1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,5,3,2,2,2,3,3,6,3,3,3,5,6,3,3,5,4,4,4,4,5,4,4,4,5,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,0}

visible=true
clock=0
speed=1
mainscreen=true


function TIC()



	if mainscreen then

		poke(0x03FF8,1)

		cls(0)

		spr(261,240/2-(8*9),136/2,5,2,0,0,9,1)
		spr(270,240/2-(8*2),136/5,5,2,0,0,2,2)
		print("Press Enter",240/2-(8*4),68+24)

		if key(50) and mainscreen then
			mainscreen=false
		end

	elseif player.lifes>=1 and boss.life>=0 then
		controllers()
		update()
		draw()

	elseif boss.life<0 then
		cls(0)
		ui(visible)

		print("End, you win",92,68)
		print("ctrl+ r to restart",92-20,68+8)
		--spr(290,120-24,30+4,5,2,0,0,2,2)
	else
		cls(0)
		ui(visible)
		print("Game Over",92,68)
		print("press enter to restart",92-34,68+8)

		if key(50) then
			reset()
		end
	end
end

function update()
	if camera.x >= 2400 then
		speed=4
	end

	if camera.move then
		camera.x=camera.x+(0.5*speed)
	end

	if(boss.alive and math.random(0,15) ==1)then
		enemies:create(240-16,boss.y+16,292,3.5)
	end

	if(camera.x>=(nivelx[1]*10) and #nivelx>1) then
		enemies:create(240,nively[1]*17,nivels[1]*2+272,1)
		table.remove(nively,1)
		table.remove(nivelx,1)
		table.remove(nivels,1)
	end

	for i,enemy in ipairs(enemies.list) do

		if enemy.x<=0 or enemy.type==288 and enemy.delay<time()/1000 then
			table.remove(enemies.list,i)
		end

		for j,arrow in ipairs(player.arrows) do
			if overlap(enemy,arrow) and enemy.type~=288 then
				enemy.type=288
				enemy.delay=time()/1000+0.2
				table.remove(player.arrows,j)
				player.score=player.score+3
			end

			if overlap(boss,arrow) then
				boss.life=boss.life-1
				table.remove(player.arrows,j)
				player.score=player.score+3
			end
		end

		if overlap(enemy,player) or overlap(boss,player) and enemy.type~=288 then
			table.remove(enemies.list,i)

			if player.invulnerability<time()/1000 then
				player.invulnerability=time()/1000+1.5
				player.lifes=player.lifes-1
			end
		end
	end

	boss:update()
	player:update()

end

function draw()
	cls(0)
	camera:draw()

	moon:draw()
	moon:update(speed)
	enemies:DrwAndUp()
	boss:update()

	if clock<time()/1000 then
		spr(260,player.x,player.y-8,5)
		spr(258,player.x-(player.vx*3)-(1*speed-1),player.y-(player.vy*3),5)
		spr(259,player.x-(player.vx*2)-(1*speed-1),player.y-(player.vy*2),5)
		clock=time()/1000+0.03

	end

	spr(player.spr,player.x,player.y,5)
	spr(290,boss.x,boss.y,5,2,0,0,2,2)


	for i, arrow in ipairs(player.arrows) do
		spr(arrow.spr,arrow.x,arrow.y,5)
	end

  	rect(2,132,boss.life,3,11)
	ui(visible)
end

function controllers()
	if player.vy > 0 then
		player.vy=round(player.vy-0.05,2)
	elseif player.vy < 0 then
		player.vy=round(player.vy+0.05,2)
	end

	if player.vx > 0 then
		player.vx=round(player.vx-0.05,2)
	elseif player.vx < 0 then
		player.vx=round(player.vx+0.05,2)
	end

	if player.x >= 230 or player.x <=5 then
	player.vx=0
	end

	if player.y >= 128 or player.y <=0 then
	player.vy=0
	end


	if btn(0) and player:Y()>=0 then player.vy=-1.2 end
	if btn(1) and player:Y()<=128 then player.vy=1.2 end
	if btn(2) and player:X()>=0 then player.vx=-1.2 end
	if btn(3) and player:X()<=232 then player.vx=1.2 end
	if btn(4) then player:shoot() end
end

function ui(visible)
	if visible then
  		print(string.format("score:\n%06d", player.score),1+10,1+5,1)
  		print(string.format("score:\n%06d", player.score),0+10,0+5,15)
	  	print(string.format("lifes: %02d", player.lifes),46+10,4+5,1)
  		print(string.format("lifes: %02d", player.lifes),45+10,3+5,15)

  	end
end
