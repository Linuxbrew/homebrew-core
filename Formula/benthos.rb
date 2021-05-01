class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.45.1.tar.gz"
  sha256 "f45a1b43932287ca3104df1df7e5330506fbf041c465f2933d7316ea80d45be9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8865636d77287d82bb7db3b1cb6bc73341dea7234e86e11938464b488fb74af5"
    sha256 cellar: :any_skip_relocation, big_sur:       "8520475c98be156fde31698a4b5e9aa5c94233b6e7f252aad41ed8ca70b7ab43"
    sha256 cellar: :any_skip_relocation, catalina:      "628ad1f62d4fb14649e22d4c7861b5960ccb417cb0b2465763a37ee5f4a7ece3"
    sha256 cellar: :any_skip_relocation, mojave:        "a4a85273fd690de32ba1e9a0d03edc30f5d98b946fe2f0c84eb73db513a6ef3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6117e2785169a1829118cf3be025cdb68cfa571c0720a5c3c6a7a5957f234e28"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        type: file
        file:
          path: ./sample.txt
      pipeline:
        threads: 1
        processors:
         - type: decode
           decode:
             scheme: base64
      output:
        type: stdout
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
