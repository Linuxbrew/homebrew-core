# aws-okta: Build a bottle for Linux
class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.0.tar.gz"
  sha256 "3beeb38b3013094cd4b37bb08ff6accdcdbddb4212afceb5e2b114f01465fe6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "edd7d08301dc1a69541a11f37d8bceeb4c9b2ac5c78cd7810a9d12e60b55220c" => :catalina
    sha256 "5f6264c7359a371d8a7231fdb0e63a831e35f86b41f26b3f6f406636bbf494ea" => :mojave
    sha256 "d978a9a7cfab4ec1613e0e0bf30e64f86a9036cda7e831b005752f2aa951cd24" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build
  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}", "-trimpath", "-o", bin/"aws-okta"
    prefix.install_metafiles
  end

  test do
    require "pty"

    PTY.spawn("#{bin}/aws-okta --backend file add") do |input, output, _pid|
      output.puts "organization\n"
      input.gets
      output.puts "us\n"
      input.gets
      output.puts "fakedomain.okta.com\n"
      input.gets
      output.puts "username\n"
      input.gets
      output.puts "password\n"
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      assert_match "Failed to validate credentials", input.gets.chomp
      input.close
    end
  end
end
