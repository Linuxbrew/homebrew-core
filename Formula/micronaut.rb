class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.5.7.tar.gz"
  sha256 "5fce4ec749ef894138c29a74443dc145998f295313f7ce15fcc28933ef4656e6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2606af973b6285b56dc4391802b67011173e213f1e715106b5471f09f7db3e78"
    sha256 cellar: :any_skip_relocation, big_sur:       "527c4672ad95f7a9648afc51aaef352f2d2f4c8614603c2770d76156f58a867a"
    sha256 cellar: :any_skip_relocation, catalina:      "2198fd9de75e213ba610de94229b609765dfca01f80a45b0d0a2bd347522b8cf"
    sha256 cellar: :any_skip_relocation, mojave:        "a99c9da5ef8e114bbc7ca11fde8f1ab332ab6c9192d6ab660117157dc287a38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a92f23521e8562161f693e0dae0cc48d46244fa41a87727deab04f50d846e13" # linuxbrew-core
  end

  if Hardware::CPU.arm?
    depends_on "openjdk@11"
  else
    depends_on "openjdk"
  end

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

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
