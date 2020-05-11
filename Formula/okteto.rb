class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.8.tar.gz"
  sha256 "ec56acb7b514f1bfa446f513196639c9323dd76f60bdbf312b50da7846096ed6"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b4acba438433c6ac129a017eb250b7cb78e17557ba71c3c97830c52f792dfb2" => :catalina
    sha256 "0a44ebe48bbc1a992c1793d9393cc2701313de671e9ad1faea591291bc1723c1" => :mojave
    sha256 "f9e91d226735e8a3da47ed4d59ecadfdeea853f74334961cde46fe1500f3d821" => :high_sierra
    sha256 "d4fa340fa3e04df80495a8539255574270b561989fec47bb0c802b7f3a259cef" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command:
      - bash
      workdir: /usr/src/app
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
