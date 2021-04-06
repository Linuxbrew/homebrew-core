class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://www.fossil-scm.org/home/uv/fossil-src-2.15.tar.gz"
  sha256 "671edda9a014474d0f07b4c616b37222e218275b3c8e5414657830c6f351877b"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e083b53023095500c9f6d8ab32064d07af3969cfa971dd700f094d01a0a0d107"
    sha256 cellar: :any,                 big_sur:       "a81e7adade3215e2b059018d5008ef0853b257fb53902fbe726ded9b2a3f7f86"
    sha256 cellar: :any,                 catalina:      "54b2f246ded0a15c4788576cf34f69373f43f3c704c9e3f14b976d736fcee9d6"
    sha256 cellar: :any,                 mojave:        "10327b520d52ce5efc063f5282187057f826e59b753abdeab034bfde3caa1972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d766589faf58bf6c7804420a2289f599773f0ab6d3c43997909dcca7710227f"
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

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
