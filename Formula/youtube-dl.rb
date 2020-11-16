class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/e5/1f/a9e2ec4219761bb9ec568fb5457bd870627c2556d6bd2ce8cdbea8694cde/youtube_dl-2020.11.12.tar.gz"
  sha256 "1491df1707f47207bfd47dd8497d26e9125dd9e4fe2e00780103d4c1b4b2088d"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fc5f54b3319c10a1625d08c580b6faf9445307acf0df642a6fc73ae8a88ee41" => :big_sur
    sha256 "4c71c4df2322e5a31e36123d529031b7af2e6626f94bfa79857835df40c7a589" => :catalina
    sha256 "ede378615a66acc53a13a07b6ee4384ac74decb832179b8893a70ae550c73712" => :mojave
    sha256 "a5bb66156c7c2d8a8beff32358efb1bc342514397e13be4eaf7b05c6cae0b54e" => :high_sierra
    sha256 "69f43c4136244bef330172ed8452468f6d5ce85085734849a1e2d1466bff1c72" => :x86_64_linux
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
