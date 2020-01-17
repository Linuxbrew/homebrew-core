# aws-okta: Build a bottle for Linux
class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v0.27.0.tar.gz"
  sha256 "e78813870d970dd3710d42d0993f8c437dedc6d888c3e72606e745abecdb6308"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "02d10c6d792f45046310509f092c3ee04d3ef9e634163368a8123160a2838789" => :catalina
    sha256 "92ac4c1d0b6fcb81323bada47c0aad22f6d45aed5abc2cc429d754c8d40c52d6" => :mojave
    sha256 "021aefbffe18d01beed3b60f50b875570db3023b8cd6c61ef4934c1e57148f47" => :high_sierra
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
