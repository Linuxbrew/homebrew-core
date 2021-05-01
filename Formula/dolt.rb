class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.2.tar.gz"
  sha256 "fddb493a6d2f9dfe2abce5693f9a0a13ffa89c50af2ff62576e02f3bb59aa733"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7004b68bbe1f9dc30c7230380f4bed49505b0bc88da189f2f55784a33bb2bf35"
    sha256 cellar: :any_skip_relocation, big_sur:       "30b3b8d9bbc97197e6ec5cc0a7e85f8c42e1ec74abe5f8bd63d1aa94f9889b16"
    sha256 cellar: :any_skip_relocation, catalina:      "a33f9e850be5d33e110f15d8756f415d172d080d7c26a34d12e206838207c553"
    sha256 cellar: :any_skip_relocation, mojave:        "b65a73fee39b1abc6a050ba26547a10c8a0348c2d53ab198eafa6ddfee870d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e0c16a28f08132f7148c3c50d0dfb04c25281b1a007e9310b4bd7304fb848c"
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
