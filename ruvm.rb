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
    # read & evaluate main instruction
    case instructions.first
    when :nop

    # read arguments & put them into @stack
    when :push
      push instructions[1]

    when :pop
      pop

    when :dup
      popped = pop
      push popped
      push popped

    when :add
      push pop + pop

    when :sub
      push pop - pop # this means [after-pushed] - [before-pushed]

    when :mul
      push pop * pop

    when :div
      push pop / pop # this means [after-pushed] / [before-pushed] (returns integer)

    # boolean
    when :not
      push !pop

    when :smaller
      push pop < pop # this means [after-pushed] < [before-pushed]

    when :bigger
      push pop > pop # this means [after-pushed] > [before-pushed]

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
