class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.25",
    revision: "fe9ae6a689918107a65d4f992efc59af3c99f83f"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/efm-langserver", "-h"
  end
end
