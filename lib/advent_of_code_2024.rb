module AdventOfCode2024
  def self.require_all_days
    Dir.glob(File.join(__dir__, 'day_*')).each do |day_dir|
      day_file = File.join(day_dir, "#{File.basename(day_dir)}.rb")
      require day_file if File.exist?(day_file)
    end
  end

  def self.run_day(day_number)
    day_module = self.const_get("Day#{day_number}")
    day_module.solve
  end
end

AdventOfCode2024.require_all_days