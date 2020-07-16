class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/liquidata-inc/dolt/archive/v0.18.1.tar.gz"
  sha256 "a95c40fcfde716e93cf47714e29102b6cfd85fc1c4231d5c50cc717abb0ccdba"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a751e5931287a1fa7906b4875d94e6432795ed8fe774fd05824129303f5de23" => :catalina
    sha256 "62d553cf0eea59c7dd07dec079a9c850b85037fefdd4901bfd4c417b18812f65" => :mojave
    sha256 "a85ae4bccdb7b1dfec194adcbd7d9d1d35eaba9fcf44080a1a3268df7ebf8183" => :high_sierra
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
