require_relative 'generator_class'

generator_1 = Generator.new(ARGV[0])

1_000_000.times { generator_1.generate_event }