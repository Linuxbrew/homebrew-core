class Gradle < Formula
  desc "Open-source build automation tool based on the Groovy and Kotlin DSL"
  homepage "https://www.gradle.org/"
  url "https://services.gradle.org/distributions/gradle-7.1.1-all.zip"
  sha256 "9bb8bc05f562f2d42bdf1ba8db62f6b6fa1c3bf6c392228802cc7cb0578fe7e0"
  license "Apache-2.0"

  livecheck do
    url "https://services.gradle.org/distributions/"
    regex(/href=.*?gradle[._-]v?(\d+(?:\.\d+)+)-all\.(?:[tz])/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a30f2e4362856a01278ada0f4925f4a4f4cb83482537baf6ece5bc85d4939fb7"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c764404819ef3b7c27610d8ceea7adfb3e005a5fc672c26ba6a25876714b2f8"
    sha256 cellar: :any_skip_relocation, catalina:      "9c764404819ef3b7c27610d8ceea7adfb3e005a5fc672c26ba6a25876714b2f8"
    sha256 cellar: :any_skip_relocation, mojave:        "9c764404819ef3b7c27610d8ceea7adfb3e005a5fc672c26ba6a25876714b2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2abb388779ce3bc1919284ec5dfcc2f1c4439ec220cf5e3538b95f9b31058e2" # linuxbrew-core
  end

  # gradle currently does not support Java 17
  if Hardware::CPU.arm?
    depends_on "openjdk@11"
  else
    depends_on "openjdk"
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin docs lib src]
    env = if Hardware::CPU.arm?
      Language::Java.overridable_java_home_env("11")
    else
      Language::Java.overridable_java_home_env
    end
    (bin/"gradle").write_env_script libexec/"bin/gradle", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gradle --version")

    (testpath/"settings.gradle").write ""
    (testpath/"build.gradle").write <<~EOS
      println "gradle works!"
    EOS
    gradle_output = shell_output("#{bin}/gradle build --no-daemon")
    assert_includes gradle_output, "gradle works!"
  end
end
