class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https://sqlc.dev/"
  url "https://github.com/kyleconroy/sqlc/archive/v1.8.0.tar.gz"
  sha256 "6374c213c0edce9a4f852ce6ef737784d1623189b724160e0429d84519f7744f"
  license "MIT"
  head "https://github.com/kyleconroy/sqlc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fb59db86e0b0d220bdb41fffe9682f46c4660190b9281d172629dd4e491c1c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "954bd99e88d993edcb1ad0d17c6219068d8f67cc1c83ec14109c5c38ce1597ca"
    sha256 cellar: :any_skip_relocation, catalina:      "6f3a224a2f222f69cc184770657b27e8690fb326818078e723ff08fadd27e695"
    sha256 cellar: :any_skip_relocation, mojave:        "a207d10bd585d8a3362e9e823127836a4358ad0b861ab091913288b65b7a8b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f73bfd6badb0e9a0d0d1675871f2f408bbf4008593aa2a8b6dda14d02f2778b" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/sqlc"
  end

  test do
    (testpath/"sqlc.json").write <<~SQLC
      {
        "version": "1",
        "packages": [
          {
            "name": "db",
            "path": ".",
            "queries": "query.sql",
            "schema": "query.sql",
            "engine": "postgresql"
          }
        ]
      }
    SQLC

    (testpath/"query.sql").write <<~EOS
      CREATE TABLE foo (bar text);

      -- name: SelectFoo :many
      SELECT * FROM foo;
    EOS

    system bin/"sqlc", "generate"
    assert_predicate testpath/"db.go", :exist?
    assert_predicate testpath/"models.go", :exist?
    assert_match "// Code generated by sqlc. DO NOT EDIT.", File.read(testpath/"query.sql.go")
  end
end
