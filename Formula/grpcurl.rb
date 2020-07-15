class Grpcurl < Formula
  desc "Like cURL, but for gRPC"
  homepage "https://github.com/fullstorydev/grpcurl"
  url "https://github.com/fullstorydev/grpcurl/archive/v1.6.1.tar.gz"
  sha256 "d070b5e6f038ab8fda7366bd9371108564c9e1cb22c3cc2041feaeefdca53587"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b98a32b63590b58f1e274f07bd38cc6593403cb472adeb40819664825d70bd2b" => :catalina
    sha256 "a6124dd05fb27cdfe7d645e8f3657aa977702111336d0ccc4aebafc2936470d2" => :mojave
    sha256 "c6973360fa628aabc725bfaa45b262e7a8656f3d218a0e84b4a98f26e5ac6197" => :high_sierra
    sha256 "478c7adfd2946f19db9a7a14b7767e66ab9dd7dd332433a0a755bba4752d829e" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/fullstorydev/grpcurl").install buildpath.children
    cd "src/github.com/fullstorydev/grpcurl/cmd" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
             "-o", bin/"grpcurl", "./..."
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      package test;
      message HelloWorld {
        string hello_world = 1;
      }
    EOS
    system "#{bin}/grpcurl", "-msg-template", "-proto", "test.proto", "describe", "test.HelloWorld"
  end
end
