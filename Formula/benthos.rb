class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.22.0.tar.gz"
  sha256 "89c1448ecbc54167155f0c5fc75b14c275983497513b47d67632674e439d9af6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea32ca9b7b792bc3b17b431cc71d10fe8aa4b3d8a0c458c6be457110009b96bf" => :catalina
    sha256 "35a5ed45ebf012bbf9f78968d36635eacddad4a2913d4768c9c785602602bb59" => :mojave
    sha256 "2a7af6dbc3b72e459409da1eee978f4765c28049df577e5054f652773f97fd6e" => :high_sierra
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
