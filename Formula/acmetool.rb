class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme.git",
      :tag      => "v0.0.67",
      :revision => "221ea15246f0bbcf254b350bee272d43a1820285"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "859ddcc717399c6724283beece51c0a93497e00be685d3f1cfb7153506cbd9bb" => :catalina
    sha256 "fd6d5e67865a1038fef6f4b183c255e42e4eb6470d5847e804639197f226da6b" => :mojave
    sha256 "62ec2c87880494488a50d78c36104f75eb97bb160ddf316387ab116e51ace2fd" => :high_sierra
    sha256 "ba229bae0e6e2e776ffafa7410ab56220375a55fa4ee2b0217866617038998ae" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "libcap" unless OS.mac?

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/hlandau").mkpath
    ln_sf buildpath, buildpath/"src/github.com/hlandau/acme"

    cd "cmd/acmetool" do
      # https://github.com/hlandau/acme/blob/master/_doc/PACKAGING-PATHS.md
      ldflags = %W[
        -X github.com/hlandau/acme/storage.RecommendedPath=#{var}/lib/acmetool
        -X github.com/hlandau/acme/hooks.DefaultPath=#{lib}/hooks
        -X github.com/hlandau/acme/responder.StandardWebrootPath=#{var}/run/acmetool/acme-challenge
        #{Utils.popen_read("#{buildpath}/src/github.com/hlandau/buildinfo/gen")}
      ]
      system "go", "build", "-o", bin/"acmetool", "-ldflags", ldflags.join(" ")
    end

    (man8/"acmetool.8").write Utils.popen_read(bin/"acmetool", "--help-man")

    doc.install Dir["_doc/*"]
  end

  def post_install
    (var/"lib/acmetool").mkpath
    (var/"run/acmetool").mkpath
  end

  test do
    assert_match "build unknown", shell_output("#{bin}/acmetool --version", 2)
  end
end
