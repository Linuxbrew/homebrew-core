class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/23/be/892184c18bb8b7ddc8d1931d3b638ec2221ae0725111008b330c7d44dc43/git-plus-v0.4.5.tar.gz"
  sha256 "e60d97ceb7472c5f15a7230d14b3e1f4ab050cd5abf574fe9959bcc00fc17285"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bddc068b92e8b64c9e2795eea8f1b52ffe4a69be0374080806157d867f2dee74" => :catalina
    sha256 "dd7f413430c9568a6f1d8a1821c672abb0e184b61403c2d3a366399fb23840a3" => :mojave
    sha256 "878c9fbdc776717eb21c07767bd67fc0d6ad412a69fbeab7ff12f9795076d8f3" => :high_sierra
    sha256 "1d8719ff851e471731a55c7a5548164cf958bd9516a5cf88cbfae3c1de970906" => :x86_64_linux
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
