module AdventOfCode2024
  module Day05
    class Puzzle
      def initialize(input)
        @input = input
      end
      
      def self.parse_input(input_string)
        lines = input_string.each_line.map(&:to_s).map(&:strip)
        rules, updates = [], []
        lines[..1175].each { |l| rules.append(l.split('|').map(&:to_i)) }
        lines[1177..].each { |l| updates.append(l.split(',').map(&:to_i)) }
        parsed_input = {} # update -> relevant rules
        updates.each do |u|
          fit_rules = []
          rules.each do |r|
            fit_rules.append(r) if u.include?(r[0]) && u.include?(r[1])
          end
          parsed_input[u] = fit_rules 
        end 

        parsed_input
      end

      def good_update?(update, rules)
        rules.each do |rule|
          left, right = rule
          left_index, right_index = update.index(left), update.index(right)
          if left_index > right_index
            return false
          end
        end

        true
      end

      def part_one
        @input.sum do |update, rules|
          middle_index = (update.size / 2).ceil
          if good_update?(update, rules)
            update[middle_index]
          else
            0
          end
        end
      end
      
      def part_two
        sum = 0
        bad_updates = @input.filter { |update, rules| !good_update?(update, rules) }
        bad_updates.each do |update, rules|
          good_update = update.sort do |a, b|
            case
            when rules.include?([a, b])
              1
            when rules.include?([b, a])
              -1
            else
              0
            end
          end
          
          sum += good_update[(good_update.size / 2).ceil]
        end

        sum
      end
    end

    def self.solve(input_file_path = File.join(__dir__, 'input.txt'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)

      puts "Day05.1 Solution: #{puzzle.part_one}"
      puts "Day05.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day05.solve
end