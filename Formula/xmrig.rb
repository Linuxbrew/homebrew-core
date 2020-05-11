class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v5.11.1.tar.gz"
  sha256 "c0a8cedf42a95f78bb4ca306435f9f1793820e3285d5cd588943c7959e8fb810"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    cellar :any
    sha256 "6bee28ba68f709014df32efa8adfe9b0b5275d1ed4188395a2e8c15eaf6b2160" => :catalina
    sha256 "dff89bf23ae4a09a261731131eb58c7c37df0cb2571164d8f3aed810a7a00700" => :mojave
    sha256 "ff4f1e1575654aff03cbbdd637631d2fd4f8d0f52f1529d61d8f325ed17e4373" => :high_sierra
    sha256 "98c317f6e13a223ccc642f155d2339bf5375d6a2a2938f2fea9b6188f3e6f4ed" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_CN_GPU=OFF", *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
    test_server="donotexist.localhost:65535"
    timeout=10
    begin
      read, write = IO.pipe
      pid = fork do
        exec "#{bin}/xmrig", "--no-color", "--max-cpu-usage=1", "--print-time=1",
             "--threads=1", "--retries=1", "--url=#{test_server}", :out => write
      end
      start_time=Time.now
      loop do
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if read.gets.include? "\] \[#{test_server}\] DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
