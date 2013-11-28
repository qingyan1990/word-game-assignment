hash = {}
File.open('new_para.zh').each_line do |line|
  line.strip.split.each do |word|
    if hash.key?(word)
      hash[word] += 1
    else
      hash[word] = 1
    end
  end
end

count = open('para_word_count.csv','a')
count.puts "word,number"
hash.each{|key,value| count.puts "#{key},#{value}"}
count.close
