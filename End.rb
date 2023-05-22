require "gosu"
require "httparty"

class InputField < Gosu::TextInput
    attr_accessor :hover
    def initialize(win,font,x,y)
        super()
        @win = win
        @font = font
        @x = x
        @y = y
        @inactive = 0xffcccccc
        @active = 0xffffffff
        @color = @inactive
        self.text = ''
        @caret_x = @x -width + @font.text_width(self.text[0...self.caret_pos])
    end

    def select
        self.text = ''
        @color = @active
    end

    def deselect
        self.text = ''
        @color = @inactive
    end

    def movecaret()
        for i in 0..self.text.length
            if(@mouse_x - (@x-width) < @font.text_width(text[0...i]))
                self.caret_pos = self.selection_start = i - 1
                return
            end
        end
        self.caret_pos = self.selection_start = self.text.length
    end

    def update(mouse_x,mouse_y)
        @mouse_x = mouse_x
        @caret_x = @x-width + @font.text_width(self.text[0...self.caret_pos])
        if(mouse_x <= @x +width && mouse_x >= @x-width && mouse_y <= @y + height && mouse_y >= @y)
            @hover = true
        else
            @hover = false
        end
    end

    def draw_caret
        @win.draw_line(@caret_x,@y,0xff000000,@caret_x,@y+height,0xff000000,21)
    end

    def draw
        @win.draw_quad(@x-width,@y,@color,@x+width,@y,@color,@x-width,@y+height,@color,@x+width,@y+height,@color,19)
        @font.draw_text(self.text,@x-width,@y,21,1,1,Gosu::Color::BLACK)
        if(@win.text_input == self)
            draw_caret()
        end
    end

    def width
        430
    end

    def height
        @font.height
    end
end

class End < Gosu::Window
    attr_accessor :name
    def initialize(win)
        @win = win
        @playx = 960.0
        @playy = 460.0
        @shopy = 710.0
        @homey = 960.0
        @click = Gosu::Sample.new('./Assets/Songs/click.mp3')
        @big_font = Gosu::Font.new(@win, Gosu::default_font_name, 100)
        @small_font = Gosu::Font.new(@win, Gosu::default_font_name, 80)
        @play_btn = Button.new(@win,'Restart',@playx,@playy,200,100,0xff990000)
        @shop_btn = Button.new(@win,'Shop',@playx,@shopy,200,100,0xff990000)
        @home_btn = Button.new(@win,"Home",@playx,@homey,200,100,0xff990000)
        @cancel_btn = Button.new(@win,'Cancel',960-220,@shopy,200,100,0xff990000)
        @cancel_btn.zindex = 22
        @save_btn = Button.new(@win,"Save",960+220,@shopy,200,100,0xff990000)
        @save_btn.zindex = 22
        @opening = Opening_Effect.new()
        @closing = Closing_Effect.new()
        @close = false
        @heading = 0
        @reach_best = false
        @name = ''
        if(@win.best <= @win.score)
            @reach_best = true
            @input_field = InputField.new(@win,Gosu::Font.new(@win,Gosu::default_font_name,100),960,460)
            @win.text_input = @input_field 
        end
    end

    def getbtndown(id)
        if(id == 256 && @play_btn.hover)
            @play_btn.hover = false
            @close = true
            @heading = 1
            @click.play
        end
        if(id == 256 && @shop_btn.hover)
            @shop_btn.hover = false
            @close = true
            @heading = 2
            @click.play
        end
        if(id == 256 && @home_btn.hover)
            @home_btn.hover = false
            @close = true
            @heading = 3
            @click.play
        end
        if(id == 256 && @cancel_btn.hover)
            @cancel_btn.hover = false
            @reach_best = false
            @win.score = 0
            @click.play
        end
        if(id == 256 && @save_btn.hover)
            @save_btn.hover = false
            @reach_best = false
            savedata(@input_field.text,@win.best)
            @win.score = 0
            @input_field.text = ''
            @click.play
        end
    end

    def savedata(name, bestscore)
        Thread.new {
            posturl = HOST + '/insertgamedata'
            res = HTTParty.post(posturl, :body => {
                :playername => name,
                :bestscore => bestscore,
            }.to_json,:headers => { 'Content-Type' => 'application/json' })
        }
    end

    def update(mousex,mousey)
        @opening.update
        if(!@reach_best)
            @play_btn.update(mousex,mousey)
            @shop_btn.update(mousex,mousey)
            @home_btn.update(mousex,mousey)
            if(@close)
                @closing.update
                if(@closing.change)
                    case @heading
                    when 1
                        @win.newgame
                        @win.state = 'game'
                    when 2
                        @win.prevstate = 'end'
                        @win.shop = Shop.new(@win, @win.data)
                        @win.state = 'shop'
                    when 3
                        @win.start = Start.new(@win)
                        @win.state = 'start'
                    end
                end
            end
        else
            @cancel_btn.update(mousex,mousey)
            @save_btn.update(mousex,mousey)
            @input_field.update(mousex,mousey)
        end
    end

    def draw
        @opening.draw
        if(@close)
            @closing.draw
        end
        @play_btn.draw
        @shop_btn.draw
        @home_btn.draw
        Gosu::Font.new(@win, Gosu::default_font_name, 180).draw_text("Your Score: " + @win.score.to_s, 960 - Gosu::Font.new(@win, Gosu::default_font_name, 180).text_width("Your Score: " + @win.score.to_s)/2, 50,1, 1.0, 1.0, Gosu::Color::GREEN)
        @small_font.draw_text("Best Score: " + @win.best.to_s, 960 - @small_font.text_width("Best Score: " + @win.best.to_s)/2, 250,1, 1.0, 1.0, Gosu::Color::RED)
        if(@reach_best == true)
            @big_font.draw_text("Passed Bestscore",960-@big_font.text_width('Passed Bestscore')/2,150,21,1,1,Gosu::Color::WHITE)
            @small_font.draw_text("Save Bestscore: " + @win.best.to_s,960-@small_font.text_width("Save Bestscore: " + @win.best.to_s)/2,270,21,1,1,Gosu::Color::RED)
            Gosu::Font.new(@win, Gosu::default_font_name, 60).draw_text("Enter your name: " ,530,400,21,1,1,Gosu::Color::WHITE)
            draw_quad(960-1000,540-1000,0x33_555555,960+1000,540-1000,0x33_555555,960-1000,540+1000,0x33_555555,960+1000,540+1000,0x33_555555,16)
            draw_quad(960-600,540-400,0xff_555555,960+600,540-400,0xff_555555,960-600,540+400,0xff_555555,960+600,540+400,0xff_555555,17)
            @cancel_btn.draw
            @save_btn.draw
            @input_field.draw
        end
    end
end