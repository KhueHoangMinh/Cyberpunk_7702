require './Bullet.rb'

class Player < Gosu::Window

    attr_accessor :x,:y,:camx
    def initialize(win,gun,skin,power)
        @win = win
        @ground = @win.ground
        @w=50
        @h=50
        @x=920
        @y=200
        @gforce=3
        @jumpforce= 10
        @size=50.0
        @gun = Gun.new(self,@win,gun)
        @skin = skin
        @power = power
        @accelerate = 0
        @jaccelerate = 0
        @pointx = 0
        @pointy = 0
        @jumping = false
        if(@power == 'health')
            @health = 1500.0
        else
            @health = 1000.0
        end
        @healthmax = @health
        @green = Gosu::Color.argb(0xff_00ff00)
        @red = Gosu::Color.argb(0xff_ff0000)
        @standlevel = 3000
        @collidey = false
        @collidex_left = false
        @collidex_right = false
        @camx = 0
    end

    def takedmg(dmg)
        if(@power == 'defense')
            dmg = dmg*60.0/100
        end
        @health = @health - dmg
    end

    def isdead
        if(@health <=0)
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

    def point(xpointat, ypointat)
        @pointx = xpointat
        @pointy = ypointat
    end

    def fire
        @gun.fire(@x,@y,@pointy-@y, @pointx-@x)
    end

    def move(xpointat, ypointat)
        self.point(xpointat, ypointat)
        self.jump if Gosu.button_down? Gosu::KB_SPACE
        self.move_left if Gosu.button_down? Gosu::KB_A
        self.move_right if Gosu.button_down? Gosu::KB_D
        self.fire if Gosu.button_down? Gosu::MsLeft
        self.checkcollide
        self.gravity
        @gun.update(@x,@y,@pointy-@y,@pointx-@x)
        @accelerate = @accelerate*0.92
        @jaccelerate = @jaccelerate*0.98
        if((@accelerate < 0 && @collidex_left) || (@accelerate > 0 && @collidex_right))
            @camx = 0
        else
            @camx = @accelerate
        end
        if @jumping == true
             @y = @y - @jaccelerate
        end
    end

    def checkcollide
        @collidey = false
        @collidex_left = false
        @collidex_right = false
        @ground.each {|ground|
            if (self.bottom > ground.top && self.bottom < ground.bottom+20 && self.top < ground.top)
                if(((self.left <= ground.right && self.right >= ground.right) || (self.left > ground.left && self.right < ground.right) || (self.left <=ground.left && self.right >= ground.left)))
                    @standlevel = ground.top + 1
                    @collidey = true
                else
                    @standlevel = 3000
                end
            end

            if(self.left < ground.right && self.left + 20 > ground.right && self.bottom > ground.top + 5 && self.top < ground.bottom)
                @collidex_left = true
            elsif(self.right > ground.left && self.right - 20 < ground.left && self.bottom > ground.top + 5 && self.top < ground.bottom)
                @collidex_right = true
            end
        }
        
    end

    def gravity
        if self.bottom <= @standlevel -1
            @gforce = @gforce*1.1
            @y = @y + @gforce
        else
            @jumping = false
            @y=@standlevel-@size
            @gforce = 3
        end
    end

    def jump
        if @jumping == false
            @win.explosions << Explosion.new(@win, @x + rand(-25..25) , @y + @size - rand(3..5), 0xaa999999+(rand(0..4)*0x00111111), rand(2..4))
            @win.explosions << Explosion.new(@win, @x + rand(-25..25), @y + @size - rand(3..5), 0xaa999999+(rand(0..4)*0x00111111), rand(2..4))
            @win.explosions << Explosion.new(@win, @x + rand(-25..25), @y + @size - rand(3..5), 0xaa999999+(rand(0..4)*0x00111111), rand(2..4))
            @y = @y - 25
            @jaccelerate = 20
            @jumping = true
        end
    end

    def move_left
        if(rand(0..10) < 2 && @jumping == false)
            @win.explosions << Explosion.new(@win, self.right + rand(3..5) , @y + @size - rand(3..5), 0xaa999999+(rand(0..4)*0x00111111), rand(1..2))
        end
        @accelerate = @accelerate - 1
    end

    def move_right
        if(rand(0..10) < 2 && @jumping == false)
            @win.explosions << Explosion.new(@win, self.left + rand(3..5) , @y + @size - rand(3..5), 0xaa999999+(rand(0..4)*0x00111111), rand(1..2))
        end
        @accelerate = @accelerate + 1
    end
    
    
    def draw
        draw_quad(@x-@size, @y-80-10, @red, @x-@size+2*@size, @y-80-10, @red, @x-@size, @y-80+10, @red,@x-@size+ 2*@size, @y-80+10, @red,3)
        draw_quad(@x-@size, @y-80-10, @green, @x-@size+2*(@health/@healthmax)*@size, @y-80-10, @green, @x-@size, @y-80+10, @green,@x-@size+ 2*(@health/@healthmax)*@size, @y-80+10, @green, 4)
        
        @gun.draw
        case @skin
        when 'blue'
            self.blue(@x,@y)
        when 'green'
            self.green(@x,@y)
        when 'rainbow'
            self.rainbow(@x,@y)
        end
    end

    def blue(x,y)
        draw_quad(x-@size, y-@size, Gosu::Color::BLUE, x+@size, y-@size, Gosu::Color::BLUE, x-@size, y+@size, Gosu::Color::BLUE, x+@size, y+@size, Gosu::Color::BLUE,7)
    end

    def green(x,y)
        draw_quad(x-@size, y-@size, Gosu::Color::GREEN, x+@size, y-@size, Gosu::Color::GREEN, x-@size, y+@size, Gosu::Color::GREEN, x+@size, y+@size, Gosu::Color::GREEN,7)
    end

    def rainbow(x,y)
        draw_quad(x-@size, y-@size, 0xffffff88, x+@size, y-@size, 0xffff88ff, x-@size, y+@size, 0xff88ffff, x+@size, y+@size, 0x88ffffff,7)
    end
end