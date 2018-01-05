require 'kanji_money_formatter/version'

module KanjiMoneyFormatter
  @@kanji_rank = %W[#{} 万 億 兆 京 垓 秭 穰 溝 澗 正]

  def self.to_kanji(number)
    cs_value = get_cs_value(number)
    cs_value.zip(@@kanji_rank.slice(0, cs_value.size)).reverse.join
  end

  def self.to_all_kanji(number)
    cs_value = get_cs_value(number)
    cs_value.map!{|i| num_to_k(i.to_i)}
    cs_value.zip(@@kanji_rank.slice(0, cs_value.size)).reverse.join
  end

  def get_cs_value(number)
    cs_value = to_comma_separated_value(number)
    cs_value.split(',').reverse
  end

  def to_comma_separated_value(number, digits = 4)
    div_value = 10**digits
    rem_value = number % div_value
    return number if rem_value == number

    ret_value = to_comma_separated_value(number / div_value, digits)
    "#{ret_value},#{rem_value}"
  end

  def num_to_k(n)
    number = 0..9
    kanji = ["","一","二","三","四","五","六","七","八","九"]
    num_kanji = Hash[number.zip(kanji)]
    digit = [1000,100,10]
    # digit = (1..3).map{ |i| 10 ** i }.reverse
    kanji_keta = ["千","百","十"]
    num_kanji_keta = Hash[digit.zip(kanji_keta)]
    num = n
    str = ""
    digit.each { |d|
      tmp = num / d
      str << (tmp == 0 ? "" : ((tmp == 1 ? "" : num_kanji[tmp]) + num_kanji_keta[d]))
      num %= d
    }
    str << num_kanji[num]
    return str
  end

  module_function :to_comma_separated_value
  module_function :get_cs_value
  module_function :num_to_k
end