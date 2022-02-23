# frozen_string_literal: true

# print 'How old are you?'
# age = gets.chomp
# print 'How tall are you?'
# height = gets.chomp
# puts " You are #{age} years old and your height is #{height} cms"

# print 'Give a number'
# number = gets.chomp.to_i
# puts "The number you entered in binary is #{number}"


def some_kind_of_method
  s = 'temp'
  print 'This is within a method'
  s += s
  hold = 33
  s
end

x = some_kind_of_method

puts x.to_s
