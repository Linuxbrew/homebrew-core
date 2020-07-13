class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://github.com/juju/juju.git",
    :tag      => "juju-2.8.1",
    :revision => "16439b3d1c528b7a0e019a16c2122ccfcf6aa41f"

  bottle do
    cellar :any_skip_relocation
    sha256 "299b35b832c49540bcc373cab47ed16f066280927877e0712d914e6b6e981a70" => :catalina
    sha256 "a896b2f3489774392f4d0c6d640d0ea222d99f54d7b74b583ec35d81e01dc81a" => :mojave
    sha256 "6b37fe65c0e41cce1ac0089d8b4fc55c4dee87acd9a3c5e342233801551b6666" => :high_sierra
    sha256 "ad2a71b5b7722c3352e9923eebd8f5b03b9a56436c80aecae90d2e12c90a225c" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    git_commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{git_commit}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "./cmd/juju"
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "-o", bin/"juju-metadata",
                 "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
