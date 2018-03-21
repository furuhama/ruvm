# ruvm (= Ruby simple Virtual Machine)

class Evaluator
  attr_accessor :stack

  def initialize
    @stack = []
    @pc = 0
  end

  def evaluate(sequence)
    while instructions = sequence[@pc]
      dispatch instructions
    end

    @stack[0]
  end

  def dispatch(instructions)
    # read arguments & put them into @stack
    instructions[1..-1].each do |inst|
      @stack.push inst
    end

    # read & evaluate main instruction
    case instructions.first
    when :nop

    when :add
      push pop + pop

    else
      raise "Unknown Opecode: #{instructions}"
    end

    @pc += 1
  end

  def push(obj)
    @stack.push obj
  end

  def pop
    @stack.pop
  end
end

class Parser
  class << self
    def parse(program)
      read_lines tokenize(program)
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
  end
end
