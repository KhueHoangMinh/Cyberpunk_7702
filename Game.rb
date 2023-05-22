require 'gosu'
require './Bullet.rb'
require './Gun.rb'
require './Player.rb'
require './Enemy.rb'
require './Ground.rb'

class Game <Gosu::Window
    attr_accessor :ground, :bullet, :traces, :explosions, :currentsec, :player, :pause
    
    def initialize(win,gun,skin,power)
        @win = win
        @gun = gun
        @enemys  = Array.new()
        @bullet = Array.new()
        @traces = Array.new()
        @explosions = Array.new()
        @clearsec = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @rest = true
        @win.score = 0
        @red = 0x33_ff0000
        @green = 0xff_00cc00
        @pausebtncolor = 0xff_ff0000
        @btnx = 960.0
        @resumey = 440.0
        @quity = 740.0
        @ground = Array.new()
        @resume_btn = Button.new(@win,'Resume',@btnx,@resumey,200,100,0xff990000)
        @quit_btn = Button.new(@win,'Quit',@btnx,@quity,200,100,0xff990000)
        
        #base grounds
        @ground.push(Ground.new(self,-880,500,1000,1000,0xff_b0b0b0)) #left wall
        @ground.push(Ground.new(self,2520,500,1000,1000,0xff_b0b0b0)) #right wall
        @ground.push(Ground.new(self,920,1000,200,5000,0xff_b0b0b0)) #base ground
        #small levitating grounds
        @ground.push(Ground.new(self,300,780,30,300,0xff_b0b0b0))
        @ground.push(Ground.new(self,700,620,30,300,0xff_b0b0b0))
        @ground.push(Ground.new(self,1200,450,30,300,0xff_b0b0b0))
        @ground.push(Ground.new(self,1500,680,30,300,0xff_b0b0b0))
        
        @player = Player.new(self,gun,skin,power)
        @hit = Gosu::Sample.new('./Assets/Songs/hit.mp3')
        @pause = false
        @id = 0
        @click = Gosu::Sample.new('./Assets/Songs/click.mp3')
        @currentsec = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @opening = Opening_Effect.new()
        @closing = Closing_Effect.new()
        @close = false
        @heading = 0
    end

    def getbtndown(id)
        if(@pause)
            if(id == 256 && @resume_btn.hover)
                @click.play
                @pause = false
            end
            if(id == 256 && @quit_btn.hover)
                @close = true
                @heading = 1
                @click.play
            end
        end
        @id = id
    end
    
    def update(mousex,mousey)
        if(1880-30 <= mousex && 1880+30 >= mousex && 40+30 >= mousey && 40-30 <= mousey && @pause == false)
            @pausebtncolor = @green
            
            if @id == 256
                @pause = true
                @click.play
                @id = 0
            end
        else
            @id = 0
            @pausebtncolor = Gosu::Color.argb(0xff_ff0000)
        end

        if(@pause == false && !@close)
            @currentsec = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            @player.move(mousex,mousey)
            @bullet.each {|bullet|
                bullet.update(@player.camx)
                if bullet.checkout 
                    @bullet.delete(bullet)
                end
                if bullet.checkcollide(@player.top,@player.bottom,@player.right,@player.left, @gun)
                    @hit.play(0.2)
                    @bullet.delete(bullet)
                    @player.takedmg(bullet.damage)
                    if(@player.isdead)
                        @close = true
                        @heading = 1
                    end
                end
            }
            @ground.each {|ground|
                ground.update(@player.camx)
                @bullet.each {|bullet|
                    if bullet.checkcollide(ground.top,ground.bottom,ground.right,ground.left, 'ground')
                        @hit.play(0.2)
                        @bullet.delete(bullet)
                    end
                }
            }
            if(@enemys.length()>0)
                @rest = true
                @enemys.each {|enemy| 
                    enemy.move(@player.x, @player.y, @player.camx)
                    @bullet.each {|bullet|
                    if bullet.checkcollide(enemy.top,enemy.bottom,enemy.right,enemy.left, 'enemy')
                        @hit.play
                        if(@gun != 'sniper')
                            @bullet.delete(bullet)
                        end
                        enemy.takedmg(bullet.damage,bullet.bulletx,bullet.bullety)
                        if(enemy.isdead)
                            @enemys.delete(enemy)
                            @win.score = @win.score + 1
                            @win.coin = @win.coin + 1
                        end
                    end
                    }
                }
            else
                if(@rest)
                    @clearsec = @currentsec
                    @rest =false
                end
                if(@currentsec - @clearsec >= 1)
                    enemynum = rand 6
                    while enemynum >= 0
                        if enemynum%3==0
                            type = 'flying'
                        elsif enemynum%3==1
                            type = 'walking'
                        else
                            type = 'big'
                        end
                        @enemys.push(Enemy.new(self, type))
                        enemynum = enemynum - 1
                    end
                end
            end
            @traces.each {|trace|
                trace.update
            }
            @explosions.each {|explosion|
                explosion.update
            }
        else
            @resume_btn.update(mousex,mousey)
            @quit_btn.update(mousex,mousey)
        end
        @opening.update
        if(@close)
            @closing.update
            if(@closing.change)
                case @heading
                when 1
                    @pause = false
                    @win.savedata('best', @win.best)
                    @win.savedata('coin', @win.coin)
                    @win.end = End.new(@win)
                    @win.state = 'end'
                end
            end
        end
    end



    
    def draw
        @opening.draw
        if(@close)
            @closing.draw
        end
        Gosu::Font.new(@win, Gosu::default_font_name, 100).draw_text("Score: " +@win.score.to_s,960-Gosu::Font.new(@win, Gosu::default_font_name, 100).text_width("Score: " +@win.score.to_s)/2,0,5,1.0,1.0, Gosu::Color::WHITE)
        draw_quad(1880-30,40-30,@pausebtncolor,1880+30,40-30,@pausebtncolor,1880-30,40+30,@pausebtncolor,1880+30,40+30,@pausebtncolor,15)
        Gosu::Font.new(@win, Gosu::default_font_name, 100).draw_text("||",1852,12,17,1.2,0.5, Gosu::Color::WHITE)
        Gosu::Font.new(@win, Gosu.default_font_name, 40).draw_text("Coin: " +@win.coin.to_s,30,30,5,1.0,1.0, Gosu::Color::YELLOW)
        @player.draw
        @ground.each {|ground|
            ground.drawground
        }
        @enemys.each {|enemy| 
            enemy.draw
        }
        @bullet.each {|bullet|
            bullet.draw
        }
        @traces.each {|trace|
            trace.draw
        }
        @explosions.each {|explosion|
            explosion.draw
        }
        if(@pause == true)
            Gosu::Font.new(@win, Gosu::default_font_name, 100).draw_text("Paused",@btnx-Gosu::Font.new(@win, Gosu::default_font_name, 100).text_width('Paused')/2,200,10,1,1,Gosu::Color::WHITE)
            draw_quad(960-1000,540-1000,0x33_555555,960+1000,540-1000,0x33_555555,960-1000,540+1000,0x33_555555,960+1000,540+1000,0x33_555555,8)
            draw_quad(960-400,540-400,0xff_555555,960+400,540-400,0xff_555555,960-400,540+400,0xff_555555,960+400,540+400,0xff_555555,9)
            @resume_btn.draw
            @quit_btn.draw
        end
    end
end