ans = open("new_para.zh","a")
File.open('para.zh').each_line do |x|
  #y = x.gsub(/[，！；()？。,\/：—、a-z”“（）《》\[\]A-Z0-9\-]/," ").gsub(/\s+/," ")
  y = x.gsub(/[，！；()？。,\/：.—、a-z”“（）」「『』…?\／《》\[\]\-]/," ").gsub(/\s+/," ")
  #y = x.gsub(/[!#"$%&\'()*+,-.\/:;<=>?@\[\\\]^_`{\|}~]/," ").gsub(/\s+/," ")
  next if y.strip.empty?
  ans.puts y.strip
end
ans.close
