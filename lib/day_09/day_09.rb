module AdventOfCode2024
  module Day09
    class Puzzle
      attr_accessor :input

      def initialize(input)
        @input = input
      end
      
      def self.parse_input(input_string)
        fs = []
        fi = 0 # file index
        input_string.size.times do |i|
          num = input_string[i].to_i
          if i.even?
            num.times { fs << fi }
            fi += 1
          else
            num.times { fs << '.' }
          end
        end

        fs
      end

      def part_one
        new = @input.dup

        (@input.size - 1).downto(0) do |i|
          if @input[i] != '.'
            new[new.index('.')] = @input[i]
            new[i] = '.'
          end

          break if new.index('.') >= i
        end
        
        sum = 0
        new[0..(new.index('.') - 1)].each_with_index { |f,i| sum += f.to_i * i }
        sum
      end
      
      def part_two
        new = @input.dup
        files = []
        ptr = [new[0]]
        new[1..].each do |x|
          if x == ptr.first
            ptr << x
          else
            files << ptr
            ptr = [x]
          end
        end
        files << ptr
        (files.size - 1).downto(0) do |i|
          file = files[i]
          old = new.index(file.first)
          old_end = old + file.size - 1
          free = new.each_index.find { |i| new[i..(i + file.size - 1)] == ['.'] * file.size }
          if !free.nil? && free < old
            free_end = free + file.size - 1
            new[free..free_end] = file
            new[old..old_end] = ['.'] * file.size
          end
        end

        sum = 0
        new.each_with_index { |f,i| sum += f * i if f.is_a? Integer }
        sum
      end
    end

    def self.solve(input_file_path = File.join(__dir__, 'input.txt'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)

      puts "Day09.1 Solution: #{puzzle.part_one}"
      puts "Day09.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day09.solve
end