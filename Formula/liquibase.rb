class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.4.0/liquibase-4.4.0.tar.gz"
  sha256 "8aa5900195751f7a7d51dfba5364702297c596cbbeed213de806e1deef02095b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34d18e6e538fb21fd9bdfe7ab4007f4ce91e3a30fc9e0096c87b645799f9a4c7" # linuxbrew-core
    sha256 cellar: :any_skip_relocation, all:          "34d18e6e538fb21fd9bdfe7ab4007f4ce91e3a30fc9e0096c87b645799f9a4c7"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", JAVA_HOME: Formula["openjdk"].opt_prefix
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
