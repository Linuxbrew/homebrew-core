class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.41.2.tar.gz"
  sha256 "45eb798d655cc0f2f881b6f4237aa15dffe7b89d2e8a3e260bf937a7de88148a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7a4a076fc5de33d252d0ed0b42167affcfdbba0e8c7a7a402539df057d5c351" => :big_sur
    sha256 "7897fc8a0203eefc711aa0801428600b45fa64a5d7ee57ed27ea21cdb409f116" => :catalina
    sha256 "f13b0ccca6a1d95328b9bba260b3682ec3ab86f0ad7bd925ac0a8bbbc9d0bee1" => :mojave
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
