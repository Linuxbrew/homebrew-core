class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.21.0.tar.gz"
  sha256 "6ebba127c5eeca8052b9a9178f57e5a0a23645494af66a34f7360d251d61dff9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a112a661a553041498662cb5e208d55a201d3316261e0c87b21f15da1a10971" => :catalina
    sha256 "83ea687c151cbbb9ebf9e413fa54b9a01d506a071f1df9b83e198d3beef44947" => :mojave
    sha256 "c6a5ac989e68f4bcf6c2825d3812a56b2b5349d6761b4f242366c2713446abb3" => :high_sierra
    sha256 "3f94ce79e77eea32bf2daa2162474f813e565248ef39476016313be72c8e78ea" => :x86_64_linux
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
