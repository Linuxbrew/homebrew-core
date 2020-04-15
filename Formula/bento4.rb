class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-632.zip"
  version "1.6.0-632"
  sha256 "faa3a406dc24c3d34d29661bbbe94b42c7f7deee9a5c624696a055bb9b7da6ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "f90b47d477917e0f567895dd96ce1f08ace1ac04719451f12cabd29f5e38aec8" => :catalina
    sha256 "8e2127cf58ec07d5c6a735072f875c458c96115b9859161e46e1a632e59547d2" => :mojave
    sha256 "d874fe1f7f65ff3a48c09b63f0dcbe5eb9a77d182165370772861d219cdbd0d2" => :high_sierra
  end

  depends_on "cmake" => :build unless OS.mac?
  depends_on :xcode => :build if OS.mac?
  depends_on "python"

  conflicts_with "gpac", :because => "both install `mp42ts` binaries"
  conflicts_with "mp4v2",
    :because => "both install `mp4extract` and `mp4info` binaries"

  def install
    if OS.mac?
      cd "Build/Targets/universal-apple-macosx" do
        xcodebuild "-target", "All", "-configuration", "Release", "SYMROOT=build"
        programs = Dir["build/Release/*"].select do |f|
          next if f.end_with? ".dylib"
          next if f.end_with? "Test"

          File.file?(f) && File.executable?(f)
        end
        bin.install programs
      end
    else
      mkdir "cmakebuild" do
        system "cmake", "..", *std_cmake_args
        system "make"
        programs = Dir["./*"].select do |f|
          File.file?(f) && File.executable?(f)
        end
        bin.install programs
      end
    end

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
