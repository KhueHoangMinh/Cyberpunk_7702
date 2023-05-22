class Enemy < Gosu::Window
    def initialize(win,type)
        @win = win
        @ground = @win.ground
        @x = rand(@ground[0].right+20..@ground[1].left-20)
        @y = 200 + rand(200)
        @size = 25.0
        @gforce = 3
        @playerposx = 300
        @playerposy = 200
        @gun = Gun.new(self, @win, 'enemy')
        @distance = 100 + rand(1000)
        @distanceup = rand 180
        @jump = 0
        @jumpsec = 0
        @jaccelerate = 0
        @jumping = true
        @health = 100.0
        @maxhealth = 100.0
        @green = Gosu::Color.argb(0xff_00ff00)
        @red = Gosu::Color.argb(0xff_ff0000)
        @type = type
        if(@type == 'walking')
            @color = 0xff_ff0000
            @dying = Gosu::Sample.new(self, './Assets/Songs/dying1.mp3')
        elsif @type == 'flying'
            @color = 0xff_ffa500
            @dying = Gosu::Sample.new(self, './Assets/Songs/dying2.mp3')
        else
            @type = 'walking'
            @size = 40.0
            @color = 0xff_3f9ffd
            @health = 300.0
            @maxhealth = 300.0
            @gun = Gun.new(self,@win, 'bigenemy')
            @dying = Gosu::Sample.new(self, './Assets/Songs/dying3.mp3')
        end
        @standlevel = 3000
        @collide = false
        @collidex_left = false
        @collidex_right = false
        @collidey_bottom = false
        @collidey_top = false
    end

    def takedmg(dmg,shockx, shocky)
        if(shockx > 0 && !@collidex_right)
            @x = @x + 30*shockx
        elsif(shockx < 0 && !@collidex_left)
            @x = @x + 30*shockx
        end
        if(@type == 'flying')
            if(shocky > 0 && !@collidey_bottom)
                @y = @y + 30*shocky
            elsif(shockx < 0 && !@collidey_top)
                @y = @y + 30*shocky
            end
        else
            @y = @y + 30*shocky
        end
        @health = @health - dmg
    end

    def isdead
        if(@health <=0)
            @dying.play
            return true
        else 
            return false
        end
    end

    def top
        return @y-@size
    end

    def bottom
        return @y+@size
    end

    def left
        return @x-@size
    end

    def right
        return @x+@size
    end

    def move(playerposx, playerposy, camx)
        @x = @x - camx
        if @y > 1000
            @y = 875
        end
        @jump = rand 10
        if (@type == 'walking' && @jump == 9 && @win.currentsec - @jumpsec >= 2)
            self.jump
        end
        if (@jump == 8 && @win.currentsec - @jumpsec >= 1)
            self.enemyfire
        end
        self.checkcollide
        @playerposx = playerposx
        @playerposy = playerposy
        if ((@playerposx+@distance)-@x).abs > ((@playerposx-@distance)-@x).abs 
            @x = @x - 2 if @playerposx-@distance < @x && !@collidex_left
            @x = @x + 2 if @playerposx-@distance > @x && !@collidex_right
        else
            @x = @x - 2 if @playerposx+@distance < @x && !@collidex_left
            @x = @x + 2 if @playerposx+@distance > @x && !@collidex_right
        end
        if(@type == 'flying')
            if ((@playerposy+@distance)-@y).abs > ((@playerposy-@distance)-@y).abs 
                @y = @y - 2 if @playerposy-@distanceup < @y && !@collidey_top
                @y = @y + 2 if @playerposy-@distance > @y && !@collidey_bottom
            else
                @y = @y - 2 if @playerposy+@distance < @y && !@collidey_top
                @y = @y + 2 if @playerposy+@distance > @y && !@collidey_bottom
            end
        end 
        if @type == 'walking'
            self.gravity
        end
        @jaccelerate = @jaccelerate*0.96
        if @jumping == true
            @y = @y - @jaccelerate
        end
        @gun.update(@x,@y,@playerposy-@y,@playerposx-@x)
    end

    def checkcollide
        
        @collide = false
        @collidex_left = false
        @collidex_right = false
        @collidey_bottom = false
        @collidey_top = false
        @ground.each {|ground|
            if self.bottom >= ground.top && self.top<= ground.top 
                if(((self.left <= ground.right && self.right >= ground.right) || (self.left > ground.left && self.right < ground.right) || (self.left <=ground.left && self.right >= ground.left)))
                    @standlevel = ground.top + 1
                    @collide = true
                else
                    @standlevel = 3000
                end
            end

            if(self.left < ground.right && self.right > ground.right && self.bottom > ground.top + 5 && self.top < ground.bottom)
                @collidex_left = true
            elsif(self.right > ground.left && self.left < ground.left && self.bottom > ground.top + 5 && self.top < ground.bottom)
                @collidex_right = true
            end
            if(@type == 'flying')
                 
                if(((self.left <= ground.right && self.right >= ground.right) || (self.left > ground.left && self.right < ground.right) || (self.left <=ground.left && self.right >= ground.left)))
                    if(self.bottom >= ground.top && self.top<= ground.top)
                        @collidey_bottom = true
                    elsif(self.bottom >= ground.bottom && self.top<= ground.bottom)
                        @collidey_top = true
                    end
                end
            end 
        }
        
    end

    def gravity
        if self.bottom <= @standlevel -1
            @gforce = @gforce*1.1
            @y = @y + @gforce
        else
            @y=@standlevel-@size
            @gforce = 3
            @jumping = false
        end
    end

    def enemyfire
        @gun.fire(@x, @y, @playerposy-@y, @playerposx-@x)
    end

    def jump
        if @jumping == false
            @y = @y -20
            @jaccelerate = 15
            @jumping = true
        end
        @jump = 0
        @jumpsec = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def draw
        draw_quad(@x-@size, @y-50-5, @red, @x-@size+2*@size, @y-50-5, @red, @x-@size, @y-50+5, @red,@x-@size+ 2*@size, @y-50+5, @red)
        draw_quad(@x-@size, @y-50-5, @green, @x-@size+2*(@health/@maxhealth)*@size, @y-50-5, @green, @x-@size, @y-50+5, @green,@x-@size+ 2*(@health/@maxhealth)*@size, @y-50+5, @green)
        @gun.draw
        draw_quad(@x-@size,@y-@size,@color ,@x+@size,@y-@size,@color ,@x-@size,@y+@size,@color ,@x+@size,@y+@size,@color )
    end
end