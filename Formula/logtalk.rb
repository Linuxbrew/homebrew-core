class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3380stable.tar.gz"
  version "3.38.0"
  sha256 "201c19fbcdd017ab376719ce052afba04263652f5766f2a423de2554814ecda8"

  bottle do
    cellar :any_skip_relocation
    sha256 "73649c788fd6ebc4f6ab1456734c431c62475167acb8156b9dba5839ce29951a" => :catalina
    sha256 "30be3d195521c8c7da84fa717f932a660220805e4cdb2f9e526b7ceb4669b47d" => :mojave
    sha256 "c333d71a7427c66e92c296cbec0abe67ad481a5a940065207f60ef9274577d99" => :high_sierra
    sha256 "6b733568395aca3adf4d25462c72cdcc45ca3c6a20dcb5e5b4bee73e87e133d0" => :x86_64_linux
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
