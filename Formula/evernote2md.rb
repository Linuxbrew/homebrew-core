class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.16.0.tar.gz"
  sha256 "76fbb62ddd35606c5bf8433d2d66b7dc79d87f151d66c06cf4eeb9b99322c5cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4db79a590dcde9423b01f3e6cb6035121e78c73850b1cbb3ff277c2226a41616"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4b2f93ca3a8d6ab5821a8da025d48c97c6f1ea88a7e18274c31a1dbd516fa7c"
    sha256 cellar: :any_skip_relocation, catalina:      "0bf0d3d24a59ec90f717c6b36c6fcfc6a8874b47ac45b603c533520b9a833f9a"
    sha256 cellar: :any_skip_relocation, mojave:        "6ade81031fc09a19e69d42d25325dd3489f0353aafd66dc8163030ee1d153157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17e32f25d60dc408c93e8d34bdfa7f3336b4722fc44171e6b27871f5264289c7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}"
  end

  test do
    (testpath/"export.enex").write <<~EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export3.dtd">
      <en-export>
        <note>
          <title>Test</title>
          <content>
            <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><div><br /></div></en-note>]]>
          </content>
        </note>
      </en-export>
    EOF
    system bin/"evernote2md", "export.enex"
    assert_predicate testpath/"notes/Test.md", :exist?
  end
end
