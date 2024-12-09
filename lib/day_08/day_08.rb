module AdventOfCode2024
  module Day08
    class Puzzle
      attr_accessor :input

      def initialize(input)
        @input = input
      end
      
      def self.parse_input(input_string)
        lines = input_string.split("\n")
        width = lines.size
        input = {}

        width.times do |y|
          width.times do |x|
            input[Complex(x,y)] = lines[y][x]
          end
        end

        input
      end

      def display
        width = @input.keys.max_by { |c| c.real }.real
        height = @input.keys.max_by { |c| c.imag }.imag
        (0..height).each do |y|
          (0..width).each do |x|
            print input[Complex(x,y)]
          end
          puts
        end
      end

      def part_one
        freqs = @input.values.filter { |v| v != '.' }.uniq
        antennas = {}
        freqs.each { |f| antennas[f] = @input.filter { |k,v| v == f }.keys }
        antennas.each do |freq, coords|
          coords.permutation(2) do |p|
            a, b = p
            a_b = a - b
            b_a = b - a
            anti_one = Complex(a.real + a_b.real, a.imag + a_b.imag)
            anti_two = Complex(b.real + b_a.real, b.imag + b_a.imag)
            [anti_one, anti_two].each do |anti|
              @input[anti] = '#' if @input.keys.include? anti
            end
          end
        end

        @input.count { |k,v| v.include? '#' }
      end
      
      def part_two
        @input = Puzzle.parse_input(File.read(File.join(__dir__, 'input.txt')))
        hashes = @input.filter { |k,v| v == '#' }.keys
        hashes.each { |k| @input[k] = '.' }
        freqs = @input.values.filter { |v| !['.', '#'].include? v }.uniq
        antennas = {}
        freqs.each { |f| antennas[f] = @input.filter { |k,v| v == f }.keys }
        antennas.each do |freq, coords|
          coords.permutation(2) do |p|
            a, b = p
            a_b = a - b
            b_a = b - a

            [a, b].each do |pt|
              if @input[pt].match?(/^[a-zA-Z\d]$/)
                @input[pt] = '#'
              end
            end

            anti = Complex(a.real + a_b.real, a.imag + a_b.imag)
            while @input.include? anti
              if @input[anti].match?(/[a-zA-Z\d]/)
                @input[anti] = '#'
              else
                @input[anti] = '#'
              end
              anti = Complex(anti.real + a_b.real, anti.imag + a_b.imag)
            end

            anti = Complex(b.real + b_a.real, b.imag + b_a.imag)
            while @input.include? anti
              if @input[anti].match?(/[a-zA-Z\d]/)
                @input[anti] = '#'
              else
                @input[anti] = '#'
              end
              anti = Complex(anti.real + b_a.real, anti.imag + b_a.imag)
            end
          end
        end

        @input.count { |k,v| v.include?('#') }
      end
    end

    def self.solve(input_file_path = File.join(__dir__, 'input.txt'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)

      puts "Day08.1 Solution: #{puzzle.part_one}"
      puts "Day08.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day08.solve
end