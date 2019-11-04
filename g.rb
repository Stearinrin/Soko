#!/usr/bin/ruby
require 'io/console'
require 'io/console/size'

# === CUI version ===

class Field
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

    def wall()
        @height.times do |h|
            @stage[h][0] = 0; @stage[h][-1] = 0
        end
        @width.times do |w|
            @stage[0][w] = 0; @stage[-1][w] = 0
        end
        p @stage
        return
    end

    def getStage()
        return @stage
    end

    def setStage=(stage)
        @stage = stage
    end

    def search(key)
        @stage.each { |arr|
            if arr.include?(key) then return true end
        }
        return false
    end

    def display()
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
    end

    def playerposis()
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
        when "A"
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

        when "B"
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

        when "C"
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

        when "D"
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
    end
end

def keyinput(key = STDIN.getch)
    # Omit ESC charecters
    if key == "\e" && STDIN.getch == "["
        key = STDIN.getch
    end

    # Detect a direction
    direction = case key
    when "A", "k", "w", "\u0010"; "A" #↑
    when "B", "j", "s", "\u000E"; "B" #↓
    when "C", "l", "d", "\u0006"; "C" #→
    when "D", "h", "a", "\u0002"; "D" #←
    when "z", "\u001A"; "undo"
    when "y", "\u0019"; "redo"
    when "\u001B", "\u0003"; "terminate"
    else nil
    end

    # move
    return "#{direction}" if direction
end

# Clear display
print "\e[2J"

# title(ASCII ART)
print "\n   ▄████████  ▄██████▄     ▄█   ▄█▄  ▄██████▄  ▀█████████▄     ▄████████ ███▄▄▄▄
  ███    ███ ███    ███   ███ ▄███▀ ███    ███   ███    ███   ███    ███ ███▀▀▀██▄
  ███    █▀  ███    ███   ███▐██▀   ███    ███   ███    ███   ███    ███ ███   ███
  ███        ███    ███  ▄█████▀    ███    ███  ▄███▄▄▄██▀    ███    ███ ███   ███
▀███████████ ███    ███ ▀▀█████▄    ███    ███ ▀▀███▀▀▀██▄  ▀███████████ ███   ███
         ███ ███    ███   ███▐██▄   ███    ███   ███    ██▄   ███    ███ ███   ███
   ▄█    ███ ███    ███   ███ ▀███▄ ███    ███   ███    ███   ███    ███ ███   ███
 ▄████████▀   ▀██████▀    ███   ▀█▀  ▀██████▀  ▄█████████▀    ███    █▀   ▀█   █▀ \n\n\n"

print "～～～ 操作説明 ～～～

「↑」、「w」、「k」、「C^p」・・・プレーヤーを上へ移動
「↓」、「s」、「j」、「C^n」・・・プレーヤーを下へ移動
「←」、「a」、「h」、「C^b」・・・プレーヤーを左へ移動
「→」、「d」、「l」、「C^f」・・・プレーヤーを右へ移動
「z」、「C^z」・・・一つ戻る（undo）
「y」、「C^y」・・・一つ進む（redo）
「ESC」、「C^c」・・・ゲームを終了

～～～ アイコン説明 ～～～
「Ｐ」・・・プレーヤー
「■」・・・壁
「・」・・・荷物
「○」・・・格納点

～～～ 遊び方 ～～～
・倉庫番（Sokoban）は、プレーヤーを操作して、倉庫の中の荷物を指示された格納点まで運ぶパズルです。
・プレーヤーは1個の荷物を押して動かすことができます。2個以上の荷物を押して動かすことはできません。また、荷物を引いて動かすこともできません。
・すべての荷物を格納点まで運ぶことができればゲームクリアです。このときの手数は少ないほど良いです。
\n
"

# Input(file name)
print "遊びたいステージファイル名を入力してください(拡張子「\".txt\"」は必要ありません)。 > "
file_name = gets.chomp

custom_stage = nil; records = []

# Open a file
File.open("./#{file_name}.txt") do |file|
    level, custom = file.gets.chomp.split(' ').map(&:to_i)
    buffer = file.read()
    custom_stage = Field.new(level, custom)
    # p custom_stage

    buffer.each_line.with_index do |line, index|
        line.gsub!("\#", "0")
        line.gsub!(" ", "1")
        line.gsub!("$", "2")
        line.gsub!(".", "3")
        line.gsub!("@", "4")
        # line.gsub!("?", "5")
        line.gsub!("*", "6")
        custom_stage.getStage[index] = line.chomp.split('').map(&:to_i)
    end
    print "\e[2J"
    custom_stage.display()
    array = Marshal.load(Marshal.dump(custom_stage.getStage()))
    records << array
end

operates = []

# main
while(true)
    # Judge
    if !custom_stage.search(2) && !custom_stage.search(3) then
        print "Clear!! (moves: #{records.length - 1})\n"
        break
    end

    # Key input
    input = keyinput()

    # Moves, Operates
    case input
    when "A"
        custom_stage.move("A")
        array = Marshal.load(Marshal.dump(custom_stage.getStage()))
        records << array; operates = []
        print "\e[2J"
        custom_stage.display()

    when "B"
        custom_stage.move("B")
        array = Marshal.load(Marshal.dump(custom_stage.getStage()))
        records << array; operates = []
        print "\e[2J"
        custom_stage.display()

    when "C"
        custom_stage.move("C")
        array = Marshal.load(Marshal.dump(custom_stage.getStage()))
        records << array; operates = []
        print "\e[2J"
        custom_stage.display()

    when "D"
        custom_stage.move("D")
        array = Marshal.load(Marshal.dump(custom_stage.getStage()))
        records << array; operates = []
        print "\e[2J"
        custom_stage.display()

    when "undo"
        if records.length == 1
            #custom_stage.setStage = records[0]
            #custom_stage.display()
            next
        end
        print "\e[2J"
        operates << records.pop
        custom_stage.setStage = records[-1]
        records[-1] = Marshal.load(Marshal.dump(custom_stage.getStage()))
        custom_stage.display()
        print "\nundid!\n"

    when "redo"
        if operates.length == 0
            #custom_stage.setStage = records[-1]
            #custom_stage.display()
            next
        end
        print "\e[2J"
        records << operates.pop
        custom_stage.setStage = records[-1]
        records[-1] = Marshal.load(Marshal.dump(custom_stage.getStage()))
        custom_stage.display()
        print "\nredid!\n"

    when "terminate"
        break
    end

    if records[-1] == records[-2] then records.delete_at(-1) end

    #p "operates: #{operates}"
    #p "records : #{records}"
end
