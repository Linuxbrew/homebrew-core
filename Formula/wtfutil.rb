# wtfutil: Build a bottle for Linux
class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.24.0",
    :revision => "a6468c585b11826a7d5284699571396499ab7aae"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f6feb0a3addc10a74c302dcf6a5461b42a8bd87aaef482c29b3b956e956a2812" => :catalina
    sha256 "c58e1677165b32fe2b100a97907f7d36616aa2dc1fead0300ce2930e6e7ae3d8" => :mojave
    sha256 "ebc23a9b8170d30ab4de6d36dee2d4b117539dfd6038a4bfd3325b36ec99201e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPROXY"] = "https://gocenter.io"
    ldflags=["-s -w -X main.version=#{version}",
             "-X main.date=#{Time.now.iso8601}"]
    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"wtfutil"
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~EOS
      wtf:
        colors:
          background: "red"
          border:
            focusable: "darkslateblue"
            focused: "orange"
            normal: "gray"
          checked: "gray"
          highlight:
            fore: "black"
            back: "green"
          text: "white"
          title: "white"
        grid:
          # How _wide_ the columns are, in terminal characters. In this case we have
          # six columns, each of which are 35 characters wide
          columns: [35, 35, 35, 35, 35, 35]

          # How _high_ the rows are, in terminal lines. In this case we have five rows
          # that support ten line of text, one of three lines, and one of four
          rows: [10, 10, 10, 10, 10, 3, 4]
        navigation:
          shortcuts: true
        openFileUtil: "open"
        sigils:
          checkbox:
            checked: "x"
            unchecked: " "
          paging:
            normal: "*"
            selected: "_"
        term: "xterm-256color"
    EOS

    begin
      pid = fork do
        exec "#{bin}/wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end
