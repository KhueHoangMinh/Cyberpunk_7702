require 'gosu'
class Button < Gosu::Window
    attr_accessor :hover, :keep, :text, :scroll, :zindex, :enable
    def initialize(win,text,x,y,sizex,sizey,color)
        @win = win
        @text = text
        @x = x
        @y = y
        @base_color = color - 0x88000000
        @max_color = color
        @color = @base_color
        @sizex = sizex
        @sizey = sizey
        @hover = false
        @font = Gosu::Font.new(@win, Gosu::default_font_name, 90)
        @text_posx = @x - @font.text_width(@text)/2
        @text_posy = @y - 45
        @keep = false
        @scroll = 0
        @zindex = 10
        @enable = true
    end

    def change_color(color)
        @base_color = color - 0x88000000
        @max_color = color
        @color = @base_color
    end

    def update(mouse_x,mouse_y)
        if(@enable)
            @text_posx = @x - @font.text_width(@text)/2
            if(@keep)
                @color = @max_color
            end
            if(@x-@sizex <= mouse_x && @x+@sizex >= mouse_x && @scroll+@y-@sizey <= mouse_y && @scroll+@y+@sizey >= mouse_y)
                if(@color + 0x04_000000 <= @max_color && !@keep)
                    @color += 0x04_000000 
                end
                @hover = true
            else
                if(@color - 0x04_000000  >= @base_color && !@keep)
                    @color -= 0x04_000000 
                end
                @hover = false
            end
        end
    end

    def draw
        @font.draw_text(@text,@text_posx,@scroll+@text_posy,@zindex+1,1,1,Gosu::Color::WHITE)
        draw_quad(@x-@sizex,@scroll+@y-@sizey,@color,@x+@sizex,@scroll+@y-@sizey,@color,@x-@sizex,@scroll+@y+@sizey,@color,@x+@sizex,@scroll+@y+@sizey,@color,@zindex)
    end
end