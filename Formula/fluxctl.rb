# fluxctl: Build a bottle for Linux
class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.16.0",
      :revision => "876f994ac2868a9887362c128dc4c55c4674c81d"

  bottle do
    cellar :any_skip_relocation
    sha256 "af2d6e040da3865b720aff241b91d17a990d85dc3af393d9af6dab7d2666265c" => :catalina
    sha256 "99864875ebc4964465d2a2afbf8316127067f9d7e79112426de34af55545de54" => :mojave
    sha256 "45a8b61efeb0e3db81ed67c13dbf3b5302ee12322444a2e0d8b5b81c7acaa910" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/weaveworks/flux"
    dir.install buildpath.children

    cd dir/"cmd/fluxctl" do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"fluxctl"
      prefix.install_metafiles
    end
  end

  test do
    run_output = shell_output("#{bin}/fluxctl 2>&1")
    assert_match "fluxctl helps you deploy your code.", run_output

    version_output = shell_output("#{bin}/fluxctl version 2>&1")
    assert_match version.to_s, version_output

    # As we can't bring up a Kubernetes cluster in this test, we simply
    # run "fluxctl sync" and check that it 1) errors out, and 2) complains
    # about a missing .kube/config file.
    require "pty"
    require "timeout"
    r, _w, pid = PTY.spawn("#{bin}/fluxctl sync", :err=>:out)
    begin
      Timeout.timeout(5) do
        assert_match r.gets.chomp, "Error: Could not load kubernetes configuration file: invalid configuration: no configuration has been provided"
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
