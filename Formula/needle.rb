class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      :tag      => "v0.14.0",
      :revision => "626bcbb2751ae314850faa54484294dd660e9c70"

  bottle do
    cellar :any_skip_relocation
    sha256 "132af30901a4e01be38ad70d7b1197e5aa254c5cf72e426df4a44082a35d4f7e" => :catalina
    sha256 "f003548f6d43b6e3875f760e3ddc5316d1c64775950d84ca3b5b7d93beee250c" => :mojave
    sha256 "447f064214957ab45da2ac82b388a43913ba293c2112a735d77117f0e4faff92" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
