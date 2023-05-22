
 
class Gun < Gosu::Window
    def initialize(win, game, type)
        @x = 0
        @y = 0
        @game = game
        @xpointat = 0
        @ypointat = 0
        @ready_to_fire = false
        @firesec = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @color = 0xffffffff
        @type = type
        @saccelerate = 0
        @angle = 0
        @angle_in_deg = 0
        @shock = 0
        @pistollength = 50
        @otherslength = 100
        @sniperlength = 150
        @accuracy = 20*rand(-1.2..1.2)
        case @type 
        when 'enemy'
            @shot_sound = Gosu::Sample.new( './Assets/Songs/singleshot.mp3')
        when 'bigenemy'
            @shot_sound = Gosu::Sample.new( './Assets/Songs/shotgun.mp3')
        when 'pistol'
            @shot_sound = Gosu::Sample.new( './Assets/Songs/singleshot2.mp3')
        when 'shotgun'
            @shot_sound = Gosu::Sample.new( './Assets/Songs/shotgun.mp3')
        when 'sniper'
            @shot_sound = Gosu::Sample.new( './Assets/Songs/sniper.mp3')
        when 'rifle'
            @shot_sound = Gosu::Sample.new( './Assets/Songs/rifle.mp3')
        end
    end

    def fire(initposx, initposy, pointx, pointy)
        if @ready_to_fire == true
            @shock = @shock + 30
            case @type 
            when 'enemy'
                @shot_sound.play(0.1)
                @game.bullet << Bullet.new(@game, @angle_in_deg,initposx, initposy, @type, @pistollength,15,10,15,2500,true)
            when 'bigenemy'
                @shot_sound.play(0.4)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy,'enemy', @otherslength,10,rand(5..10),rand(5..20),1000,true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy,'enemy', @otherslength,10,rand(5..10),rand(5..20),1000,true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy,'enemy', @otherslength,10,rand(5..10),rand(5..20),1000,true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy,'enemy', @otherslength,10,rand(5..10),rand(5..20),1000,true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy,'enemy', @otherslength,10,rand(5..10),rand(5..20),1000,true)
            when 'pistol'
                @shot_sound.play
                @game.bullet << Bullet.new(@game, @angle_in_deg,initposx, initposy, @type, @pistollength,50,50,15,2000,true)
            when 'shotgun'
                @shot_sound.play
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(80..100),rand(5..20),rand(250..300),true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(60..70),rand(5..20),rand(300..400),true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(40..50),rand(5..20),rand(200..600),true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(10..30),rand(5..20),rand(200..600),true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(10..30),rand(5..20),rand(200..600),true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(10..30),rand(5..20),rand(200..1000),true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(20..60),rand(5..20),rand(200..1000),true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(30..90),rand(5..20),rand(300..2000),true)
                @game.bullet << Bullet.new(@game, @angle_in_deg+20*rand(-0.98..0.98),initposx, initposy, @type, @otherslength,rand(30..60),rand(30..90),rand(5..20),rand(300..2000),true)
                
            when 'sniper'
                @shot_sound.play(0.5)
                @game.bullet << Bullet.new(@game, @angle_in_deg,initposx, initposy, @type, @sniperlength,100,rand(95..105),40,3000,true)
            when 'rifle'
                @shot_sound.play(0.1)
                @game.bullet << Bullet.new(@game, @angle_in_deg+2*rand(-0.2..0.2),initposx, initposy, @type, @otherslength,75,rand(10..40),20,2000,true)
            end
            @firesec=Process.clock_gettime(Process::CLOCK_MONOTONIC)
            @ready_to_fire = false
        end
    end

    def update(posx,posy,pointx,pointy)
        if(@type != 'rifle')
            firespeed = 1
        else
            firespeed = 0.15
        end
        if @game.currentsec - @firesec >= firespeed
            @ready_to_fire = true
        end
        @x=posx
        @y=posy
        @xpointat = pointx
        @ypointat = pointy
        aimangle = Math.atan2(@xpointat,@ypointat)
        @angle = aimangle
        @angle_in_deg = @angle*360/(2*Math::PI)
        @shock = @shock * 0.6
        if(@angle*2/(2*Math::PI)>0.5 && @angle*2/(2*Math::PI)<1 || @angle*2/(2*Math::PI)<0 && @angle*2/(2*Math::PI)<-0.5)
            @angle_in_deg = @angle_in_deg + @shock
        end
        if(@angle*2/(2*Math::PI)<=0.5 && @angle*2/(2*Math::PI)>=-0.5)
            @angle_in_deg = @angle_in_deg - @shock
        end
    end

    def draw
        rotate(@angle_in_deg,@x,@y) {
            case @type
            when 'enemy'
                self.Pistol(@x,@y)
            when 'bigenemy'
                self.Shotgun(@x,@y)
            when 'pistol'
                self.Pistol(@x,@y)
            when 'shotgun'
                self.Shotgun(@x,@y)
            when 'sniper'
                self.Sniper(@x,@y)
            when 'rifle'
                self.Rifle(@x,@y)
            end
        }
    end

    def Pistol(x,y)
        if(@angle_in_deg>=-90 && @angle_in_deg<=90 )
            draw_quad(x-5,y-5,@color,x+50,y-5,@color,x-5,y+5,@color,x+50,y+5,@color,8)
            draw_quad(x-5,y-5,@color,x+15,y-5,@color,x-5,y+15,@color,x+15,y+15,@color,8)
        else
            draw_quad(x-5,y+5,@color,x+50,y+5,@color,x-5,y-5,@color,x+50,y-5,@color,8)
            draw_quad(x-5,y+5,@color,x+15,y+5,@color,x-5,y-15,@color,x+15,y-15,@color,8)
        end
    end

    def Shotgun(x,y)
        if(@angle_in_deg>=-90 && @angle_in_deg<=90 )
            draw_quad(x-5,y-10,@color,x+100,y-10,@color,x-5,y+10,@color,x+100,y+10,@color,8)
            draw_quad(x-5,y-10,@color,x+15,y-10,@color,x-5,y+25,@color,x+15,y+25,@color,8)
            draw_quad(x+30,y-10,@color,x+90,y-10,@color,x+30,y+18,@color,x+90,y+18,@color,8)
        else
            draw_quad(x-5,y+10,@color,x+100,y+10,@color,x-5,y-10,@color,x+100,y-10,@color,8)
            draw_quad(x-5,y+10,@color,x+15,y+10,@color,x-5,y-25,@color,x+15,y-25,@color,8)
            draw_quad(x+30,y+10,@color,x+90,y+10,@color,x+30,y-18,@color,x+90,y-18,@color,8)
        end
    end

    def Sniper(x,y)
        if(@angle_in_deg>=-90 && @angle_in_deg<=90 )
            draw_quad(x+5,y-5,@color,x+150,y-5,@color,x+5,y+5,@color,x+150,y+5,@color,8)
            draw_quad(x+5,y,@color,x+35,y,@color,x+5,y+15,@color,x+35,y+15,@color,8)
            draw_quad(x-5,y,@color,x+15,y,@color,x-5,y+35,@color,x+15,y+35,@color,8)
            draw_quad(x+25,y-15,@color,x+70,y-15,@color,x+25,y+10,@color,x+70,y+10,@color,8)
        else
            draw_quad(x+5,y+5,@color,x+150,y+5,@color,x+5,y-5,@color,x+150,y-5,@color,8)
            draw_quad(x+5,y,@color,x+35,y,@color,x+5,y-15,@color,x+35,y-15,@color,8)
            draw_quad(x-5,y,@color,x+15,y,@color,x-5,y-35,@color,x+15,y-35,@color,8)
            draw_quad(x+25,y+15,@color,x+70,y+15,@color,x+25,y-10,@color,x+70,y-10,@color,8)
        end
    end

    def Rifle(x,y)
        if(@angle_in_deg>=-90 && @angle_in_deg<=90 )
            draw_quad(x+5,y-5,@color,x+110,y-5,@color,x+5,y+5,@color,x+110,y+5,@color,8)
            draw_quad(x-5,y-10,@color,x+100,y-10,@color,x-5,y+10,@color,x+100,y+10,@color,8)
            draw_quad(x-5,y-10,@color,x+15,y-10,@color,x-5,y+25,@color,x+15,y+25,@color,8)
            draw_quad(x+30,y-10,@color,x+40,y-10,@color,x+30,y+40,@color,x+40,y+40,@color,8)
        else
            draw_quad(x+5,y+5,@color,x+110,y+5,@color,x+5,y-5,@color,x+110,y-5,@color,8)
            draw_quad(x-5,y+10,@color,x+100,y+10,@color,x-5,y-10,@color,x+100,y-10,@color,8)
            draw_quad(x-5,y+10,@color,x+15,y+10,@color,x-5,y-25,@color,x+15,y-25,@color,8)
            draw_quad(x+30,y+10,@color,x+40,y+10,@color,x+30,y-40,@color,x+40,y-40,@color,8)
        end
    end
end