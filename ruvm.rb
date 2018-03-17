# ruvm (= Ruby simple Virtual Machine)

def parse(program)
  tokenize(program).map(&:convert)
end

def tokenize(string)
  string.split("\n").map(&:strip)
end

def read_lines(str_array)
  str_array.map(&:split).map { |line| line.map { |token| convert token } }
end

def convert(token)
  type_casts = [
    lambda { |arg| Integer arg },
    lambda { |arg| Float(arg).to_i }, # convert Float argument to Integer
    lambda { |arg| arg.to_sym },
  ]

  begin
    type_casts.first.call(token)
  rescue ArgumentError
    # remove first element of type_casts
    # and retry this method
    type_casts.shift
    retry
  end
end
