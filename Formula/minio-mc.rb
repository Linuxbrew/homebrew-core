class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-07-11T05-18-52Z",
      :revision => "1513d76ca9d3a2cddda40d0e6e50be164b894889"
  version "20200711051852"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "90a2778d25e46550bce6118d8a9eb322c5cfce8cbbef43eb7bd677b84359a229" => :catalina
    sha256 "cf3ee2ffbc976df8fa698bc726a13c9940873afea43a53637573fe7e3b152afd" => :mojave
    sha256 "45c7620f6cf8933139966b01a4a0a01cbf821cdeaae25364d40facc449a63fe1" => :high_sierra
    sha256 "decf6d2f7a6c03c992f783ba1084faf919f7cf25144bd9c71df37b8c1e56d2bb" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      minio_commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{minio_commit}
      EOS
    end

    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
