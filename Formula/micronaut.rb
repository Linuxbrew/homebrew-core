class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.0.0.tar.gz"
  sha256 "5e30fc1878c9d7da9046745a5f71c611fc9bd1b765e32dd5e597a6fae1739f6c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "77f97e9fe5a4923355cd9dad206ba0918ac7797d9895aa6627aff1453526d7ea" => :catalina
    sha256 "44f688913894d10acbf14c11e7378b553b7a4305081b2889284c91ba515fd724" => :mojave
    sha256 "9f328cf27f0c71fd9d1351e50c3ad80598fa86b060f5d0707d971e17eb3070d0" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
