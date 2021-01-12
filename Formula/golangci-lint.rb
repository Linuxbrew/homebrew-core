class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.35.2",
      revision: "1da57014f928ec8d56fd240388a8c594a0534a46"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4cafc48029c23905166e074edbb52eec72d4bf1906b329ee21951a21489de32" => :big_sur
    sha256 "162646975e25eeb6389c5c23ecc18d2bd96e848e998646a3e96d508a567ed2fb" => :arm64_big_sur
    sha256 "1aa34b8b1b5fbfda2054c4dc9747a4a6c0fe04ff2d58517216e07ec26d280037" => :catalina
    sha256 "a1cbc50471307ab478291578587b518266178ba07bf2af2818d3d0982c652057" => :mojave
  end

  depends_on "go"

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short=7", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
      -X main.date=#{Time.now.utc.rfc3339}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/golangci-lint"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/golangci-lint", "completion", "bash")
    (bash_completion/"golangci-lint").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/golangci-lint", "completion", "zsh")
    (zsh_completion/"golangci-lint").write output
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match "golangci-lint has version #{version} built from", str_version

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output("#{bin}/golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~EOS
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        return
      }
    EOS

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=deadcode
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: `add` is unused (deadcode)"
    assert_match expected_message, ok_test
  end
end
