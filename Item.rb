require 'gosu'
require './Gun.rb'
require './Player.rb'

class Item < Gosu::Window
    attr_accessor :ground, :bullet, :currentsec
    def initialize(shop, win, column, row, name, price, status,category)
        @category = category
        @shop = shop
        @win = win
        @column = column
        @row = row
        @name = name
        @ground = []
        @bullet = []
        case name
        when 'Pistol'
            @type = 'pistol'
        when 'Shotgun'
            @type = 'shotgun'
        when 'Sniper'
            @type = 'sniper'
        when 'Rifle'
            @type = 'rifle'
        when 'Blue'
            @type = 'blue'
        when 'Green'
            @type = 'green'
        when 'Rainbow'
            @type = 'rainbow'
        when 'Health'
            @type = 'health'
        when 'Defense'
            @type = 'defense'
        end
        @price = price
        @status = status
        if(@status == 'equiped')
            case @category
            when 'weapon'
                @shop.equipweapon(@type)
            when 'skin'
                @shop.equipskin(@type)
            when 'power'
                @shop.equippower(@type)
            end
        end
        @gun = Gun.new(self,self,'pistol')
        @player = Player.new(self,@gun,@type,'')
        @black = 0xff000000
        @height = 250
        @width = 222.5
        @x = 195 + (@column - 1)*@width + @column*@width + 100*(@column - 1)
        @inity = 260 + (@row - 1)*@height + @row*@height + 100*(@row - 1)
        @y = @inity
        @click = Gosu::Sample.new('./Assets/Songs/click.mp3') 
        @denied = Gosu::Sample.new('./Assets/Songs/denied.mp3')
        @text = Gosu::Font.new(@win, Gosu::default_font_name, 60)
        @scrolled = 0
        case @status
        when 'locked'
            @btn = Button.new(@win,@price.to_s,@x,@y+175,155,50,0xffaa0000)
        when 'unlocked'
            @btn = Button.new(@win,'Equip',@x,@y+175,155,50,0xff00aa00)
        when 'equiped'
            @btn = Button.new(@win,'Equiped',@x,@y+175,155,50,0xffaaaa00)
            @btn.keep = true
        end
    end

    def gettype
        return @type
    end

    def getstatus
        return @status
    end

    def getcategory
        return @category
    end

    def setstatus(status)
        @status = status
        case @status
        when 'locked'
            @btn.text = @price.to_s
            @btn .change_color(0xffaa0000)
            @btn.keep = false
        when 'unlocked'
            @btn.text = 'Equip'
            @btn .change_color(0xff00aa00)
            @btn.keep = false
        when 'equiped'
            @btn.text = 'Equiped'
            @btn .change_color(0xffaaaa00)
            @btn.keep = true
        end
    end

    def getbtndown(id)
        if(id == 256 && @btn.hover == true)
            @btn.hover = false
            case @status
            when 'locked'
                if(@win.coin >= @price)
                    @click.play
                    @win.savedata(@type,1)
                    @status = 'unlocked'
                    @btn.text = 'Equip'
                    @btn .change_color(0xff00aa00)
                    @win.coin = @win.coin - @price
                    @win.savedata('coin',@win.coin)
                    @win.getdata
                else
                    @denied.play
                end
            when 'unlocked'
                @click.play
                @status = 'equiped'
                @btn.text = 'Equiped'
                @btn .change_color(0xffaaaa00)
                @btn.keep = true
                @shop.unequipothers(self,@category)
                @win.savedata(@type,2)
                @win.getdata
                case @category
                when 'weapon'
                    @shop.equipweapon(@type)
                when 'skin'
                    @shop.equipskin(@type)
                when 'power'
                    @shop.equippower(@type)
                end
            when 'equiped'
                if(@category == 'power')
                    @click.play
                    @status = 'unlocked'
                    @btn.text = 'Equip'
                    @btn .change_color(0xff00aa00)
                    @shop.equippower('')
                    @win.savedata(@type,1)
                    @win.getdata
                else
                    @denied.play
                end
            end
            
        end
    end

    def update(mousex,mousey,scroll)
        @y = @inity - scroll
        @btn.scroll = - scroll
        @btn.update(mousex,mousey)
    end

    def draw
        case @name
        when 'Pistol'
            @gun.Pistol(@x-20,@y-120)
        when 'Shotgun'
            @gun.Shotgun(@x-40,@y-120)
        when 'Sniper'
            @gun.Sniper(@x-50,@y-120)
        when 'Rifle'
            @gun.Rifle(@x-40,@y-120)
        when 'Blue'
            @player.blue(@x,@y-120)
        when 'Green'
            @player.green(@x,@y-120)
        when 'Rainbow'
            @player.rainbow(@x,@y-120)
        when 'Health'
            draw_quad(@x-80,@y-120-20,Gosu::Color::GREEN,@x+80,@y-120-20,Gosu::Color::GREEN,@x-80,@y-120+20,Gosu::Color::GREEN,@x+80,@y-120+20,Gosu::Color::GREEN,9)
            draw_quad(@x-20,@y-120-80,Gosu::Color::GREEN,@x+20,@y-120-80,Gosu::Color::GREEN,@x-20,@y-120+80,Gosu::Color::GREEN,@x+20,@y-120+80,Gosu::Color::GREEN,9)
        when 'Defense'
            draw_quad(@x-50, @y-120-50, Gosu::Color::GRAY, @x+50, @y-120-50, Gosu::Color::GRAY, @x-50,@y-120+50, Gosu::Color::GRAY, @x+50, @y-120+50, Gosu::Color::GRAY,9)
        end
        draw_quad(@x-202.5,@y,0xff000000,@x+202.5,@y,0xff000000,@x-202.5,@y-230,0xff000000,@x+202.5,@y-230,0xff000000,-7)
        draw_quad(@x-@width, @y-@height, 0xff444444,@x+@width, @y-@height, 0xff444444,@x-@width, @y+@height, 0xff444444,@x+@width, @y+@height, 0xff444444,-10)
        @text.draw_text(@name,@x-@text.text_width(@name)/2,@y+5,1,1.0,1.0, Gosu::Color::WHITE)
        @btn.draw
    end
end