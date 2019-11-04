require 'gosu'

module StageObjects
    Wall = Gosu::Image.load_tiles("./media/kabe-ue_dungeon1.png", 16, 16, tileable: true)[0]
    Space = Gosu::Image.load_tiles("./media/kabe-ue_dungeon1.png", 16, 16, tileable: true)[4]
    Hako = Gosu::Image.new("./media/hako.bmp")
    Aim = Gosu::Image.new("./media/large_star.png")
    Player = Gosu::Image.load_tiles("./media/pipo-charachip001.png", 32, 32, tileable: true)[0]
    #Piled = Gosu::Image.load_tiles("./media/pipo-charachip001.png", 32, 32, tileable: true)[0]
    #Fitted = Gosu::Image.new("./media/hako.bmp")
end

class Field
    @@records = []; @@operates = []

    def initialize(level, custom = false)
        if !custom
            if level == 1 then @height = @width = 7 end    # level:easy => make 5 * 5
            if level == 2 then @height = @width = 12 end    # level:normal => make 10 * 10
            if level == 3 then @height = @width = 22 end    # level:hard => make 20 * 20
        else    # custom != false(some number) => make level * custom
            @height = level; @width = custom
        end
        @stage = Array.new(@height) do Array.new(@width, 0) end
    end

    def wall
        @height.times do |h|
            @stage[h][0] = 0; @stage[h][-1] = 0
        end
        @width.times do |w|
            @stage[0][w] = 0; @stage[-1][w] = 0
        end
        p @stage
        return
    end

    def getStage
        return @stage
    end

    def setStage=(stage)
        @stage = stage
    end

    def getWidth
        return @width
    end

    def getHeight
        return @height
    end

    def search(key)
        @stage.each { |arr|
            if arr.include?(key) then return true end
        }
        return false
    end

    def display
        @height.times do |h|
            @stage[h].each do |w|
                if    w == 0 then printf("■")
                elsif w == 1 then printf("　")
                elsif w == 2 then printf("・")
                elsif w == 3 then printf("○")
                elsif w == 4 then printf("Ｐ")
                elsif w == 5 then print("Ⓟ")
                elsif w == 6 then print("◎")
                end
            end
            printf("\n")
        end
        #p @@records
        #p @@operates
    end

    def playerposis
        h = 0; w = 0

        @stage.each_with_index { |arr, index|
            h = index
            w = arr.index(4)
            if !w then w = arr.index(5) end
            if w then break end
        }
        return "#{h}" + ' ' + "#{w}"
    end

    def move(key)
        h, w = playerposis().split(' ').map(&:to_i)

        case key
        when "up"
            if @stage[h][w] == 4
                case @stage[h-1][w]
                when 1
                    @stage[h][w] = 1
                    @stage[h-1][w] = 4
                when 2
                    if @stage[h-2][w] == 1
                        @stage[h][w] = 1
                        @stage[h-1][w] = 4
                        @stage[h-2][w] = 2
                    elsif @stage[h-2][w] == 3
                        @stage[h][w] = 1
                        @stage[h-1][w] = 4
                        @stage[h-2][w] = 6
                    end
                when 3
                    @stage[h][w] = 1
                    @stage[h-1][w] = 5
                when 6
                    if @stage[h-2][w] == 1
                        @stage[h][w] = 1
                        @stage[h-1][w] = 5
                        @stage[h-2][w] = 2
                    elsif @stage[h-2][w] == 3
                        @stage[h][w] = 1
                        @stage[h-1][w] = 5
                        @stage[h-2][w] = 6
                    end
                end

            else   # @stage[h][w] == 5
                case @stage[h-1][w]
                when 1
                    @stage[h][w] = 3
                    @stage[h-1][w] = 4
                when 2
                    if @stage[h-2][w] == 1
                        @stage[h][w] = 3
                        @stage[h-1][w] = 4
                        @stage[h-2][w] = 2
                    elsif @stage[h-2][w] == 3
                        @stage[h][w] = 3
                        @stage[h-1][w] = 4
                        @stage[h-2][w] = 6
                    end
                when 3
                    @stage[h][w] = 3
                    @stage[h-1][w] = 5
                when 6
                    if @stage[h-2][w] == 1
                        @stage[h][w] = 3
                        @stage[h-1][w] = 5
                        @stage[h-2][w] = 2
                    elsif @stage[h-2][w] == 3
                        @stage[h][w] = 3
                        @stage[h-1][w] = 5
                        @stage[h-2][w] = 6
                    end
                end
            end

        when "down"
            if @stage[h][w] == 4
                case @stage[h+1][w]
                when 1
                    @stage[h][w] = 1
                    @stage[h+1][w] = 4
                when 2
                    if @stage[h+2][w] == 1
                        @stage[h][w] = 1
                        @stage[h+1][w] = 4
                        @stage[h+2][w] = 2
                    elsif @stage[h+2][w] == 3
                        @stage[h][w] = 1
                        @stage[h+1][w] = 4
                        @stage[h+2][w] = 6
                    end
                when 3
                    @stage[h][w] = 1
                    @stage[h+1][w] = 5
                when 6
                    if @stage[h+2][w] == 1
                        @stage[h][w] = 1
                        @stage[h+1][w] = 5
                        @stage[h+2][w] = 2
                    elsif @stage[h+2][w] == 3
                        @stage[h][w] = 1
                        @stage[h+1][w] = 5
                        @stage[h+2][w] = 6
                    end
                end

            else   # @stage[h][w] == 5
                case @stage[h+1][w]
                when 1
                    @stage[h][w] = 3
                    @stage[h+1][w] = 4
                when 2
                    if @stage[h+2][w] == 1
                        @stage[h][w] = 3
                        @stage[h+1][w] = 4
                        @stage[h+2][w] = 2
                    elsif @stage[h+2][w] == 3
                        @stage[h][w] = 3
                        @stage[h+1][w] = 4
                        @stage[h+2][w] = 6
                    end
                when 3
                    @stage[h][w] = 3
                    @stage[h+1][w] = 5
                when 6
                    if @stage[h+2][w] == 1
                        @stage[h][w] = 3
                        @stage[h+1][w] = 5
                        @stage[h+2][w] = 2
                    elsif @stage[h+2][w] == 3
                        @stage[h][w] = 3
                        @stage[h+1][w] = 5
                        @stage[h+2][w] = 6
                    end
                end
            end

        when "right"
            if @stage[h][w] == 4
                case @stage[h][w+1]
                when 1
                    @stage[h][w] = 1
                    @stage[h][w+1] = 4
                when 2
                    if @stage[h][w+2] == 1
                        @stage[h][w] = 1
                        @stage[h][w+1] = 4
                        @stage[h][w+2] = 2
                    elsif @stage[h][w+2] == 3
                        @stage[h][w] = 1
                        @stage[h][w+1] = 4
                        @stage[h][w+2] = 6
                    end
                when 3
                    @stage[h][w] = 1
                    @stage[h][w+1] = 5
                when 6
                    if @stage[h][w+2] == 1
                        @stage[h][w] = 1
                        @stage[h][w+1] = 5
                        @stage[h][w+2] = 2
                    elsif @stage[h][w+2] == 3
                        @stage[h][w] = 1
                        @stage[h][w+1] = 5
                        @stage[h][w+2] = 6
                    end
                end

            else   # @stage[h][w] == 5
                case @stage[h][w+1]
                when 1
                    @stage[h][w] = 3
                    @stage[h][w+1] = 4
                when 2
                    if @stage[h][w+2] == 1
                        @stage[h][w] = 3
                        @stage[h][w+1] = 4
                        @stage[h][w+2] = 2
                    elsif @stage[h][w+2] == 3
                        @stage[h][w] = 3
                        @stage[h][w+1] = 4
                        @stage[h][w+2] = 6
                    end
                when 3
                    @stage[h][w] = 3
                    @stage[h][w+1] = 5
                when 6
                    if @stage[h][w+2] == 1
                        @stage[h][w] = 3
                        @stage[h][w+1] = 5
                        @stage[h][w+2] = 2
                    elsif @stage[h][w+2] == 3
                        @stage[h][w] = 3
                        @stage[h][w+1] = 5
                        @stage[h][w+2] = 6
                    end
                end
            end

        when "left"
            if @stage[h][w] == 4
                case @stage[h][w-1]
                when 1
                    @stage[h][w] = 1
                    @stage[h][w-1] = 4
                when 2
                    if @stage[h][w-2] == 1
                        @stage[h][w] = 1
                        @stage[h][w-1] = 4
                        @stage[h][w-2] = 2
                    elsif @stage[h][w-2] == 3
                        @stage[h][w] = 1
                        @stage[h][w-1] = 4
                        @stage[h][w-2] = 6
                    end
                when 3
                    @stage[h][w] = 1
                    @stage[h][w-1] = 5
                when 6
                    if @stage[h][w-2] == 1
                        @stage[h][w] = 1
                        @stage[h][w-1] = 5
                        @stage[h][w-2] = 2
                    elsif @stage[h][w-2] == 3
                        @stage[h][w] = 1
                        @stage[h][w-1] = 5
                        @stage[h][w-2] = 6
                    end
                end

            else   # @stage[h][w] == 5
                case @stage[h][w-1]
                when 1
                    @stage[h][w] = 3
                    @stage[h][w-1] = 4
                when 2
                    if @stage[h][w-2] == 1
                        @stage[h][w] = 3
                        @stage[h][w-1] = 4
                        @stage[h][w-2] = 2
                    elsif @stage[h][w-2] == 3
                        @stage[h][w] = 3
                        @stage[h][w-1] = 4
                        @stage[h][w-2] = 6
                    end
                when 3
                    @stage[h][w] = 3
                    @stage[h][w-1] = 5
                when 6
                    if @stage[h][w-2] == 1
                        @stage[h][w] = 3
                        @stage[h][w-1] = 5
                        @stage[h][w-2] = 2
                    elsif @stage[h][w-2] == 3
                        @stage[h][w] = 3
                        @stage[h][w-1] = 5
                        @stage[h][w-2] = 6
                    end
                end
            end
        end

        self.record
        # self.display
    end

    def undo
        if @@records.length == 1
            return
        end

        @@operates << @@records.pop
        self.setStage = @@records[-1]
        @@records[-1] = Marshal.load(Marshal.dump(self.getStage))
        # self.display
    end

    def redo
        if @@operates.length == 0
            return
        end

        @@records << @@operates.pop
        self.setStage = @@records[-1]
        @@records[-1] = Marshal.load(Marshal.dump(self.getStage))
        # self.display
    end

    def youwin
        print "Clear!! (moves: #{@@records.length - 1})\n"
        return @@records.length - 1
    end

    def record
        array = Marshal.load(Marshal.dump(self.getStage))
        @@records << array
        @@operates = []
    end

    def record_check
        if @@records[-1] == @@records[-2] then @@records.delete_at(-1) end
    end
end
