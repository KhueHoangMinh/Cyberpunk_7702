class Pattern < Gosu::Window
    def initialize(top,bottom,right,left,color)
        @top = rand(top..bottom)
        @bottom = rand(@top..bottom)
        @left = rand(left..right)
        @right = rand(@left..right)
        @color=color
    end

    def update(camx)
        @left = @left - camx
        @right = @right - camx
    end

    def draw
        draw_quad(@left,@top,@color,@right,@top,@color,@left,@bottom,@color,@right,@bottom,@color,3)
    end
end

class Ground < Gosu::Window
    def initialize(win,x,y,height,width,color)
        @x = x*1.0
        @y = y*1.0
        @height = height/2
        @width = width/2
        @color = color
        @white = Gosu::Color::WHITE
        @pattern = Array.new(10).map {Pattern.new(top,bottom,right,left,rand(0x33333333..0xbbbbbbbb))}
    end

    def top
        return @y-@height
    end

    def bottom
        return @y+@height
    end

    def right
        return @x+@width
    end

    def left
        return @x-@width
    end

    def update(camx)
        @x = @x - camx
        @pattern.each {|pattern|
        pattern.update(camx)}
    end

    def drawground
        draw_quad(@x-@width,@y-@height,@color,@x+@width,@y-@height,@color,@x-@width,@y+@height,@color,@x+@width,@y+@height,@color,2)
        @pattern.each {|pattern|
            pattern.draw}
    end
end