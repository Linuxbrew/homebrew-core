class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.12.1.tar.bz2"
  sha256 "bbfaead0345642b97e0de90f889dfbab4b2643a6a5e5c6bb59cd0d26fc0bcd0e"

  livecheck do
    url "https://www.lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b32209eb45a390b770b5aec78ee0f400b51a89b7bdf775c720f521bb9df11836" => :big_sur
    sha256 "ddb5e2f5e985cba860f36a5730d933d88b4b0e76b1a450a3e76b244a5a6f1935" => :catalina
    sha256 "09cbfc5e663214ad2df4e95cb2cf022ea6c153c6bc49d6918ec5c2e69e28a97b" => :mojave
    sha256 "501a8f37d104b1a8f5cb625d2e1a17615114caf57054b9df9fb52df62761f138" => :high_sierra
    sha256 "e0d633513a646bbbe34f2db6214ba55c1b623e2fab1d237fdfc6172a68fdd9c4" => :x86_64_linux
  end

  def install
    # Enforce --build to work around broken upstream detection
    # https://bugs.lttng.org/issues/578#note-1
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --build=x86_64
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{doc}/examples", testpath
    system "make", ("CFLAGS=-pthread" unless OS.mac?), "-C", "examples"
  end
end
