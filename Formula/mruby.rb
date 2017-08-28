class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/1.3.0.tar.gz"
  sha256 "10c6645ec59b5f8cd80069e7297abc514b54af3540722102b5b968033a209bf4"

  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2389720557c8a6421882561d096dfd84317f47c628b03852d86a34b2afb61aec" => :sierra
    sha256 "d9a8487acd5544562cfea50da211f5268f86630ed5d197ab1c9bab68b453ca9c" => :el_capitan
    sha256 "77e4dc3179a3e0f86c35fdf3aad37ff57c31cf9410f776cc953d9cfe797186a7" => :yosemite
    sha256 "3024338caca222d50782e95491bcc53e4849d858519668cdab90ca2a7ed3f731" => :x86_64_linux # glibc 2.19
  end

  depends_on "bison" => :build

  def install
    system "make"

    cd "build/host/" do
      lib.install Dir["lib/*.a"]
      prefix.install %w[bin mrbgems mrblib]
    end

    prefix.install "include"
  end

  test do
    system "#{bin}/mruby", "-e", "true"
  end
end
