class Julia < Formula
  desc "The Julia language"
  homepage "https://julialang.org/"
  url "https://julialang-s3.julialang.org/bin/linux/x64/1.4/julia-1.4.2-linux-x86_64.tar.gz"
  version "1.4.2"
  sha256 "d77311be23260710e89700d0b1113eecf421d6cf31a9cebad3f6bdd606165c28"
  license "MIT"

  def install
    Dir["./*"].each { |f| mv f, prefix }
  end

  test do
    system "#{bin}/julia", "--help"
    File.write("test.jl", <<-END
      1+1 
      println("Hello, brew!")
    END
    )
    system "#{bin}/julia", "test.jl"
  end
end
