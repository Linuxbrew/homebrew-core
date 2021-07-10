class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "3b6dc9243a1100ef53106c241aef3077b7647818db10ff40c3bddbdb10a2f6c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "046e20e485bb8f51db81fee67978fa06fdc897fa80b369fb581b1786eed233b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "040066de4140b4ee22c879c2a8abddc5517a9320c17a59eed445536582e2b153"
    sha256 cellar: :any_skip_relocation, catalina:      "275f860f27e839b87d73eab4847f498d91cea97616e7d379a58cebb719b0abe8"
    sha256 cellar: :any_skip_relocation, mojave:        "826d9820a46963046e8ee27bdec72578670c42382542403e9776b2e49a276471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86497f7a56e5a201de0bf3dc87303e7939f4d96e57caff91a074f981e7e5ae19" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
