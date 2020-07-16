class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.53.tar.gz"
  sha256 "6a8c18830ac2c068feca763212809325a28fe0ea9646879962b34aba94e8ec26"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e599c7a7311adc8d24ee7abaacb978dd46803893ee83e0b2a2f20484d9502abe" => :catalina
    sha256 "80f05c0a299b1359a2968ffb19e3e9a90dc22a81fb0abba26eb2dfd9d0341823" => :mojave
    sha256 "a45e212d130e2125c77cbedb02f30de6a3e7bd9a27ed87efe37347a0952c2701" => :high_sierra
    sha256 "a225608f9554f802d5d5e06decc95f3bb777a38b3b4c27c9c1965b38512be910" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "off"
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags",
                            "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
    end
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
