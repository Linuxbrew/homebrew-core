class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.15/docutils-0.15.tar.gz"
  sha256 "c35e87e985f70106f6f97e050f3bed990641e0e104566134b9cd23849a460e96"

  bottle do
    cellar :any_skip_relocation
    sha256 "3230d98f9912c462a2b6dd1aa64494fa26037eec4c1975a75970361de6243e79" => :catalina
    sha256 "c655dd3f311370b4c6683236b6ead52d800397e050584124a54709effa556746" => :mojave
    sha256 "7fc8102f9f46d9f3bc4debe405fa6b533809aa73da074d0379652971a30fbd93" => :high_sierra
    sha256 "6393cc30ff4cef96e4309fc912267fd9649396fc31a471b15af6363eb1cedf95" => :sierra
    sha256 "b78153a715eb15fffa96ac921752128ce0b2e48ff7a1b20df5325b8c84caf224" => :x86_64_linux
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
