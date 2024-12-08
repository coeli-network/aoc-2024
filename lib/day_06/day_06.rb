require 'set'

module AdventOfCode2024
  module Day06
    class Puzzle
      attr_accessor :input

      def initialize(input)
        @input = input
      end
      
      def self.parse_input(input_string)
        lines = input_string.split("\n")
        width = lines.size
        @input = {}

        width.times do |y|
          width.times do |x|
            @input[Complex(x,y)] = lines[y][x]
          end
        end

        @input
      end

      def turn(dir)
        case dir
        when '^' then '>'
        when '>' then 'v'
        when 'v' then '<'
        when '<' then '^'
        end
      end

      # Walk from position pos in direction dir.
      def walk(pos, dir)
        case dir
        when '^' then Complex(pos.real, pos.imag - 1)
        when '>' then Complex(pos.real + 1, pos.imag)
        when 'v' then Complex(pos.real, pos.imag + 1)
        when '<' then Complex(pos.real - 1, pos.imag)
        end
      end

      def patrol
        pos, dir = @input.find { |k,v| ['^'].include? v }
        start = pos
        last = nil
        hit = [].to_set
        count = 0

        loop do
          if @input[pos].nil?
            count = @input.count { |k,v| v == 'X' }
            break
          elsif ['#', 'O'].include? @input[pos]
            if hit.include? [pos, dir]
              count = -1
              break
            end
            hit.add([pos, dir])
            dir = turn(dir)
            pos = walk(last, dir)
          else
            @input[pos] = 'X'
            last = pos
            pos = walk(pos, dir)
          end
        end

        # reset guard
        @input[start] = '^'

        return count
      end

      def part_one
        patrol
      end
      
      def part_two
        # use x's from part one as possible spots to place o's
        o_pos = (@input.filter { |k,v| v == 'X' }).keys

        # reset map
        @input.each { |k,v| @input[k] = '.' if ['X', 'O'].include? v }

        # brute force
        loops = 0
        o_pos.each_with_index do |pos, i|
          @input[pos] = 'O'
          loops += 1 if patrol.negative?

          # reset map
          @input.each { |k,v| @input[k] = '.' if ['X', 'O'].include? v }
        end

        loops
      end
    end

    def self.solve(input_file_path = File.join(__dir__, 'input.txt'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)

      puts "Day06.1 Solution: #{puzzle.part_one}"
      puts "Day06.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day06.solve
end