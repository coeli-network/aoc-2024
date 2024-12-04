module AdventOfCode2024
  module Day04
    class Puzzle
      def initialize(input)
        @input = input
      end
      
      def self.parse_input(input_string)
        parsed = []
        input_string.each_line do |line|
          parsed.append(line.strip.each_char.map(&:to_s))
        end
        parsed
      end

      # Read n characters in d direction from @input, starting at coordinate (x,y).
      def read_chars_in_direction(arr:, x:, y:, n:, d:)
        chars = []
        northern_limit = 0
        eastern_limit = arr[y].size - 1
        southern_limit = arr.size - 1
        western_limit = 0

        case d.upcase
        when 'N'
          y_min = y - n + 1
          if y_min >= northern_limit
            y.downto(y_min) { |row_idx| chars.append(arr[row_idx][x]) }
          end
        when 'NE'
          y_min = y - n + 1
          x_max = x + n - 1
          if y_min >= northern_limit && x_max <= eastern_limit
            y.downto(y_min).to_a.zip((x..x_max)).each do |row_idx, char_idx|
              chars.append(arr[row_idx][char_idx])
            end
          end
        when 'E'
          x_max = x + n - 1
          if x_max <= eastern_limit
            (x..x_max).each { |char_idx| chars.append(arr[y][char_idx])}
          end
        when 'SE'
          y_max = y + n - 1
          x_max = x + n - 1
          if y_max <= southern_limit && x_max <= eastern_limit
            (y..y_max).to_a.zip((x..x_max)).each do |row_idx, char_idx|
              chars.append(arr[row_idx][char_idx])
            end
          end
        when 'S'
          y_max = y + n - 1
          if y_max <= southern_limit
            (y..y_max).each { |row_idx| chars.append(arr[row_idx][x]) }
          end
        when 'SW'
          y_max = y + n - 1
          x_min = x - n + 1
          if y_max <= southern_limit && x_min >= western_limit
            (y..y_max).to_a.zip(x.downto(x_min)).each do |row_idx, char_idx|
              chars.append(arr[row_idx][char_idx])
            end
          end
        when 'W'
          x_min = x - n + 1
          if x_min >= western_limit
            x.downto(x_min) { |char_idx| chars.append(arr[y][char_idx]) }
          end
        when 'NW'
          y_min = y - n + 1
          x_min = x - n + 1
          if y_min >= northern_limit && x_min >= western_limit
            y.downto(y_min).to_a.zip(x.downto(x_min)).each do |row_idx, char_idx|
              chars.append(arr[row_idx][char_idx])
            end
          end
        end

        chars.join
      end

      def read_chars_in_all_directions(arr:, x:, y:, n:) 
        results = []
        directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']
        directions.each do |d|
          results.append(read_chars_in_direction(arr: arr, x: x, y: y, n: n, d: d)) 
        end
        results
      end

      def read_chars_in_all_diagonals(arr:, x:, y:, n:)
        results = []
        directions = ['NE', 'SE', 'SW', 'NW']
        directions.each do |d|
          result = read_chars_in_direction(arr: arr, x: x, y: y, n: n, d: d)
          results.append(result)
        end
        results
      end

      def has_x_mas?(grid)
        # corner coordinates (clockwise)
        nw_x, nw_y = [0, 0]
        ne_x, ne_y = [2, 0]

        # check if we can read 'MAS', starting from each corner
        mas_count = 0
        nw_to_se = read_chars_in_direction(arr: grid, x: nw_x, y: nw_y, n: 3, d: 'SE')
        ne_to_sw = read_chars_in_direction(arr: grid, x: ne_x, y: ne_y, n: 3, d: 'SW')
        [nw_to_se, ne_to_sw].each do |diagonal|
          mas_count += 1 if diagonal == 'MAS' || diagonal.reverse == 'MAS'
        end

        if mas_count == 2
          true
        else
          false
        end
      end

      # XMAS...
      def part_one
        xmas_count = 0
        @input.each_with_index do |row, row_idx|
          row.each_with_index do |char, char_idx|
            if char == 'X'
              test_cases = read_chars_in_all_directions(arr: @input, x: char_idx, y: row_idx, n: 4)
              xmas_count += test_cases.count { |test_case| test_case == 'XMAS' }
            end
          end
        end

        xmas_count
      end
      
      # X-MAS!
      def part_two
        x_mas_count = 0
        @input.each_with_index do |row, row_idx|
          row.each_with_index do |char, char_idx|
            if row_idx + 2 < @input.size && char_idx + 2 < @input[row_idx].size
              grid = []
              @input[row_idx..row_idx + 2].each do |r|
                grid.append(r[char_idx..char_idx + 2])
              end
              x_mas_count += 1 if has_x_mas? grid
            end
          end
        end

        x_mas_count
      end
    end

    def self.solve(input_file_path = File.join(__dir__, 'input.txt'))
      input_string = File.read(input_file_path)
      parsed_input = Puzzle.parse_input(input_string)
      puzzle = Puzzle.new(parsed_input)

      puts "Day04.1 Solution: #{puzzle.part_one}"
      puts "Day04.2 Solution: #{puzzle.part_two}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  AdventOfCode2024::Day04.solve
end