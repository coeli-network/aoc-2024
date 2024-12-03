module AdventOfCode2024
  module Day03
    class Puzzle
      def initialize(input)
        @input = input
      end
      
      def self.parse_input(input_string)
        instructions = input_string.scan(/mul\(\d+,\d+\)|don't|do/)
        parsed_instructions = []
        instructions.each do |instruction|
          case instruction
          when "don't", "do"
            parsed_instructions.append(instruction)
          else
            operation = "mul"
            factor_one, factor_two = instruction.scan(/\d+/)
            parsed_instructions.append([operation, factor_one.to_i, factor_two.to_i])
          end
        end
        parsed_instructions
      end

      def part_one
        @input.sum do |instruction|
          if instruction[0] == "mul"
            instruction[1] * instruction[2]
          else
            0
          end
        end
      end
      
      def part_two
        mul_enabled = true
        @input.sum do |instruction|
          case instruction
          when "do"
            mul_enabled = true
            0
          when "don't"
            mul_enabled = false
            0
          else
            if mul_enabled
              instruction[1] * instruction[2]
            else
              0
            end
          end
        end
      end
    end

    def self.solve(input_file_path = File.join(__dir__, 'input.txt'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)

      puts "Day03.1 Solution: #{puzzle.part_one}"
      puts "Day03.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day03.solve
end