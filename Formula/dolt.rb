class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.24.3.tar.gz"
  sha256 "395d5c18acc534fe34d441e8889385842f363702146168d23c4a9c3e23c8ce66"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9582b778380b8b672b0ddc1551ed4044ed796369729affd05e5f7bf6d7eb9e36"
    sha256 cellar: :any_skip_relocation, big_sur:       "26e30182fd752376fbeaa17a0c3cd9c076b17c691a0a4c9038e014aa77723709"
    sha256 cellar: :any_skip_relocation, catalina:      "dd04c00296e438d27cd1cad3a5cfdfba97fe3f5dd5c90a3d01d5651a47e7c266"
    sha256 cellar: :any_skip_relocation, mojave:        "82fb6b2c0cb0ea1a5cf7d44138760ab0093ce23827d0bbe817f15dc86ca691c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44585d81a5997a16cfe502f8751e1a26ef28e873ee46b34e59f33def14edaab2"
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
