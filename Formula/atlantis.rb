class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.12.0.tar.gz"
  sha256 "df7c17fef4b37347fc22e1c5bf3d2b29ad1b219e70b6bff111e38d8ee01102e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c71acb4eaaa764b34c41449ea2ad0d8a4078daee94d96849d26316e01dba671" => :catalina
    sha256 "f0f4f37b72be4d8c0c66ed95cfb402f1c8693a11fcf9e470f88b0b2576b585a7" => :mojave
    sha256 "bee44196471c4ed1064b90daffbad24cbcb588bcada6013625e65fa7912005b1" => :high_sierra
    sha256 "78fb2f2ba688f2b61bbf1267db2b670dad596e4d4c91ca69d78177af4623fb05" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"atlantis"
  end

  test do
    system bin/"atlantis", "version"
    port = 4141
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-whitelist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP\/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
