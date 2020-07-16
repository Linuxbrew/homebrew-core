class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    :tag      => "v0.27.0",
    :revision => "6fa889d0011729fbac4c3365361610d9bf019d4d"
  license "AGPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "704661df647ee6e48ca4f48c4bfc582ac0b1e369cd22b1c41d00aaa99e579727" => :catalina
    sha256 "dab5a85c3803da27d927f1e64d5dd52b17ffce12bdfb86e1ddfa28bb38b28d35" => :mojave
    sha256 "7fadfa731dcc0f851df436506c4600ffb833ea1fa80d205c6392261847a0c338" => :high_sierra
    sha256 "4cd4904b6eaad3acfb9ce190ffe5cf479f3a5224aaa64eec7cb06d1b3a2be557" => :x86_64_linux
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/loadimpact/k6"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"k6"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
