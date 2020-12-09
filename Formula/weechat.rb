class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-3.0.tar.xz"
  sha256 "6cb7d25a363b66b835f1b9f29f3580d6f09ac7d38505b46a62c178b618d9f1fb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "098515df462ca8a6b2bc0d4330cf785c174a2c9566d5d4f2098a9b13e2cbcfa7" => :big_sur
    sha256 "52c3a9d539a96b5c72c87884f6a7e9fcc03fd6155ce67bf24084e9f3a3fadccf" => :catalina
    sha256 "17019246880560ec4d5f1754a53ca1fe1d9a35cf97184f93a7fe2f9586ba135c" => :mojave
    sha256 "f081f5a84f9fd406d4c002b8ff79e3d851f2b57348008ecbf81421607f68c6cd" => :x86_64_linux
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libiconv" if OS.mac?
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.9"
  depends_on "ruby"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    # Fix system gem on Mojave
    ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
