require 'gosu'

class About < Gosu::Window
    def initialize(win,start)
        @win = win
        @start = start
        @x = 1920/2
        @y = 1080
        @width = 1920/2
        @height = 1080/2
        @fkin_big_font = Gosu::Font.new(@win, Gosu::default_font_name, 250)
        @bigger_font = Gosu::Font.new(@win,Gosu::default_font_name,100)
        @abit_bigger_font = Gosu::Font.new(@win, Gosu::default_font_name, 90)
        @big_font = Gosu::Font.new(@win,Gosu::default_font_name,80)
        @abit_smaller_font = Gosu::Font.new(@win,Gosu::default_font_name,60)
        @small_font = Gosu::Font.new(@win,Gosu::default_font_name,50)
        @back_btn = Button.new(@win,'<',90,90,50,50,0xffff0000)
        @click = Gosu::Sample.new('./Assets/Songs/click.mp3')
        @opening = Opening_Effect.new()
        @closing = Closing_Effect.new()
        @close = false
    end

    def getbtndown(id)
        if(id == 256 && @back_btn.hover)
            @back_btn.hover = false
            @close = true
            @click.play
        end
    end

    def update(mousex,mousey)
        @opening.update
        if(@close)
            @closing.update
            if(@closing.change)
                @start.reset
                @start.about = false
            end
        end
        @back_btn.update(mousex,mousey)
        if(@y >= 0-(210+250+100+80+50+80+50+80+50+80+50+80+50+80+30))
            @y = @y - 3
        else
            @close = true
        end
    end

    def center(text, font)
        return font.text_width(text)/2
    end

    def draw_content
        @fkin_big_font.draw_text("CyberPunk", 350, @y,8,1.0,1.0, Gosu::Color::YELLOW)
        rotate(90, 1540, @y+40){@abit_bigger_font.draw_text("7702", 1540, @y+40,8,1.0,1.0, Gosu::Color::RED)}
        @bigger_font.draw_text('Credits',@x-center('Credits', Gosu::Font.new(@win,Gosu::default_font_name,100)),@y+250,8,1,1,Gosu::Color::WHITE)
        @big_font.draw_text('Director:',@x-center('Director:', @big_font),@y+35+250+100,8,1,1,Gosu::Color::WHITE)
        @small_font.draw_text('Hoang Minh Khue',@x-center('Hoang Minh Khue', @small_font),@y+35+250+100+80,8,1,1,Gosu::Color::WHITE)
        @big_font.draw_text('Designer:',@x-center('Designer:', @big_font),@y+70+250+100+80+50,8,1,1,Gosu::Color::WHITE)
        @small_font.draw_text('Hoang Minh Khue',@x-center('Hoang Minh Khue', @small_font),@y+70+250+100+80+50+80,8,1,1,Gosu::Color::WHITE)
        @big_font.draw_text('Programmer:',@x-center('Programmer:', @big_font),@y+105+250+100+80+50+80+50,8,1,1,Gosu::Color::WHITE)
        @small_font.draw_text('Hoang Minh Khue',@x-center('Hoang Minh Khue', @small_font),@y+105+250+100+80+50+80+50+80,8,1,1,Gosu::Color::WHITE)
        @big_font.draw_text('Sound Effect:',@x-center('Sound Effect:', @big_font),@y+140+250+100+80+50+80+50+80+50,8,1,1,Gosu::Color::WHITE)
        @small_font.draw_text('pixabay.com',@x-center('pixabay.com', @small_font),@y+140+250+100+80+50+80+50+80+50+80,8,1,1,Gosu::Color::WHITE)
        @big_font.draw_text('Images:',@x-center('Images:', @big_font),@y+175+250+100+80+50+80+50+80+50+80+50,8,1,1,Gosu::Color::WHITE)
        @small_font.draw_text('pngimg.com & icons8.com',@x-center('pngimg.com & icons8.com', @small_font),@y+175+250+100+80+50+80+50+80+50+80+50+80,8,1,1,Gosu::Color::WHITE)
        @big_font.draw_text('Some Ideas were from:',@x-center('Some Ideas were from:', @big_font),@y+210+250+100+80+50+80+50+80+50+80+50+80+50,8,1,1,Gosu::Color::WHITE)
        @small_font.draw_text('Luu Tuan Hoang',@x-center('Luu Tuan Hoang', @small_font),@y+210+250+100+80+50+80+50+80+50+80+50+80+50+80,8,1,1,Gosu::Color::WHITE)
    end

    def draw
        @opening.draw
        if(@close)
            @closing.draw
        end
        draw_quad(@x-@width,0,0xff000000,@x+@width,0,0xff000000,@x-@width,400,0x00000000,@x+@width,400,0x00000000,9)
        draw_quad(@x-@width,680,0x00000000,@x+@width,680,0x00000000,@x-@width,1080,0xff000000,@x+@width,1080,0xff000000,9)
        @back_btn.draw
        draw_content()
    end
