class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/9b/63/dcbb5a4a8b731ba8bceceac6605ea3cbf186189666934e68151f7fb19286/git-plus-v0.4.2.tar.gz"
  sha256 "34c96393c58145a26aec1e21617ff500a0770080e23f49f5c8b90d2f6396486d"
  revision 1 unless OS.mac?
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4ef55a7a9983b50f263cadc7f11a18225ed7f1736bbeb1077aca7f4f3506362" => :catalina
    sha256 "c265fd83d70e9b889e14b43cc20cff89b996ce0f81b2a00e235025982914d509" => :mojave
    sha256 "b5d09be155b8d7bfa239d5030f4e0adfadf91c08d32e3f9900d89d2d0a813870" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "testme" do
      system "git", "init"
      system "git", "config", "user.email", "\"test@example.com\""
      system "git", "config", "user.name", "\"Test\""
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match "D README", shell_output("#{bin}/git-multi")
  end
end
