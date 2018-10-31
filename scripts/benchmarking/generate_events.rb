require_relative 'generator_class'

generator_1 = Generator.new(ARGV[0])

loop { generator_1.generate_event }