end

class Instruction < Gosu::Window
    def initialize(win,x,y)
        @win = win
        @x = x
        @y = y
        @width = 350
        @height = 350
        @big_font = Gosu::Font.new(@win,Gosu::default_font_name,80)
        @abit_smaller_font = Gosu::Font.new(@win,Gosu::default_font_name,60)
        @small_font = Gosu::Font.new(@win,Gosu::default_font_name,50)
    end

    def update
    end

    def draw
        @big_font.draw_text('INSTRUCTIONS:',@x-@big_font.text_width('INSTRUCTIONS:')/2,@y-340,5,1,1,0xaabb0000)
        @abit_smaller_font.draw_text("-Press 'Start' Button to Play.",@x-330,@y-240,5,1,1,0xff999999)
        @small_font.draw_text('+Press A to move Left.',@x-280,@y-180,5,1,1,0xaa999999)
        @small_font.draw_text('+Press D to move Right.',@x-280,@y-180+55,5,1,1,0xaa999999)
        @small_font.draw_text('+Press SPACE to Jump.',@x-280,@y-180+55*2,5,1,1,0xaa999999)
        @small_font.draw_text('+Press Left Mouse to Shoot.',@x-280,@y-180+55*3,5,1,1,0xaa999999)
        @abit_smaller_font.draw_text("-Press 'Shop' Button to\nChange weapon, skin,\nand power.",@x-330,@y-180+55*4,5,1,1,0xff999999)
        @abit_smaller_font.draw_text("-Press 'About' Button to\nLearn more.",@x-330,@y-180+55*4+60*3,5,1,1,0xff999999)
        draw_quad(@x-@width,@y-@height,0x55333333,@x+@width,@y-@height,0x55333333,@x-@width,@y+@height,0x55333333,@x+@width,@y+@height,0x55333333,4)
    end
end

