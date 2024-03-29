# This example demonstrates use of the TextInput class with three text field widgets.
# One can cycle through them with tab, or click into the text fields and change their contents.

# The way TextInput works is that you create an instance of it, and then assign it to the text_input
# attribute of your window.
# Until you set this attribute to nil again, the TextInput object will then build a string from user
# input that can be accessed via TextInput#text.

# The TextInput object also maintains the position of the caret, which is defined as the index of
# its right neighbour character, i.e. a carent_pos of 0 is always the left-most position, and a
# caret_pos of text.length is always the right-most position.
# There is a second attribute called selection_start that is equal to caret_pos when there is no
# selection, and otherwise defines the selected range. If you set caret_pos to a different value,
# you usually want to set selection_start as well.

# A TextInput object is purely abstract. Drawing the input field is left to the user.
# In this example, we are subclassing TextInput to add this code, but you can also work with
# composition instead of inheritance.

require "gosu"

class TextField < Gosu::TextInput
  FONT = Gosu::Font.new(20)
  WIDTH = 350
  LENGTH_LIMIT = 20
  PADDING = 5

  INACTIVE_COLOR  = 0xcc_666666
  ACTIVE_COLOR    = 0xcc_ff6666
  SELECTION_COLOR = 0xcc_0000ff
  CARET_COLOR     = 0xff_ffffff

  attr_reader :x, :y

  def initialize(window, x, y)
    # It's important to call the inherited constructor.
    super()

    @window, @x, @y = window, x, y

    # Start with a self-explanatory text in each field.
    self.text = "Click to input"
  end

  # In this example, we use the filter method to prevent the user from entering a text that exceeds
  # the length limit. However, you can also use this to blacklist certain characters, etc.
  def filter new_text
    allowed_length = [LENGTH_LIMIT - text.length, 0].max
    new_text[0, allowed_length]
  end

  def draw(z)
    # Change the background colour if this is the currently selected text field.
    if @window.text_input == self
      color = ACTIVE_COLOR
    else
      color = INACTIVE_COLOR
    end
    Gosu.draw_rect x - PADDING, y - PADDING, WIDTH + 2 * PADDING, height + 2 * PADDING, color, z

    # Calculate the position of the caret and the selection start.
    pos_x = x + FONT.text_width(self.text[0...self.caret_pos])
    sel_x = x + FONT.text_width(self.text[0...self.selection_start])
    sel_w = pos_x - sel_x

    # Draw the selection background, if any. (If not, sel_x and pos_x will be
    # the same value, making this a no-op call.)
    Gosu.draw_rect sel_x, y, sel_w, height, SELECTION_COLOR, z

    # Draw the caret if this is the currently selected field.
    if @window.text_input == self
      Gosu.draw_line pos_x, y, CARET_COLOR, pos_x, y + height, CARET_COLOR, z
    end

    # Finally, draw the text itself!
    FONT.draw_text(self.text, x, y, z)
  end

  def height
    FONT.height
  end

  # Hit-test for selecting a text field with the mouse.
  def under_mouse?
    @window.mouse_x > x - PADDING and @window.mouse_x < x + WIDTH + PADDING and
      @window.mouse_y > y - PADDING and @window.mouse_y < y + height + PADDING
  end

  # Tries to move the caret to the position specifies by mouse_x
  def move_caret_to_mouse
    # Test character by character
    1.upto(self.text.length) do |i|
      if @window.mouse_x < x + FONT.text_width(text[0...i])
        self.caret_pos = self.selection_start = i - 1;
        return
      end
    end
    # Default case: user must have clicked the right edge
    self.caret_pos = self.selection_start = self.text.length
  end
end
