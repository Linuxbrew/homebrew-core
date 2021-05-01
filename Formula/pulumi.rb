class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.1.0",
      revision: "5279b1dfcf50c6224143c71ab7228d7f12bfa736"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32249540a5d189d7bdc3ad5b30f804d9b69109c403b5a8d43a14cdd9849ae0eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4eb8b28f22d6d0cd6bff9c23e0dbc336e2d4c6f0b591cce230bb22c7fa3f9a1"
    sha256 cellar: :any_skip_relocation, catalina:      "43d91acd2df4089d551a6410033ae5eb2c740bdcf030ef2a82cdcd482b68e7a6"
    sha256 cellar: :any_skip_relocation, mojave:        "51f778d056115804cd4835160fdc7c6d5adb1c11a13d1e5df929a95f752a50a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bf242b406abe578ae124177fc17585dae7560002d65665ea1dca8cd1b6e8e31"
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
