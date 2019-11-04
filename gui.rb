require 'gosu'
require "./field.rb"
require "./text.rb"

# def Field.display()
#     p "display"
#     return GameWindow.display(Gosu.rectcalc[0], Gosu.rectcalc[1])
# end

class HomeWindow < Gosu::Window
    def initialize()
        super(640, 480)
        self.caption = "Welcome to Sokoban!"

        text =
        "
         倉庫番（SOKOBAN）へようこそ！


        ～～～ 操作説明 ～～～

        「↑」、「w」、「k」・・・プレーヤーを上へ移動
        「↓」、「s」、「j」・・・プレーヤーを下へ移動
        「←」、「a」、「h」・・・プレーヤーを左へ移動
        「→」、「d」、「l」・・・プレーヤーを右へ移動
        「z」・・・一つ戻る（undo）
        「y」・・・一つ進む（redo）
        「ESC」・・・ゲームを終了

        遊びたいステージファイル名を入力してください。"

        text.gsub! /^ +/, ""

        @text = Gosu::Image.from_text(text, 20, width: 540)
        @text_field = Array.new(1) { |index| TextField.new(self, 55, 365) }
    end

    def needs_cursor?
        true
    end

    def draw
        @text.draw(50, 50, 1)
        @text_field.each { |tf| tf.draw(1) }
    end

    def button_down(input)
        if input == Gosu::KB_TAB
            index = @text_fields.index(self.text_input) || -1
            self.text_input = @text_field[(index + 1) % @text_field.size]
        elsif input == Gosu::KB_ESCAPE
            # Escape key will not be 'eaten' by text fields; use for deselecting.
            if self.text_input
                self.text_input = nil
            else
                close
            end
        elsif input == Gosu::KB_RETURN and self.text_input != nil
            window = GameWindow.new(@text_field[0].text)
            close
        elsif input == Gosu::MS_LEFT
            if (@text_field[0].under_mouse?)
                self.text_input = @text_field.find { |tf| tf.under_mouse? }
                @text_field[0].text = ""
                self.text_input.move_caret_to_mouse unless self.text_input.nil?
            else
                self.text_input = nil
                if (@text_field[0].text == "") then @text_field[0].text = "Click to input" end
            end
        else
            super
        end
    end
end

class GameWindow < Gosu::Window
    #attr :game_field, :game_back

    def initialize(filename, width = 640, height = 480)
        @filename = filename.to_s
        @width = width
        @height = height

        @background = Gosu::Image.new("./media/space.png", {retro: true})

        super(@width, @height)
        self.caption = "Sokoban: #{@filename}"
        @time = 0; @frame = 0

        File.open(@filename) do |file|
            level, custom = file.gets.chomp.split(' ').map(&:to_i)
            buffer = file.read()
            @game_field = Field.new(level, custom)

            buffer.each_line.with_index do |line, index|
                line.gsub!("\#", "0")
                line.gsub!(" ", "1")
                line.gsub!("$", "2")
                line.gsub!(".", "3")
                line.gsub!("@", "4")
                # line.gsub!("?", "5")
                line.gsub!("*", "6")
                @game_field.getStage[index] = line.chomp.split('').map(&:to_i)
            end

            # @game_field.display()
        end
        @game_field.record
        self.show
    end

    def update
        unless self.frozen?
            @frame += 1
            if @frame == 60
                @frame = 0; @time += 1
            end
            self.caption = "Sokoban: #{@filename}, time: #{@time}[s]"
            if !@game_field.search(2) && !@game_field.search(3) then
                moves = @game_field.youwin()
                self.freeze
            end
            @game_field.record_check
        end
    end

    def draw
        @background.draw(0, 0, 0, @width.to_f/640, @height.to_f/480).freeze
        Gosu.draw_rect(*rectcalc.freeze, Gosu::Color.argb(0xff_392100), 1)
        display(rectcalc[0], rectcalc[1])
    end

    def display(x, y)
        @game_field.getHeight.times do |h|
            @game_field.getStage[h].each_with_index do |obj, w|
                if    obj == 0
                    StageObjects::Wall.draw(x + w * 48, y + h * 48, 2, 48.0/16, 48.0/16)
                elsif obj == 1
                    StageObjects::Space.draw(x + w * 48, y + h * 48, 2, 48.0/16, 48.0/16, Gosu::Color::NONE)
                elsif obj == 2
                    StageObjects::Hako.draw(x + w * 48, y + h * 48, 2, 48.0/64, 48.0/64)
                elsif obj == 3
                    StageObjects::Aim.draw(x + w * 48, y + h * 48, 2, 48.0/300, 48.0/300)
                elsif obj == 4
                    StageObjects::Player.draw(x + w * 48, y + h * 48, 2, 48.0/32, 48.0/32)
                elsif obj == 5
                    StageObjects::Aim.draw(x + w * 48, y + h * 48, 2, 48.0/300, 48.0/300)
                    StageObjects::Player.draw(x + w * 48, y + h * 48, 3, 48.0/32, 48.0/32)
                elsif obj == 6
                    StageObjects::Hako.draw(x + w * 48, y + h * 48, 2, 48.0/64, 48.0/64)
                    StageObjects::Aim.draw(x + w * 48, y + h * 48, 3, 48.0/300, 48.0/300, Gosu::Color.argb(0x77_666622))
                end
            end
        end
    end

    def rectcalc
        topleft_x = (@width / 2 - @game_field.getWidth * 24)
        topleft_y = (@height / 2 - @game_field.getHeight * 24)
        return [topleft_x, topleft_y, (@game_field.getWidth*48), (@game_field.getHeight*48)]
    end

    def button_down(input)
        if button_down?(Gosu::KB_UP) or button_down?(Gosu::KB_W) or button_down?(Gosu::KB_K)
            @game_field.move("up")
        elsif button_down?(Gosu::KB_DOWN) or button_down?(Gosu::KB_S) or button_down?(Gosu::KB_J)
            @game_field.move("down")
        elsif button_down?(Gosu::KB_LEFT) or button_down?(Gosu::KB_A) or button_down?(Gosu::KB_H)
            @game_field.move("left")
        elsif button_down?(Gosu::KB_RIGHT) or button_down?(Gosu::KB_D) or button_down?(Gosu::KB_L)
            @game_field.move("right")
        elsif button_down?(Gosu::KB_Z)
            @game_field.undo()
        elsif button_down?(Gosu::KB_Y)
            @game_field.redo()
        elsif button_down?(Gosu::KB_ESCAPE)
            self.close
        else
            super
        end
    end
end
