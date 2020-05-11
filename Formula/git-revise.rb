class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://github.com/mystor/git-revise/archive/0.5.1.tar.gz"
  sha256 "3f64521eb056ff097eb282811459820e1afd138cf2de113d609051060459d24d"
  revision OS.mac? ? 2 : 3
  head "https://github.com/mystor/git-revise.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7e23c15bd16585e0437cecbef947b4deeae17469c184563ca60aa8236e529027" => :catalina
    sha256 "1af281b6fd52de21f78e269cfc01f869b23093d87730d4eb0d4367eabfd06f24" => :mojave
    sha256 "19bc350c3e047b8ca4108809341bf425a63ef7b04eaa2a6585fbf1f0eb570bc8" => :high_sierra
    sha256 "8bad2d663bac8721f8b183799dad4d43ce8825eedf2446bb51729d604b71b268" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
    man1.install "git-revise.1"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = J. Random Tester
        email = test@example.com
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "a bad message"
    system "git", "revise", "--message", "a good message", "HEAD"
    assert_match "a good message", shell_output("git log --format=%B -n 1 HEAD")
  end
end
