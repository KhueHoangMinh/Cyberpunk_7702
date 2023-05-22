require 'gosu'
require './Item.rb'

class Shop <Gosu::Window
    def initialize(win,data)
        @win = win
        @id = 0
        @scroll = 0
        @scrolled = 0
        @red = Gosu::Color.argb(0x33_ff0000)
        @green = Gosu::Color.argb(0xff_00cc00)
        @gray = Gosu::Color.argb(0xff_303030)
        @click = Gosu::Sample.new('./Assets/Songs/click.mp3')
        @weapcolor = @red
        @skincolor = @red
        @powercolor = @red
        @show = 'weapon'
        @data = data
        @weapon_btn = Button.new(@win,'Weapons',417.5,129,222.5,31,0xff00ff00)
        @skin_btn = Button.new(@win,'Skins',417.5+2*222.5+100,129,222.5,31,0xff00ff00)
        @power_btn = Button.new(@win,'Powers',417.5+4*222.5+2*100,129,222.5,31,0xff00ff00)
        @back_btn = Button.new(@win,'',90,90,50,50,0xffff0000)
        @weapon_btn.keep = true
        @weapon_btn.zindex = 14
        @skin_btn.zindex = 14
        @power_btn.zindex = 14
        @back_btn.zindex = 14
        self.setdata
        @weapons = []
        @weapons.push(Item.new(self, @win, 1, 1, 'Pistol',10, @data[2],'weapon'))
        @weapons.push(Item.new(self, @win, 2, 1, 'Shotgun',60, @data[3],'weapon'))
        @weapons.push(Item.new(self, @win, 3, 1, 'Sniper',60, @data[4],'weapon'))
        @weapons.push(Item.new(self, @win, 1, 2, 'Rifle',60, @data[5],'weapon'))
        
        @skins = []
        @skins.push(Item.new(self, @win, 1, 1, 'Blue',99, @data[6],'skin'))
        @skins.push(Item.new(self, @win, 2, 1, 'Green',99, @data[7],'skin'))
        @skins.push(Item.new(self, @win, 3, 1, 'Rainbow',99, @data[8],'skin'))
        
        @powers = []
        @powers.push(Item.new(self, @win, 1, 1, 'Health',99, @data[9],'power'))
        @powers.push(Item.new(self, @win, 2, 1, 'Defense',99, @data[10],'power'))
        
        @items = @weapons
        @opening = Opening_Effect.new()
        @closing = Closing_Effect.new()
        @close = false
        @heading = 0
    end

    def setdata
        @data.map.with_index {|data,i|
            case data
            when '0'
                @data[i]='locked'
            when '1'
                @data[i]='unlocked'
            when '2'
                @data[i]='equiped'
            end
        }
    end

    def equipweapon(gun)
        @win.changegun(gun)
    end

    def equipskin(skin)
        @win.changeskin(skin)
    end

    def equippower(power)
        @win.changepower(power)
    end

    def getbtndown(id)
        case id
        when Gosu::MsLeft
            if(@weapon_btn.hover)
                @weapon_btn.hover = false
                @weapon_btn.keep = true
                @skin_btn.keep = false
                @power_btn.keep = false
                @click.play
                @show = 'weapon'
                @scrolled = 0
                @items = @weapons
            end
            if(@skin_btn.hover)
                @skin_btn.hover = false
                @weapon_btn.keep = false
                @skin_btn.keep = true
                @power_btn.keep = false
                @click.play
                @scrolled = 0
                @show = 'skin'
                @items = @skins
            end
            if(@power_btn.hover)
                @power_btn.hover = false
                @weapon_btn.keep = false
                @skin_btn.keep = false
                @power_btn.keep = true
                @click.play
                @scrolled = 0
                @show = 'power'
                @items = @powers
            end
            if(@back_btn.hover)
                @back_btn.hover = false
                @close = true
                @heading = 1
                @click.play
            end
        when Gosu::MsWheelDown 
            if(@scrolled < 1000)
                @scrolled = @scrolled +40
                @scroll = 40
            else
                @scrolled = 1000
            end
        when Gosu::MsWheelUp  
            if(@scrolled > 0)
                @scrolled = @scrolled -40
                @scroll = -40
            else
                @scrolled = 0
            end
        end
        @id = id
        @items.each {|item|
            item.getbtndown(id)
        }
    end

    def unequipothers(theequiped,category)
        @items.each {|item|
            if(item != theequiped && item.getstatus == 'equiped' && item.getcategory == category)
                item.setstatus('unlocked')
                @win.savedata(item.gettype,1)
            end
        }
    end

    def update(mousex,mousey)
        @weapon_btn.update(mousex,mousey)
        @skin_btn.update(mousex,mousey)
        @power_btn.update(mousex,mousey)
        @back_btn.update(mousex,mousey)
        @items.each {|item|
            item.update(mousex,mousey,@scrolled)
        }
        @opening.update
        if(@close)
            @closing.update
            if(@closing.change)
                case @heading
                when 1 
                    if(@win.prevstate == 'start')
                        @win.start = Start.new(@win)
                    else
                        @win.end = End.new(@win)
                    end
                    @win.state = @win.prevstate
                end
            end
        end
    end

    def draw
        @opening.draw
        if(@close)
            @closing.draw
        end
        # draw_quad(90-50,90-50,@color,90+50,90-50,@color,90-50,90+50,@color,90+50,90+50,@color,13)
        draw_quad(80-80,80-100, @gray,80+1920-80,80-100, @gray,80-80,80+100, @gray,80+1920-80,80+100, @gray,12)
        Gosu::Font.new(@win, Gosu::default_font_name, 100).draw_text('<',60,45,15,1.0,1.0,Gosu::Color::WHITE)
        Gosu::Font.new(@win, Gosu::default_font_name, 100).draw_text('Shop',855,0,13,1.0,1.0,Gosu::Color::WHITE)
        Gosu::Font.new(@win, Gosu::default_font_name, 60).draw_text('Coin: '+@win.coin.to_s,417.5-222.5,20,13,1.0,1.0,Gosu::Color::YELLOW)
        @weapon_btn.draw
        @skin_btn.draw
        @power_btn.draw
        @back_btn.draw
        @items.each {|item|
            item.draw
        }
    end


end