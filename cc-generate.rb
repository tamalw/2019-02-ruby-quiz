require_relative 'lib/luhney_toons'
include LuhneyTunes

card_type = ARGV.first

puts Card.generate(card_type)
