class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https://github.com/Andersbakken/rtags"
  url "https://github.com/Andersbakken/rtags.git",
      tag:      "v2.38",
      revision: "9687ccdb9e539981e7934e768ea5c84464a61139"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/Andersbakken/rtags.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 x86_64_linux: "62d0bdd599b47230638cd9450b830c81238ae941890bfe331ad215b0087104c4"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@1.1"

  depends_on "gcc" unless OS.mac?

  fails_with gcc: "5"

  def install
    args = std_cmake_args << "-DRTAGS_NO_BUILD_CLANG=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/bin/rdm --verbose --inactivity-timeout=300 --log-file=#{HOMEBREW_PREFIX}/var/log/rtags.log"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/rdm</string>
          <string>--verbose</string>
          <string>--launchd</string>
          <string>--inactivity-timeout=300</string>
          <string>--log-file=#{var}/log/rtags.log</string>
        </array>
        <key>Sockets</key>
        <dict>
          <key>Listener</key>
          <dict>
            <key>SockPathName</key>
            <string>#{ENV["HOME"]}/.rdm</string>
          </dict>
        </dict>
      </dict>
      </plist>
    EOS
  end

  test do
    mkpath testpath/"src"
    (testpath/"src/foo.c").write <<~EOS
      void zaphod() {
      }

      void beeblebrox() {
        zaphod();
      }
    EOS
    (testpath/"src/README").write <<~EOS
      42
    EOS

    rdm = fork do
      $stdout.reopen("/dev/null")
      $stderr.reopen("/dev/null")
      exec "#{bin}/rdm", "--exclude-filter=\"\"", "-L", "log"
    end

    begin
      sleep 1
      pipe_output("#{bin}/rc -c", "clang -c #{testpath}/src/foo.c", 0)
      sleep 1
      assert_match "foo.c:1:6", shell_output("#{bin}/rc -f #{testpath}/src/foo.c:5:3")
      system "#{bin}/rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end
