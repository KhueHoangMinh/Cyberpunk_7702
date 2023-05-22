class Trace < Gosu::Window
    attr_accessor :stop
    def initialize(win, bullet, x, y, angle, color)
        @win = win
        @bullet = bullet
        @x = x
        @y = y
        @angle = angle
        @color = color
        @length = 0
        @stop = false
    end

    def update()
        @x = @x - @win.player.camx
        if(@color - 0x05000000 >= 0x00ffffff)
            @color = @color - 0x05000000
        else
            @win.traces.delete_at(0)
        end
        if(!@stop)
            @length = Math.sqrt((@bullet.x - @x)*(@bullet.x - @x) + (@bullet.y - @y)*(@bullet.y - @y)) + 50
        end
    end

    def draw
        rotate(@angle,@x,@y) {
            draw_quad(@x, @y-3, @color, @x+@length, @y-3, @color, @x, @y+3, @color, @x+@length,  @y+3, @color, 0)
        }
    end
end

class Explosion < Gosu::Window
    def initialize(win, x, y, color, speed)
        @win = win
        @x = x
        @y = y
        @color = color
        @size = 0
        @speed = speed
    end

    def update()
        @x = @x - @win.player.camx
        if(@color - 0x05000000 >= 0x00ffffff)
            @color = @color - 0x05000000
            @size = @size + @speed
            @speed = @speed/1.1
        else
            @win.explosions.delete_at(0)
        end
    end

    def draw
        draw_quad(@x-@size,@y-@size,@color,@x+@size,@y-@size,@color,@x-@size,@y+@size,@color,@x+@size,@y+@size,@color,8)
    end
end

class Bullet < Gosu::Window
    attr_accessor :x, :y, :type, :damage
    def initialize(win, angle_in_deg, posx, posy, type, gunlength,speed,damage,size,range,has_trace)
        @win = win
        @size=size
        @initposx = posx
        @initposy = posy
        @x = posx
        @y = posy
        @range= range
        @type = type
        @color = 0xFFFFFF00
        @damage = damage
        @angle_in_deg = angle_in_deg
        @angle = 2*Math::PI*angle_in_deg/360
        @gunlength = gunlength - 49
        @x=@x+@gunlength*Math.cos(@angle)
        @y=@y+@gunlength*Math.sin(@angle)
        @speed = speed
        if(type == 'enemy')
            @color = 0xFFFF0000
        elsif type == ''
            @color = 0xFFFF0000
        else
            @color = 0xFFFFFF00
        end
        if(has_trace)
            if(type != 'enemy')
                @trace = Trace.new(@win, self, @x, @y, @angle_in_deg, rand(0xaa999999..0xaaffffff))
                @win.traces << @trace
            else
                @trace = Trace.new(@win, self, @x, @y, @angle_in_deg, 0xaa999999)
                @win.traces << @trace
            end
        end
    end

    def bulletx
        return Math.cos(@angle)
    end

    def bullety
        return Math.sin(@angle)
    end

    def checkcollide(top, bottom, right, left, type)
        if @x >= left-5 && @x <= right+5 && @y >= top-5 && @y <= bottom+5 && @type != '' && type != @type
            if(@trace != nil && @type != 'sniper')
                @trace.stop = true
            elsif(@trace != nil && @type == 'sniper' && type == 'ground')
                @trace.stop = true
            end
            if(@type != 'enemy')
                @win.explosions << Explosion.new(@win,@x,@y,rand(0xaa999999..0xaaffffff),6)
            else
                @win.explosions << Explosion.new(@win,@x,@y,0xaaffffff,2)
            end
            return true
        else
            return false
        end
    end

    def checkout
        if @x >= @range+@initposx || @x <= -@range+@initposx || @y >= @range+@initposy || @y <= -@range+@initposy
            if(@trace != nil)
                @trace.stop = true
            end
            if(@type != 'enemy')
                @win.explosions << Explosion.new(@win,@x,@y,rand(0xaa999999..0xaaffffff),6)
            else
                @win.explosions << Explosion.new(@win,@x,@y,0xaaffffff,2)
            end
            return true
        else
            return false
        end
    end

    def update(camx)
        @x = @x - camx
        @x=@x+@speed*Math.cos(@angle)
        @y=@y+@speed*Math.sin(@angle)
    end

    def draw
        rotate(@angle_in_deg,@x,@y) {
             draw_quad(@x, @y-3, @color, @x+@size*2, @y-3, @color, @x, @y+3, @color, @x+@size*2,  @y+3, @color,-1)
        }
    end
end