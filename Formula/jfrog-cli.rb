class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.45.2.tar.gz"
  sha256 "27b7e3eddb8e7cff83c1c864b35fa608f1b480128e414865d6440743578f1f8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99f36bf8b020aa6f6659aabcc1bf9915a60c58bb3e352039a7640068a7661b4d"
    sha256 cellar: :any_skip_relocation, big_sur:       "10cede5f5c483680cd46862cdf2accf685192288ba9183fd40e06fbfd5b91d7c"
    sha256 cellar: :any_skip_relocation, catalina:      "8c3e59110e8123e71010279dfb122e465e542978eccc2cedffdc4a99ce4d42b1"
    sha256 cellar: :any_skip_relocation, mojave:        "c98fc2d7a2923667f9dfe3e239fbb39f1936e37231599c3e7649ae75789512fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b807e4d3b355e2854a34ec26798347606b8f25c8e3ba21d4c9d2786b4811631"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
