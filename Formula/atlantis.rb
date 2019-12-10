# atlantis: Build a bottle for Linux
class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.10.1.tar.gz"
  sha256 "98a1dae80acfa1c322007d4a2e29a28733edc386d74b9b3b07608fe64820a843"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cc3388f1553a1c1142bcf59c5357e9b7b8e020790529febe25e42d83e5502875" => :catalina
    sha256 "08772b561463ee7a26b620338d1c5d2a1ae8b81af8017d63e00e884ffb0ee1f6" => :mojave
    sha256 "e951f14e57a14f631f2b26cf98db73f884115b3ce9a8e6bfa9cbd93b42cfabb6" => :high_sierra
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
