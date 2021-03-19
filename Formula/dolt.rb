class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.24.2.tar.gz"
  sha256 "7ba29a4159b016ec036cf92297de1b8885e72834f870cff6e87cf0ec4081c518"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7619b1e76b6629e2ff7d9697779fec3a26544a97fd7e05029d772dbf06281fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "69721a89abd66fabb2ecba248367aacc4449d3e0d247ec47e9ee0230adc39ec5"
    sha256 cellar: :any_skip_relocation, catalina:      "07fe6aceca25b70ffa78f275397d9ad630d63f65e373bb93bd6aa4119f870f3e"
    sha256 cellar: :any_skip_relocation, mojave:        "06ea6cf846c85e482b12508bf16791601ba0c90357cfc663e32ba6261a82f569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c719f4f4a5e89e272e21b6fd327ebf4d1b5e25b3c7fb9161c6e71ca15512c20d"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
