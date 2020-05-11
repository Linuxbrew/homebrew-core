class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.3.3.tar.gz"
  sha256 "33af07ddb519818aca75f876fc704c1bd1b92daee04d9ed6d39ded006356b1e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "769a93780c86cfc4374ba08083426e83f46c79f77c8327d44c35cc92f85d5212" => :catalina
    sha256 "a2ad0b97c285aa63a01649887b59adee3d9d0278c406f71a71c07aa17ba4a50d" => :mojave
    sha256 "1e405d7388a324ec43d04ae02c6e64dd050fe3201e5335c2a54ffcf827f0b38d" => :high_sierra
    sha256 "a3c379c3dda81924f04c35467f4f70f3f934dc89e87c5862887f1fa21c1ef872" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./b3sum/"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
