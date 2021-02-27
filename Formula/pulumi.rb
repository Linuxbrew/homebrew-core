class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.21.2",
      revision: "543cbe194c17a515eb682b9dd105b0dcfd30a810"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4402df0189e33c9f72d232e8ce0cd123acbf92f1cdbd2f721b382511e57c567"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3bbd55fba0761e7c523c7eb4f4aa6260f1231531310615168aeaedadcce828d"
    sha256 cellar: :any_skip_relocation, catalina:      "652b82433a44da52b9522dfa331c6847baca1722cd97030e8ffe39b924968050"
    sha256 cellar: :any_skip_relocation, mojave:        "6c5197e7b9199619ab9f8abb58d0c878def9ade8f3e6d59c82f5c999b3f3e3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e04f9013c1a9b666a65514bd15deadc2dae688db5b13f7f8a8e87116488311d6"
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
