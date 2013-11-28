after = open('word_after_count.csv','a')
before = open('word_before_count.csv','a')
after.puts "word,after_word,number"
before.puts "word,before_word,number"
hash = {}
File.open('new_para.zh').each_line do |line|
  words_array = line.split
  for i in (0..words_array.size-1)
    if i > 0
      before_word = words_array[i-1]
      key = before_word + '_' + words_array[i]
      if hash.key?(key)
        hash[key] += 1
      else
        hash[key] = 1
      end
    end
    if i < words_array.size - 1
      after_word = words_array[i+1]
      key = words_array[i] + '_' + after_word
      if hash.key?(key)
        hash[key] += 1
      else
        hash[key] = 1
      end
    end
  end
end

hash.each do |key,value|
  array = key.split('_')
  after.puts "#{array.first},#{array.last},#{value / 2}"
  before.puts "#{array.last},#{array.first},#{value / 2}"
end
after.close
before.close
