class Opening_Effect < Gosu::Window
    def initialize()
        @opening_color = 0xff000000
        @playing = true
    end

    def update
        if(@opening_color - 0x05000000 >= 0x00000000 && @playing)
            @opening_color = @opening_color - 0x05000000
        else
            @playing = false
        end
    end

    def draw
        if(@playing)
            draw_quad(960-1000, 540-2000, @opening_color,960+1000, 540-2000, @opening_color,960-1000, 540+2000, @opening_color,960+1000, 540+2000, @opening_color,50)
        end
    end
end

class Closing_Effect < Gosu::Window
    attr_accessor :change
    def initialize()
        @opening_color = 0x00000000
        @change = false
        @playing = true
    end

    def update
        if(@opening_color + 0x05000000 <= 0xff000000 && @playing)
            @opening_color = @opening_color + 0x05000000
        else
            @playing = false
            @change = true
        end
    end

    def draw
        if(@playing)
            draw_quad(960-1000, 540-2000, @opening_color,960+1000, 540-2000, @opening_color,960-1000, 540+2000, @opening_color,960+1000, 540+2000, @opening_color,50)
        end
    end
end