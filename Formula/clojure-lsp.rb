class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    :tag      => "release-20200507T034423",
    :revision => "a1e30bc4c3d84f9cf6c8d5fe097eef2d25676796"
  version "20200507T034423"
  sha256 "7444795a6a9655ae8e1ec1df00392f24bad2a73a1f890353e2b7c98dca681061"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8c2eb2319c8f9d0ad7507827f53c6ae01e957f745f6c8e2281110b6c4fcc327" => :catalina
    sha256 "756545ad253835eaedd14519ac70d3e2fd92da17219a459ea371b727d2cd1505" => :mojave
    sha256 "34409b3621aa70222c80bafcb6e80b2b813cb29aef77ce447de31ab046eb6118" => :high_sierra
  end

  depends_on "leiningen" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on :java => "1.8"

  def install
    system "lein", "uberjar"
    jar = Dir["target/clojure-lsp-*-standalone.jar"][0]
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "clojure-lsp"
  end

  test do
    require "Open3"

    begin
      stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/clojure-lsp")
      pid = wait_thr.pid
      stdin.write <<~EOF
        Content-Length: 58

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Length", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
