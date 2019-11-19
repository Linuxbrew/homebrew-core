class NetTools < Formula
  desc "Linux networking base tools"
  homepage "https://sourceforge.net/projects/net-tools"
  url "https://git.code.sf.net/p/net-tools/code.git",
    # not specyfing a tag, cause upstream did not make a release since a long time...
    :revision => "aebd88ef8d6e15f673b62a649a50d07ed727c888"
  version "1.60+"
  # tag "linux"

  bottle do
  end

  depends_on "gettext" => :build
  depends_on "libdnet"

  def install
    system "yes '' | make config"
    system "make"
    system "make", "DESTDIR=#{prefix}", "update"
  end

  test do
    system bin/"netstat", "-i"
  end
end
