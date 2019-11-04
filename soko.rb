#!/usr/bin/ruby
require 'gosu'
require "./field.rb"
require "./gui.rb"

# === GUI version ===

if (ARGV[0] != nil)
    if (ARGV[2] != nil)
        window = GameWindow.new(ARGV[0], ARGV[1].to_i, ARGV[2].to_i)
    else
        window = GameWindow.new(ARGV[0])
    end
    #window.close
else
    window = HomeWindow.new.show
end
