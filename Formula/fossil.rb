class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.12.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  bottle do
    cellar :any
    sha256 "1b23b048e57f73caaabbe9f2b2ab30dd0967ab9dd92bfb7236fd023c875e095d" => :catalina
    sha256 "32f5f63521ad2daf607edc6ff125f1f6c4959f375b68a39e2834753845cac79c" => :mojave
    sha256 "a8d2672b653e99d488dbe4d88da3d65a6f9f2db3751a2be4d29e11408bd0e1a4" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if OS.mac? && MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    # fix for CircleCI, where fossil cannot detect the user it is
    # running as
    args = %w[-A alice] unless ENV["USER"]
    system "#{bin}/fossil", "init", *args, "test"
  end
end
