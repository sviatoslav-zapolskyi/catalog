
def isbn13_to_isbn10(isnb13)
  isbn10 = isnb13.delete('-').split('')[3..11]
  isbn10.append(check_digit(isbn10)).join
end

def check_digit(isbn10)
  factor = 10
  check_digit = 11 - isbn10.each_with_index.map { |val, index| val.to_i * (factor - index) }.reduce(:+) % 11

  case check_digit
    when 10
      'X'
    when 11
      '0'
    else
      check_digit.to_s
  end
end
