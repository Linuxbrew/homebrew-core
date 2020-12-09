class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.4.0.tar.gz"
  sha256 "a5e0e923e6ddc087f6a4487499eadb9014d1e32ed4495bb10b663b9216495fab"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "611eca0461a36721a4ca8459a97bfa550dd55cad396545a7149e4c32d0072906" => :big_sur
    sha256 "ed3b1c70f396fa6858008614fdaaa93bf97332ffdb8299e462d58bf131cb8c95" => :catalina
    sha256 "d96f680abdc31d252a1da824124fb7d502fd2ce593d893488288cd8de73383e3" => :mojave
    sha256 "e2fc650c879493c5a7f7309cc021d424a1acd1c3c7055838393191e1f5ae6934" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    system "#{bin}/draco_encoder", "-i", "#{pkgshare}/cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath/"cube_att.drc", :exist?
  end
end