class Rank < Gosu::Window
    def initialize(win,x,y)
        @win = win
        @x = x
        @y = y
        @width = 350
        @height = 350
        @big_font = Gosu::Font.new(@win,Gosu::default_font_name,80)
        @abit_smaller_font = Gosu::Font.new(@win,Gosu::default_font_name,60)
        @small_font = Gosu::Font.new(@win,Gosu::default_font_name,50)
        @name_font = Gosu::Font.new(@win,Gosu::default_font_name,47)
        @score_font = Gosu::Font.new(@win,Gosu::default_font_name,40)
        @name1 = "Khue"
        @score1 = 10000
        @win.num_of_records = @win.num_of_records
    end

    def update 
    end

    def draw
        @big_font.draw_text('TOP SCORES:',@x-@big_font.text_width('TOP SCORES:')/2,@y-340,5,1,1,0xaabb0000)
        if(@win.rank != nil)
            draw_quad(@x-@width,@y-198.5-43.5,0x55ff0000,@x+@width,@y-198.5-43.5,0x55ff0000,@x-@width,@y-198.5+43.5,0x55ff0000,@x+@width,@y-198.5+43.5,0x55ff0000,5)
            draw_quad(@x-@width,@y-198.5+87-43.5,0x550000ff,@x+@width,@y-198.5+87-43.5,0x550000ff,@x-@width,@y-198.5+87+43.5,0x550000ff,@x+@width,@y-198.5+87+43.5,0x550000ff,5)
            draw_quad(@x-@width,@y-198.5+87*2-43.5,0x55ffff00,@x+@width,@y-198.5+87*2-43.5,0x55ffff00,@x-@width,@y-198.5+87*2+43.5,0x55ffff00,@x+@width,@y-198.5+87*2+43.5,0x55ffff00,5)
            draw_quad(@x-@width,@y-198.5+87*3-43.5,0x5500ff00,@x+@width,@y-198.5+87*3-43.5,0x5500ff00,@x-@width,@y-198.5+87*3+43.5,0x5500ff00,@x+@width,@y-198.5+87*3+43.5,0x5500ff00,5)
            draw_quad(@x-@width,@y-198.5+87*4-43.5,0x5500ff00,@x+@width,@y-198.5+87*4-43.5,0x5500ff00,@x-@width,@y-198.5+87*4+43.5,0x5500ff00,@x+@width,@y-198.5+87*4+43.5,0x5500ff00,5)
            draw_quad(@x-@width,@y-198.5+87*5-43.5,0x5500ff00,@x+@width,@y-198.5+87*5-43.5,0x5500ff00,@x-@width,@y-198.5+87*5+43.5,0x5500ff00,@x+@width,@y-198.5+87*5+43.5,0x5500ff00,5)
            
            Gosu::Font.new(@win,Gosu::default_font_name,80).draw_text('1',@x-@width+21.75,@y-198.5-43.5+4,6,1,1,0xffffffff)
            if(@win.num_of_records >= 1)
                @name_font.draw_text(@win.rank[0].name,@x-@width+90,@y-198.5-43.5,6,1.4,1,0xffffffff)
                @score_font.draw_text(@win.rank[0].bestscore.to_s,@x-@width+90,@y-198.5-43.5+47,6,1,1,0xffffffff)
            end
            draw_quad(@x-@width,@y-198.5-43.5,0xaaff0000,@x-@width+87,@y-198.5-43.5,0xaaff0000,@x-@width,@y-198.5+43.5,0xaaff0000,@x-@width+87,@y-198.5+43.5,0xaaff0000,5)
            Gosu::Font.new(@win,Gosu::default_font_name,80).draw_text('2',@x-@width+21.75,@y-198.5+87-43.5+4,6,1,1,0xffffffff)
            if(@win.num_of_records >= 2)
                @name_font.draw_text(@win.rank[1].name,@x-@width+90,@y-198.5+87-43.5,6,1.4,1,0xffffffff)
                @score_font.draw_text(@win.rank[1].bestscore.to_s,@x-@width+90,@y-198.5+87-43.5+47,6,1,1,0xffffffff)
            end
            draw_quad(@x-@width,@y-198.5+87-43.5,0xaa0000ff,@x-@width+87,@y-198.5+87-43.5,0xaa0000ff,@x-@width,@y-198.5+87+43.5,0xaa0000ff,@x-@width+87,@y-198.5+87+43.5,0xaa0000ff,5)
            Gosu::Font.new(@win,Gosu::default_font_name,80).draw_text('3',@x-@width+21.75,@y-198.5+87*2-43.5+4,6,1,1,0xffffffff)
            if(@win.num_of_records >= 3)
                @name_font.draw_text(@win.rank[2].name,@x-@width+90,@y-198.5+87*2-43.5,6,1.4,1,0xffffffff)
                @score_font.draw_text(@win.rank[2].bestscore.to_s,@x-@width+90,@y-198.5+87*2-43.5+47,6,1,1,0xffffffff)
            end
            draw_quad(@x-@width,@y-198.5+87*2-43.5,0xaaffff00,@x-@width+87,@y-198.5+87*2-43.5,0xaaffff00,@x-@width,@y-198.5+87*2+43.5,0xaaffff00,@x-@width+87,@y-198.5+87*2+43.5,0xaaffff00,5)
            Gosu::Font.new(@win,Gosu::default_font_name,80).draw_text('4',@x-@width+21.75,@y-198.5+87*3-43.5+4,6,1,1,0xffffffff)
            if(@win.num_of_records >= 4)
                @name_font.draw_text(@win.rank[3].name,@x-@width+90,@y-198.5+87*3-43.5,6,1.4,1,0xffffffff)
                @score_font.draw_text(@win.rank[3].bestscore.to_s,@x-@width+90,@y-198.5+87*3-43.5+47,6,1,1,0xffffffff)
            end
            draw_quad(@x-@width,@y-198.5+87*3-43.5,0xaa00ff00,@x-@width+87,@y-198.5+87*3-43.5,0xaa00ff00,@x-@width,@y-198.5+87*3+43.5,0xaa00ff00,@x-@width+87,@y-198.5+87*3+43.5,0xaa00ff00,5)
            Gosu::Font.new(@win,Gosu::default_font_name,80).draw_text('5',@x-@width+21.75,@y-198.5+87*4-43.5+4,6,1,1,0xffffffff)
            if(@win.num_of_records >= 5)
                @name_font.draw_text(@win.rank[4].name,@x-@width+90,@y-198.5+87*4-43.5,6,1.4,1,0xffffffff)
                @score_font.draw_text(@win.rank[4].bestscore.to_s,@x-@width+90,@y-198.5+87*4-43.5+47,6,1,1,0xffffffff)
            end
            draw_quad(@x-@width,@y-198.5+87*4-43.5,0xaa00ff00,@x-@width+87,@y-198.5+87*4-43.5,0xaa00ff00,@x-@width,@y-198.5+87*4+43.5,0xaa00ff00,@x-@width+87,@y-198.5+87*4+43.5,0xaa00ff00,5)
            Gosu::Font.new(@win,Gosu::default_font_name,80).draw_text('6',@x-@width+21.75,@y-198.5+87*5-43.5+4,6,1,1,0xffffffff)
            if(@win.num_of_records >= 6)
                @name_font.draw_text(@win.rank[5].name,@x-@width+90,@y-198.5+87*5-43.5,6,1.4,1,0xffffffff)
                @score_font.draw_text(@win.rank[5].bestscore.to_s,@x-@width+90,@y-198.5+87*5-43.5+47,6,1,1,0xffffffff)
            end
            draw_quad(@x-@width,@y-198.5+87*5-43.5,0xaa00ff00,@x-@width+87,@y-198.5+87*5-43.5,0xaa00ff00,@x-@width,@y-198.5+87*5+43.5,0xaa00ff00,@x-@width+87,@y-198.5+87*5+43.5,0xaa00ff00,5)
            @name_font.draw_text('Total records: ' + @win.num_of_records.to_s,@x-@name_font.text_width('Total records: ' + @win.num_of_records.to_s)/2,@y-198.5+87*6-43.5+20,6,1,1,0xffffffff)
        else
            @abit_smaller_font.draw_text("...Loading...",@x-@abit_smaller_font.text_width("...Loading...")/2,@y,5,1,1,0xffffffff)
        end
        draw_quad(@x-@width,@y-@height,0x55333333,@x+@width,@y-@height,0x55333333,@x-@width,@y+@height,0x55333333,@x+@width,@y+@height,0x55333333,4)
    end
