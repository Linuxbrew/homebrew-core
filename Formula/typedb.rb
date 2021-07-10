class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.2.0/typedb-all-mac-2.2.0.zip"
  sha256 "906f4e101c377826c61dc3d7a7958611cb0ee31d240989a58666499c6b8f08d5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "615fd8748ff58c366219a35058cc59dc90b06ad626ceb36295893c3891d84880" # linuxbrew-core
  end

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
