module AdventOfCode2024
  module Day01
    class Puzzle
      def initialize(input)
        @input = input
      end

      def self.parse_input(input_string)
        list_one, list_two = [], []
        input_string.each_line do |line|
          one, two = line.split('   ')
          list_one.append(one.to_i)
          list_two.append(two.to_i)
        end
        list_one = list_one.sort
        list_two = list_two.sort
        [list_one, list_two]
      end

      def part_one
        list_one, list_two = @input
        sum = 0
        list_one.each_with_index do |val, idx|
          sum += (val - list_two[idx]).abs
        end

        sum
      end
    end

    def self.solve(input_file_path=File.join(__dir__, 'day_01.input'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)
      
      puts "Day01.1 Solution: #{puzzle.part_one}"
      # puts "Day01.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day01.solve
end