class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.15.0",
      revision: "911eec4d55ae04cd755ae4442a862330ccb2034f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "112fdb639256b270e51ad917ec050c57de6e612e5cf9fe3ca9d83e7a5dfef42a" => :big_sur
    sha256 "791633f9e2dd9ecb4533fdc3a86c244a47fda5f84521e1525cbe23085cc9dfa1" => :catalina
    sha256 "f2b50f0ba24fccb88b08e24bff540d9b498c771234212d08953fe1d611d75e53" => :mojave
    sha256 "7cd0474caa0713a7105ee13834a275ca412762e5b60b6155e3944c1bfa547549" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
