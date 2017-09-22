module Homebrew
  module_function

  # Return true if the file is a binary executable or library.
  def binary_object?(file)
    f = Pathname.new file
    return false unless f.file?
    return true if f.extname == ".a"
    if OS.mac?
      f.dylib? || f.mach_o_executable? || f.mach_o_bundle?
    else
      f.elf?
    end
  end

  # Strip a keg.
  def strip(keg)
    keg = Keg.new keg unless keg.is_a? Keg
    binaries = Dir[keg/"**/*"].select do |f|
      !File.symlink?(f) && binary_object?(f)
    end
    return if binaries.empty?

    puts "  #{keg} (#{keg.abv})"
    not_writable = binaries.reject { |f| File.writable? f }
    begin
      safe_system "chmod", "u+w", *not_writable unless not_writable.empty?
      args = ["--strip-unneeded", "--preserve-dates"] unless OS.mac?
      system "strip", *args, *binaries, err: (:close unless ARGV.verbose?)
    ensure
      system "chmod", "u-w", *not_writable unless not_writable.empty?
    end
    puts "  #{keg} (#{keg.abv})"
  end

  # Strip all the installed kegs of a formula.
  def strip_formula(formula)
    kegs = formula.installed_kegs
    return ofail "Formula not installed: #{formula.full_name}" if kegs.empty?
    ohai "Stripping #{formula.full_name}..."
    kegs.each { |keg| keg.lock { strip keg } }
  end
end
