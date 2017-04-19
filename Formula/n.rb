# n: Build a bottle for Linuxbrew
class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v2.1.4.tar.gz"
  sha256 "4ee4fd40fd151a9320cc32640c156adfdaeecd0821ef5208dc0ecfbdc14db043"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "422b6ff8b2ee55b39a286fcbda99fd7a8e36eb48bedefda7fb875eea5de5ae19" => :sierra
    sha256 "422b6ff8b2ee55b39a286fcbda99fd7a8e36eb48bedefda7fb875eea5de5ae19" => :el_capitan
    sha256 "422b6ff8b2ee55b39a286fcbda99fd7a8e36eb48bedefda7fb875eea5de5ae19" => :yosemite
    sha256 "bc7411aeec35d7f1332ba58b86fd568e4a4a12a211ec61c5eb5bf230883086f3" => :x86_64_linux
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
