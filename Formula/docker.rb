class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      tag:      "v19.03.14",
      revision: "5eb3275d4006e4093807c35b4f7776ecd73b13a7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "64884b9e13687a220fd366ae8df4680f194a50ba4d23324c6bb6b63cbcfbfcc5" => :big_sur
    sha256 "cbc4047dc077e14c83d7da336cb686abb1446a8b0e63489885456301936f014c" => :catalina
    sha256 "b08cf7b49df08e895562a0395b71622c78dcd163c55b4f87d6ccb4cf49324538" => :mojave
    sha256 "eb2813e8beff37afd37862f1393af6cbf98cd0c5e3a20c5a2cccefbead2017ce" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"components/cli").children
    cd dir do
      commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp
      build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp
      ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{build_time}\"",
                 "-X github.com/docker/cli/cli/version.GitCommit=#{commit}",
                 "-X github.com/docker/cli/cli/version.Version=#{version}",
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]
      system "go", "build", "-o", bin/"docker", "-ldflags", ldflags.join(" "),
             "github.com/docker/cli/cmd/docker"

      Pathname.glob("man/*.[1-8].md") do |md|
        section = md.to_s[/\.(\d+)\.md\Z/, 1]
        (man/"man#{section}").mkpath
        system "go-md2man", "-in=#{md}", "-out=#{man/"man#{section}"/md.stem}"
      end

      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")
    # Fails on CI: WARNING: No swap limit support
    assert_match "ERROR: Cannot connect to the Docker daemon", shell_output("#{bin}/docker info", 1) if OS.mac?
  end
end
