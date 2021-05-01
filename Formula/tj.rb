class Tj < Formula
  desc "Line timestamping tool"
  homepage "https://github.com/sgreben/tj"
  url "https://github.com/sgreben/tj/archive/7.0.0.tar.gz"
  sha256 "6f9f988a05f9089d2a96edd046d673392d6fac2ea74ff0999b2f0428e9f72f7f"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:     "ab9e94d37b842d4d96e8a1ce0e6a87b7d5f333467662bf311f4a23a6a05d3088"
    sha256 cellar: :any_skip_relocation, mojave:       "9e9789735a9437803ccadf92845d8bfb2f85e11429fb97e195c01fb2887cf045"
    sha256 cellar: :any_skip_relocation, high_sierra:  "6e47b0d410b1a9aafc4b31bf6f397e5b6194faf2aea88e0fc0f45a4584adbf37"
    sha256 cellar: :any_skip_relocation, sierra:       "f62d1e6bebec485f947355a7a0a79fd9f3986396ac5f79c96e630693533a5c9d"
    sha256 cellar: :any_skip_relocation, el_capitan:   "679f41ee55f109604f19583683f43406e4af88f86b60534ab4e758d5b2192940"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c7486821bd35ae016c533c2b8a49839ede4754bf2405e5f192a431dc8b50fa99"
  end

  # https://github.com/sgreben/tj/issues/5
  disable! date: "2020-08-02", because: :no_license

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/sgreben/tj").install buildpath.children
    cd "src/github.com/sgreben/tj" do
      system "make", "binaries/osx_x86_64/tj"
      bin.install "binaries/osx_x86_64/tj"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"tj", "test"
  end
end
