class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.42.1.tar.gz"
  sha256 "192a2de0723a4b6154dc4e403c5ec6ef7dcd99e6b5f8309376bc32980174233d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cedb6d60da4a8fd196599e334f884cdad93346770119740fae8d62dcf624cf22"
    sha256 cellar: :any_skip_relocation, big_sur:       "034fd2fec9e8f5ff0e3ec1946fdca0601e8b5d22e5a49536fb0f7c58d274df59"
    sha256 cellar: :any_skip_relocation, catalina:      "68cd2bd48b01b5756f6133ca9b4b7e134bd1b2adfe69ce45127eaea630607253"
    sha256 cellar: :any_skip_relocation, mojave:        "991fda313f2d0180d42b0c6cbf4ed6f71946a0b044092df1a159087988cae508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e826571f1048f8fc916aee0663c8a268058ae9d2aa35a898f366766353debb6d"
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
