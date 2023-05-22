require 'gosu'
require 'httparty'
require './Button.rb'
require './Game.rb'
require './Start.rb'
require './End.rb'
require './Shop.rb'
require './Change_Effect.rb'

# HOST = 'https://fast-cove-76889.herokuapp.com'
HOST = 'http://10.1.8.97:3001'

class Star < Gosu::Window
    def initialize(win)
        @win = win
        @velocity = rand(-5..-1)
        @x = rand(2000)
        @initx = @x
        @y = rand(1300)
        @inity = @y
        @sizex = rand(0.5..1)
        @sizey = rand(5..20)
        @color = rand(0x99999999..0x99ffffff)
        @speed_decr = rand(2..7)
    end

    def move(mousex,mousey)
        if(!@win.game.pause && @win.state == 'game')
            @x = @x - @win.game.player.camx/@speed_decr
        elsif(@win.state != 'game')
            @x = @initx -(mousex-960)/(@speed_decr*4)
        end
        @y = (@y + @velocity)%1300
    end

    def draw
        draw_quad(@x-@sizex,@y-@sizey,@color,@x+@sizex,@y-@sizey,@color,@x-@sizex,@y+@sizey,@color,@x+@sizex,@y+@sizey,@color,-20)
    end
end

class Something < Gosu::Window
    def initialize(win, color)
        @win = win
        @color = color
        @x = rand(0..1920)
        @initx = @x
        @y = rand(0..1080)
        @inity = @y
        @width = rand(200..600)
        @height = rand(200..600)
        @speed_decr = rand(2..7)
    end

    def update(mousex,mousey)
        if(!@win.game.pause && @win.state == 'game')
            @x = @x - @win.game.player.camx/@speed_decr
        elsif(@win.state != 'game')
            @x = @initx -(mousex-960)/(@speed_decr*2.5)
            @y = @inity -(mousey-540)/(@speed_decr*2.5)
        end
    end

    def draw
        draw_quad(@x-@width,@y-@height,@color,@x+@width,@y-@height,@color,@x-@width,@y+@height,@color,@x+@width,@y+@height,@color,-19)
    end
end

class Record
    attr_accessor :name, :bestscore 
    def initialize(name, bestscore)
        @name = name
        @bestscore = bestscore
    end
end

