


function make_enemy(x,y,type)
    local enemy = {
    quads = my_quads,
    x = x,
    y = y,
    hp=10,
    walk_timer = 1,
    speed=50,
    hp=10,
    sprite=1,
    type=type,
    first=true,
    image=love.graphics.newImage('images/characters/character-6.png'),
    dist={0,0},
    offset={math.random(-50,50),math.random(-50,50)},
    --offset={0,0},
    particle_timer=1,
    knockback_timer=0,

    update = function(self)

        if self.first then
            self.first = false
        end
        self.particle_timer = self.particle_timer - global_dt
        if self.particle_timer <=0 then
            self.particle_timer = 0.5
            local color = math.random(1,5)/10
            --(x,y,dx,dy,color,life,size,da,ds)
            --make_particle(self.x+math.random(0,48),self.y+48+math.random(-5,5),0,0,{color*2,color,color,1},0.5,8,-0.1,-1)
        end
        self.walk_timer = self.walk_timer + 1 * global_dt
        if self.walk_timer >=0.1 then
            self.walk_timer=0
            self.sprite = self.sprite + 1
            if self.sprite > 4 then
                self.sprite = 1
            end
        end

        self.dist.x=self.x-player.x+24
        self.dist.y=self.y-player.y
        if math.sqrt(self.dist.x^2+self.dist.y^2) < 100 then
            self.dist.x,self.dist.y = normalize(self.dist.x,self.dist.y)
        else
            self.dist.x,self.dist.y = normalize(self.dist.x+self.offset[1],self.dist.y+self.offset[2])
        end
        self.x = self.x - self.dist.x * self.speed * global_dt
        self.y = self.y - self.dist.y * self.speed * global_dt
    end,

    draw = function(self)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.image, self.quads[self.sprite], self.x, self.y)
    end
    }


    table.insert(enemies,enemy)

end

function knockback(p,v)
    --(x,y,dx,dy,color,life,size,da,ds)

    --[[
    for i=1,math.random(5) do
        make_particle(v.x+math.random(-10,10),v.y+math.random(-10,10),math.random(-100,100),math.random(-100,100),{0.6,0.6,0.6,0.3},1,25,0,-25)
    end
    --]]
    make_particle(v.x,v.y,0,0,{1,1,1,1},0.2,50,-2,-250)

    for i=1,10 do
        local rx,ry = normalize(-v.dx*100+math.random(-25,25),-v.dy*100+math.random(-25,25))
        rx = rx * 5
        ry = ry * 5
        make_particle(v.x,v.y,rx,ry,{0.9,0.9,0.9,1},0.2,5,0,0)
    end
    

    


    p.x = p.x + v.dx * 10
    p.y = p.y + v.dy * 10
end

function update_enemies()
    for i=1, #enemies do
        enemies[i]:update()
    end
end

function draw_enemies()
    for i=1, #enemies do
        enemies[i]:draw()
    end
end

function check_enemy_collision()
    for i,v in ipairs(enemies) do
        for o,p in ipairs(enemies) do
            if CheckCollision(v.x,v.y,48,48,p.x,p.y,48,48) then
                local dist={x=v.x-p.x,y=v.y-p.y}
                dist.x,dist.y=normalize(dist.x,dist.y)
                v.x = v.x + dist.x
                v.y = v.y + dist.y
                break
            end
        end
    end
end