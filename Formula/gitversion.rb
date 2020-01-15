class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://github.com/GitTools/GitVersion"
  if OS.mac?
    url "https://github.com/GitTools/GitVersion/releases/download/5.1.3/gitversion-osx-5.1.3.tar.gz"
    sha256 "ae885c7eaf58f8af2350c4a8b258095bd6059f606d2b3bb6d6c9420b404f8545"
  else
    url "https://github.com/GitTools/GitVersion/releases/download/5.1.3/gitversion-linux-5.1.3.tar.gz"
    sha256 "503a45fef002b771f77a74e85438e1906cc82f53548c1855c224920f259d84e6"
  end

  bottle :unneeded

  uses_from_macos "icu4c"

  def install
    libexec.install Dir["*"]
    (bin/"gitversion").write <<~EOS
      #!/bin/sh
      #{OS.mac? ? "" : "export LD_LIBRARY_PATH=#{HOMEBREW_PREFIX}/lib"}
      exec "#{libexec}/GitVersion" "$@"
    EOS
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["JENKINS_URL"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "add", "test.txt"
    unless OS.mac?
      system "git", "config", "user.email", "you@example.com"
      system "git", "config", "user.name", "Your Name"
    end
    system "git", "commit", "-q", "--author='Test <test@example.com>'", "--message='Test'"
    assert_match '"FullSemVer":"0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
