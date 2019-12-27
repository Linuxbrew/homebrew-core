# run: Build a bottle for Linux
class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.6.5.tar.gz"
  sha256 "5878541e8e29026bf352f78283424217dbf7322a8282cac13b87aa04644e1b58"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca616a915230cf04423546409354267e4abc5082f1b8fd27e0fe77e5db4a6a7d" => :catalina
    sha256 "ca616a915230cf04423546409354267e4abc5082f1b8fd27e0fe77e5db4a6a7d" => :mojave
    sha256 "ca616a915230cf04423546409354267e4abc5082f1b8fd27e0fe77e5db4a6a7d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-ldflags", "-w -s", "-o", bin/name
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath/"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}/#{name} #{task}").chomp
  end
end
