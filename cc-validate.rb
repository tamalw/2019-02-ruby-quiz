require_relative 'lib/luhney_toons'
include LuhneyTunes

card_number = ARGV.join

begin
  Card.new(card_number)
rescue InvalidCardNumberException => e
  puts "Invalid"
else
  puts "Valid"
end

