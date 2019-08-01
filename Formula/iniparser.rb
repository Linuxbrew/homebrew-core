class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "http://ndevilla.free.fr/iniparser/"
  url "https://github.com/ndevilla/iniparser/archive/v4.1.tar.gz"
  sha256 "960daa800dd31d70ba1bacf3ea2d22e8ddfc2906534bf328319495966443f3ae"
  head "https://github.com/ndevilla/iniparser.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69dde8e886645f5b89f83f36835c18449afe7f6c4f119d466d7f204e994952c7" => :mojave
    sha256 "cec20d33114e7a5811acb41f9f9a36a411ffd2eebb7d537167b9b541b03fff8d" => :high_sierra
    sha256 "7ad8eb3b8a66c08b78d2d9d3db18bd50e842d1c5962600ad0c9c8244d296dea8" => :sierra
    sha256 "0ad7f484c703d421dbe3b974c5a8a0c63132fc34b8b9c34f7306a7d802b32961" => :x86_64_linux
  end

  conflicts_with "fastbit", :because => "Both install `include/dictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src/*.h"]
  end
end
