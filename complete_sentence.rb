require 'active_record'
require 'set'

ActiveRecord::Base.establish_connection adapter: "mysql2",
                                        database: "NLP",
                                        username: "root",
                                        password: "123456",
                                        host: "localhost"

class Wordafter < ActiveRecord::Base
end

class Wordbefore < ActiveRecord::Base
end

class Word < ActiveRecord::Base
end

def split_setence(setence)
  list = []
  while !setence.empty?
    array=[]
    for i in (0..setence.size-1)
      array << setence[0..i]
    end
    max = File.open("ce.txt").select{|x| array.include?(x.split(",")[0])}.map{ |x| x.split(",")[0] }.max{|a,b| a.length <=> b.length}
    list << max
    setence = setence[max.size..-1]
  end
  list
end

puts "please input the setence"
setence = gets.chomp
result = []
index_array = (0..setence.size-1).select{ |i| setence[i] == '_' }
index_array.each do |x|
  candidate = ""
  after_setence = ""
  before_setence = ""
  before_setence = setence[0..x-1].delete('_') if x > 0
  after_setence = setence[x+1..-1].delete('_') if x < setence.size - 1
  before_word = split_setence(before_setence).last unless before_setence.empty?
  after_word = split_setence(after_setence).first unless after_setence.empty?
  #before_word_count = Word.where(word: before_word).pluck(:number).first.to_f
  #after_word_count = Word.where(word: after_word).pluck(:number).first.to_f
  after_array = Wordafter.where(word: before_word).pluck(:after,:number).sort_by{|x| x[1]}.reverse
  before_array = Wordbefore.where(word: after_word).pluck(:before_word,:number).sort_by{|x| x[1]}.reverse
  if !after_array.empty? and !before_array.empty?
    max = 0
    after_array.each do |word|
      select_array = before_array.select{|x| x[0] == word[0]}
      if select_array.size > 0
        #count = (select_array.first[1].to_f / after_word_count) + (word[1].to_f / before_word_count)
        count = select_array.first[1].to_i + word[1].to_i
        result << [word[0],count]
        if max < count
          max = count
          candidate = word[0]
        end
      else
        next
      end
    end
  end
  if candidate.empty?
    if !after_array.empty?
      candidate = after_array.first[0]
    else
      candidate = before_array.first[0]
    end
  end
  #result << after_array.first
  #result << before_array.first
  setence[x] = candidate
end
puts "the answer is"
puts setence
puts "the best 3 answer may be"
result.to_set.sort_by{|x|x[1]}.reverse.first(3).each{|x| puts x[0]}

