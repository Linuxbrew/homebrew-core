class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.07.00.tar.gz"
  sha256 "77c0ec591dc3ea76cf57c60a5d7c73b6c0d66cca1fa7c4eb25a9071e8fc67e60"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46bb03f5f7bea2e59de7cfe84ca92baad894c1ef19a8bb70cd49f2efcc2e087a"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b7fdab117eb811c70f44ecedceaf71bd6c1bfcb14930f7d5daa9ed6dd4e41bf"
    sha256 cellar: :any_skip_relocation, catalina:      "4d90638bad7723e4d1fa90fd3078018eea5472197569a40540c8bcc4f9b05620"
    sha256 cellar: :any_skip_relocation, mojave:        "0345d6cee16212fd72011a4910c5ffa57b37c6f1768198faf32ff526fbbd630c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30ca014137a0a09b3b84f17ade682974ef6f4e7ec4dabd9102be868088ee5c9f" # linuxbrew-core
  end

  depends_on "cmake" => :build

  def install
    cd "tools/numdiff" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lhs.txt").write("0.0 2e-3 0.003")
    (testpath/"rhs.txt").write("1e-7 0.002 0.003")
    (testpath/"test.cfg").write("*   * abs=1e-6")
    system "#{bin}/ndiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end
