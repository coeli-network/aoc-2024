module AdventOfCode2024
  module Day02
    class Puzzle
      def initialize(input)
        @input = input
      end

      def self.parse_input(input_string)
        reports = []
        input_string.each_line do |line|
          report = line.split.map { |s| s.to_i }
          reports.append(report)
        end
        reports
      end

      # Check a report for safety. A report is a list of levels, and a level 
      # is just an integer. For example, a report could look like this: 
      # [1, 2, 3, 4, 5].
      #
      # Safety invariants:
      # - All differences between levels must be within the range of 1..3
      # - All differences between adjacent levels must be unidirectional 
      #   (i.e., either all increasing or all decreasing).
      def safe?(report)
        previous_element = report[0]
        previous_direction = nil

        report[1..].each do |val|
          difference = (val - previous_element).abs

          # Ensure difference is within the range of 1..3
          if difference < 1 || difference > 3
            return false
          end

          # Establish direction or return false if direction has changed
          current_direction = (val - previous_element).positive? ? 'dec' : 'inc'
          if previous_direction == nil
            previous_direction = current_direction
          elsif previous_direction != current_direction
            return false
          end

          # Set the previous_element
          previous_element = val
        end

        return true
      end

      def safe_with_dampener?(report)
        safe = false
        (0..report.size).each do |index_to_delete|
          dup = report.dup
          dup.delete_at(index_to_delete)
          safe = true if safe? dup
        end

        safe
      end

      def part_one
        @input.count { |report| safe? report }
      end

      def part_two
        @input.count { |report| safe_with_dampener? report }
      end
    end

    def self.solve(input_file_path = File.join(__dir__, 'input.txt'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)

      puts "Day02.1 Solution: #{puzzle.part_one}"
      puts "Day02.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day02.solve
end