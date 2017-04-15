class X11 < Formula
  desc "X.Org X11 libraries"
  homepage "https://www.x.org/"
  ### http://www.linuxfromscratch.org/blfs/view/svn/x/x7lib.html
  url "https://raw.githubusercontent.com/Linuxbrew/homebrew-xorg/317ef5e60c62298a28f08bb44ca6a09d79793735/README.md"
  version "20170115"
  sha256 "76b4fd623d6b10d816069aedcffc411e2c9abc607533adf3fa810d7904b5f9d1"
  # tag "linuxbrew"

  bottle :unneeded

  depends_on "linuxbrew/xorg/xorg"

  def install
    ohai "This is a virtual package that only exists to depend on linuxbrew/xorg/xorg"
    prefix.install "README.md" => "x11.md"
  end

  test do
    # No test is possible. Just silence brew audit
    true
  end
end
