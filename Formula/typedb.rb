class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  if OS.mac?
    url "https://github.com/vaticle/typedb/releases/download/2.1.4/typedb-all-mac-2.1.4.zip"
    sha256 "c77cb21766485d19f16ab5d37006115b36b8196ec92cc818855bca9c42725128"
  end
  unless OS.mac?
    url "https://github.com/vaticle/typedb/releases/download/2.2.0/typedb-all-linux-2.2.0.tar.gz"
    sha256 "c77cb21766485d19f16ab5d37006115b36b8196ec92cc818855bca9c42725128"
  end
  license "AGPL-3.0-or-later"

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server status")
  end
end
