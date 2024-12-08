require 'set'

module AdventOfCode2024
  module Day07
    class Puzzle
      attr_accessor :input

      def initialize(input)
        @input = input
      end
      
      def self.parse_input(input_string)
        eqs = {} # test_val -> remaining numbers
        lines = input_string.split("\n")
        lines.each do |line|
          test_val, remaining = line.split(':')
          eqs[test_val.to_i] = remaining.strip.split(' ').map(&:to_i)
        end 

        eqs
      end

      def part_one
        sum = 0
        ops = ['*', '+']
        @input.each do |k,v|
          ops.repeated_permutation(v.size - 1) do |o|
            try = v[0]

            v[1..].each_with_index do |num, i|
              case o[i]
              when '*'
                try = try * num
              when '+'
                try = try + num
              end
            end

            if k == try
              sum += try
              break
            end
          end
        end

        sum
      end
      
      def part_two
        sum = 0
        pos_ops = ['*', '+', '|'] # possible operators
        @input.each do |k,v|
          pos_ops.repeated_permutation(v.size - 1) do |ops|
            try = v[0]

            v[1..].each_with_index do |num, i|
              case ops[i]
              when '|'
                try = [try, num].join('').to_i
              when '*'
                try.nil? ? try = num : try *= num
              when '+'
                try.nil? ? try = num : try += num
              end
            end

            if try == k
              sum += try
              break
            end
          end
        end

        sum
      end
    end

    def self.solve(input_file_path = File.join(__dir__, 'input.txt'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)

      puts "Day07.1 Solution: #{puzzle.part_one}"
      puts "Day07.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day07.solve
end