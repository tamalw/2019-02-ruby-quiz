module LuhneyTunes
  class InvalidCardNumberException < StandardError; end
  class InvalidCardTypeException < StandardError; end

  class Card
    CARD_TYPES = [
      { name: 'AMEX', begins_with: [34, 37], length: [15] },
      { name: 'Discover', begins_with: [6011], length: [16] },
      { name: 'Mastercard', begins_with: (51..55), length: [16] },
      { name: 'Visa', begins_with: [4], length: [13, 16] }
    ]

    attr_reader :number

    def initialize(n)
      @number =  n.to_s.scan(/\d/).join
      validate!
    end

    def self.generate(t)
      i = t.to_i - 1
      raise InvalidCardTypeException unless type = CARD_TYPES[i]
      start = type[:begins_with].sample.to_s
      length = type[:length].sample
      random_length = length - start.length - 1

      number = [start]
      random_length.times do
        number << rand(0..9).to_s
      end
      number << 0
      last_digit = 10 - (luhn_sum(number.join) % 10)
      number.pop
      number << last_digit
      self.new(number.join)
    end

    def validate!
      validate_card_type!
      validate_checksum!
    end

    def to_s
      number
    end

    private

    def self.luhn_sum(n)
      n_to_check = n.chars
      doubled_n = n_to_check.reverse.map.with_index do |n,i|
        unless i % 2 == 0
          (n.to_i * 2).to_s
        else
          n
        end
      end
      doubled_n.join.chars.map(&:to_i).sum
    end

    def detect_card_type
      CARD_TYPES.each do |t|
        l = t[:begins_with].first.to_s.size
        n_begin = number[0...l].to_i
        return t if t[:begins_with].include?(n_begin) && t[:length].include?(number.length)
      end
      nil
    end

    def validate_card_type!
      raise InvalidCardNumberException unless detect_card_type
    end

    def validate_checksum!
      raise InvalidCardNumberException unless self.class.luhn_sum(number) % 10 == 0
    end
  end
end