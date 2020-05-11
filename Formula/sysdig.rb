class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.26.7.tar.gz"
  sha256 "c82aa4201e8ad37e22c780c27c28ac28359a8e677b4dc0ea295eb1452115d6c0"

  bottle do
    sha256 "82559bd8211c528d3bfa83d47c96fe98441a134ab67a347c159e033d23337b33" => :catalina
    sha256 "567562410bacba7340b5e4a02d84c350f8f1ab34d813ecfa0ab6d009dfd7588f" => :mojave
    sha256 "7e4df940ea4ffcdfeebb24cbefd377493e367765290878319bef0eb70f0fbe76" => :high_sierra
    sha256 "90f7c10c181b116c5a25846ff83116c62606e7a5cc214058ac0c7a0b99df98ee" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "tbb"
  unless OS.mac?
    depends_on "c-ares"
    depends_on "curl"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "jq"
    depends_on "protobuf"
  end

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}",
                            "-DUSE_BUNDLED_DEPS=OFF",
                            "-DCREATE_TEST_TARGETS=OFF",
                            ("-DUSE_BUNDLED_B64=ON" unless OS.mac?),
                            ("-DBUILD_DRIVER=OFF" unless OS.mac?),
                            *std_cmake_args
      system "make"
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