end

class Start < Gosu::Window
    attr_accessor :about
    def initialize(win)
        @win = win
        @playx = 960.0
        @playy = 460.0
        @shopy = 710.0
        @credity = 960.0
        @click = Gosu::Sample.new('./Assets/Songs/click.mp3')
        @play_btn = Button.new(@win,'Start',@playx,@playy,200,100,0xff990000)
        @shop_btn = Button.new(@win,'Shop',@playx,@shopy,200,100,0xff990000)
        @cre_btn = Button.new(@win,"About",@playx,@credity,200,100,0xff990000)
        @reset_btn = Button.new(@win,"Reset",130,60,120,50,0xffff0000)
        @sure_btn = Button.new(@win,"Sure",130,180,120,50,0xffff0000)
        @exit_btn = Button.new(@win,"X",1860,60,50,50,0xffff0000)
        @pending_reset = false
        @instruction = Instruction.new(@win,1540,710)
        @win.loadrank
        @rank = Rank.new(@win,380,710)
        @about_section = About.new(@win,self)
        @about = false
        @opening = Opening_Effect.new()
        @closing = Closing_Effect.new()
        @close = false
        @heading = 0
    end

    def reset
        @opening = Opening_Effect.new()
        @closing = Closing_Effect.new()
        @close = false
        @heading = 0
    end

    def reset_data
        File.open('./save.txt', 'w') {|f|
            for i in 0..10 do
                if(i==2 || i==6)
                    f.write 2.to_s + "\n"
                else
                    f.write 0.to_s + "\n"
                end
            end
        }
        @win.getdata
        @win.gun = 'pistol'
        @win.skin = 'blue'
        @win.power = ''
    end

    def getbtndown(id)
        if(!@about)
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
            if(id == 256 && @cre_btn.hover)
                @cre_btn.hover = false
                @close = true
                @heading = 3
                @click.play
            end
            if(id == 256 && @reset_btn.hover)
                @reset_btn.hover = false
                @pending_reset = !@pending_reset
                @click.play
            end
            if(id == 256 && @exit_btn.hover)
                @exit_btn.hover = false
                @click.play
                @win.close
            end
            if(@pending_reset && id == 256 && @sure_btn.hover)
                @sure_btn.hover = false
                reset_data()
                @close = true
                @heading = 4
                @click.play
            end
        else
            @about_section.getbtndown(id)
        end
    end

    def update(mousex,mousey)
        if(!@about)
            @play_btn.update(mousex,mousey)
            @shop_btn.update(mousex,mousey)
            @cre_btn.update(mousex,mousey)
            @reset_btn.update(mousex,mousey)
            @exit_btn.update(mousex,mousey)
            if(@pending_reset)
                @sure_btn.update(mousex,mousey)
            end
            @instruction.update
            @rank.update
            @opening.update
            if(@close)
                @closing.update
                if(@closing.change)
                    case @heading
                    when 1
                        @win.newgame
                        @win.state = 'game'
                    when 2
                        @win.prevstate = 'start'
                        @win.shop = Shop.new(@win, @win.data)
                        @win.state = 'shop'
                    when 3
                        @about_section = About.new(@win,self)
                        @about = true
                    when 4
                        @win.start = Start.new(@win)
                        @win.state = 'start'
                    end
                end
            end
        else
            @about_section.update(mousex,mousey)
        end
    end

    def draw
        if(!@about)
            @opening.draw
            if(@close)
                @closing.draw
            end
            @play_btn.draw
            @shop_btn.draw
            @cre_btn.draw
            @reset_btn.draw
            @exit_btn.draw
            if(@pending_reset)
                @sure_btn.draw
            end
            @instruction.draw
            @rank.draw
            Gosu::Font.new(@win, Gosu::default_font_name, 250).draw_text("CyberPunk", 350, 50,1,1.0,1.0, Gosu::Color::YELLOW)
            rotate(90, 1540, 90){Gosu::Font.new(@win, Gosu::default_font_name, 90).draw_text("7702", 1540, 90,1,1.0,1.0, Gosu::Color::RED)}
        else
            @about_section.draw
        end
    end
end