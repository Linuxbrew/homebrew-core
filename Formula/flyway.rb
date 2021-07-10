class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/7.11.1/flyway-commandline-7.11.1.tar.gz"
  sha256 "6f3712a75c4d80dd18926be388a1f8cac95a639656a2ce3fde85d68662553738"
  license "Apache-2.0"

  livecheck do
    url "https://flywaydb.org/documentation/usage/maven/"
    regex(/&lt;version&gt;.*?v?(\d+(?:\.\d+)+)&lt;/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "75b3f62c90cf3447dddd8660a2c218d9dfa55e153327af7e909641ad6352ee0e" # linuxbrew-core
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
