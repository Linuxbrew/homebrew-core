class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/erlyaws/yaws/archive/yaws-2.0.9.tar.gz"
  sha256 "a2bbfe10c780ef2c3b238eaf76d902f4921c63b49d135bb9878b163ef1870a6d"
  license "BSD-3-Clause"
  head "https://github.com/erlyaws/yaws.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/yaws[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "05a4889aabbc463927e6e86f7ce5ab6fdf4e041ff61b1ae063622482c022abc5" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "erlang"

  on_linux do
    depends_on "linux-pam"
  end

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    # Ensure pam headers are found on Xcode-only installs
    extra_args = %W[
      --with-extrainclude=#{MacOS.sdk_path}/usr/include/security
    ]
    on_linux do
      extra_args = %W[
        --with-extrainclude=#{Formula["linux-pam"].opt_include}/security
      ]
    end
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", *extra_args
    system "make", "install", "WARNINGS_AS_ERRORS="

    cd "applications/yapp" do
      system "make"
      system "make", "install"
    end

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath

    # Remove Homebrew shims references on Linux
    on_linux do
      inreplace Dir["#{prefix}/var/yaws/www/*/Makefile"], HOMEBREW_LIBRARY/"Homebrew/shims/linux/super/",
        "/usr/bin/"
    end
  end

  def post_install
    (var/"log/yaws").mkpath
    (var/"yaws/www").mkpath
  end

  test do
    user = "user"
    password = "password"
    port = free_port

    (testpath/"www/example.txt").write <<~EOS
      Hello World!
    EOS

    (testpath/"yaws.conf").write <<~EOS
      logdir = #{mkdir(testpath/"log").first}
      ebin_dir = #{mkdir(testpath/"ebin").first}
      include_dir = #{mkdir(testpath/"include").first}

      <server localhost>
        port = #{port}
        listen = 127.0.0.1
        docroot = #{testpath}/www
        <auth>
                realm = foobar
                dir = /
                user = #{user}:#{password}
        </auth>
      </server>
    EOS
    fork do
      exec bin/"yaws", "-c", testpath/"yaws.conf", "--erlarg", "-noshell"
    end
    sleep 3

    output = shell_output("curl --silent localhost:#{port}/example.txt")
    assert_match "401 authentication needed", output

    output = shell_output("curl --user #{user}:#{password} --silent localhost:#{port}/example.txt")
    assert_equal "Hello World!\n", output
  end
end
