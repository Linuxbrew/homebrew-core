class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.22.0.tar.gz"
  sha256 "3eef66c5af010f75d4d270618ecbfdb670bde14e39bdfeed0bab3a5d12c7d6a2"
  license "MIT"
  revision 1 unless OS.mac?
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d83a7c27f97788c8a76ba8fc708a30795e6bede82329dd32e39a8dee6b907a79" => :catalina
    sha256 "d83a7c27f97788c8a76ba8fc708a30795e6bede82329dd32e39a8dee6b907a79" => :mojave
    sha256 "d83a7c27f97788c8a76ba8fc708a30795e6bede82329dd32e39a8dee6b907a79" => :high_sierra
  end

  depends_on "python@3.9" unless OS.mac?

  def install
    unless OS.mac?
      Dir["*.py"].each do |file|
        next unless File.read(file).include?("/usr/bin/env python")

        inreplace file, %r{#! ?/usr/bin/env python}, "#!#{Formula["python@3.9"].opt_bin/"python3"}"
      end
    end

    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive").chomp
  end
end