class Main < Gosu::Window
    attr_accessor :state, :best, :score, :coin, :prevstate, :start, :game, :end, :shop, :gun, :skin, :power, :data, :rank, :num_of_records
    def initialize
        super(1920, 1080, true)
        self.caption = "CyberPunk 7702"
        @state = 'start'
        @prevstate = nil
        @gun = 'pistol'
        @skin = 'blue'
        @power = ''
        @coin = 0
        @best = 0
        @score = 0
        
        @rank = nil
        @num_of_records = 0
        loadrank()
        @data = []
        self.getdata
        @start = Start.new(self)
        @shop = Shop.new(self,@data)
        @game = Game.new(self,@gun,@skin,@power)
        @end = End.new(self)
        @title = Gosu::Font.new(self, Gosu::default_font_name, 150)
        @stars = Array.new(30).map {Star.new(self)}
        @somethings = Array.new(5).map {Something.new(self,rand(0x15333333..0x15bbbbbb))}
        @backgroundsong = Gosu::Song.new('./Assets/Songs/background.mp3')
        @cursor = Gosu::Image.new('./Assets/Images/cursor.png')
        @aim = Gosu::Image.new('./Assets/Images/aim.png')
        @backgroundsong.play(true)
        @backgroundsong.volume = 0.3
        @gradient1 = 0xff100000
        @gradient2 = 0xff200020
        @gradient3 = 0xff002020
        @gradient4 = 0xff000030
        @dir1 = true
        @dir2 = false
        @dir3 = true
        @dir4 = false
        @cursor_img = @cursor
    end

    def loadrank
        Thread.new {
            geturl = HOST + '/getgamedata'
            res = HTTParty.post(geturl)
            res = JSON.parse(res.body)
            @num_of_records = res.length
            if(@num_of_records > 6)
                count = 6
            else
                count = @num_of_records
            end
            rank = Array.new
            for i in 0..count-1
                rank << Record.new(res[i]["username"], res[i]["bestscore"])
            end
            @rank = rank
        }
    end

    def getdata
        file =File.open('./save.txt')
        @data = file.readlines.map(&:chomp)
        file.close
        @best = @data[0].to_i
        @coin = @data[1].to_i
    end

    def savedata(type, value)
        loc = 0
        file =File.open('./save.txt')
        data = file.readlines.map(&:chomp)
        file.close
        case type 
        when 'best'
            loc = 0
        when 'coin'
            loc = 1
        when 'pistol'
            loc = 2
        when 'shotgun'
            loc = 3
        when 'sniper'
            loc = 4
        when 'rifle'
            loc = 5
        when 'blue'
            loc = 6
        when 'green'
            loc = 7
        when 'rainbow'
            loc = 8
        when 'health'
            loc = 9
        when 'defense'
            loc = 10
        end
        File.open('./save.txt', 'w') {|f|
            for i in 0..10 do
                if(i==loc)
                    f.write value.to_s + "\n"
                else
                    f.write data[i].to_s + "\n"
                end
            end
        }
    end

    def changegun(gun)
        @gun = gun
    end

    def changeskin(skin)
        @skin = skin
    end

    def changepower(power)
        @power = power
    end

    def newgame
        @game = Game.new(self,@gun,@skin,@power)
    end

    def needs_cursor?
        false
    end
 
    def button_down(id)
        case @state
        when 'start'
            @start.getbtndown(id)
        when 'shop'
            @shop.getbtndown(id)
        when 'game'
            @game.getbtndown(id)
        when 'end'
            @end.getbtndown(id)
        end
    end
    
    def update
        if @score > @best
            @best = @score
        end
        @somethings.each {|something|
            something.update(mouse_x,mouse_y)
        }
        @stars.each {|star|
            star.move(mouse_x,mouse_y)
        }
        case @state
        when 'start'
            @start.update(mouse_x,mouse_y)
        when 'game'
            @game.update(mouse_x,mouse_y)
        when 'end'
            @end.update(mouse_x,mouse_y)
        when 'shop'
            @shop.update(mouse_x,mouse_y)
        end
        if(@gradient1 == 0xff300000)
            @dir1 = false
        elsif(@gradient1 == 0xff000000)
            @dir1 = true
        end
        if(@dir1)
            @gradient1 = @gradient1 + 0x00010000
        else
            @gradient1 = @gradient1 - 0x00010000
        end
        if(@gradient2 == 0xff300030)
            @dir2 = false
        elsif(@gradient2 == 0xff000000)
            @dir2 = true
        end
        if(@dir2)
            @gradient2 = @gradient2 + 0x00010001
        else
            @gradient2 = @gradient2 - 0x00010001
        end
        if(@gradient4 == 0xff000030)
            @dir4 = false
        elsif(@gradient4 == 0xff000000)
            @dir4 = true
        end
        if(@dir4)
            @gradient4 = @gradient4 + 0x00000001
        else
            @gradient4 = @gradient4 - 0x0000001
        end
        if(@gradient3 == 0xff003030)
            @dir3 = false
        elsif(@gradient3 == 0xff000000)
            @dir3 = true
        end
        if(@dir3)
            @gradient3 = @gradient3 + 0x00000101
        else
            @gradient3 = @gradient3 - 0x00000101
        end
    end

    def draw
        @somethings.each {|something|
            something.draw
        }
        @stars.each {|star|
            star.draw
        }
        case @state
        when 'start'
            @cursor_img = @cursor
            @start.draw
        when 'game'
            @cursor_img = @aim
            @game.draw
        when 'end'
            @cursor_img = @cursor
            @end.draw
        when 'shop'
            @cursor_img = @cursor
            @shop.draw
        end
        if(@state != 'game')
            @cursor_img.draw(mouse_x-12,mouse_y-10,100,1,1,0xffffffff)
        else
            @cursor_img.draw(mouse_x-(@cursor_img.width/2)*0.3,mouse_y-(@cursor_img.height/2)*0.3,100,0.3,0.3,0xffffffff)
        end
        draw_quad(0,0,@gradient1,1920,0,@gradient2,0,1080,@gradient3,1920,1080,@gradient4,-50)
    end
end

Main.new.show