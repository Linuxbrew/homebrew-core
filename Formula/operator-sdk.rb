class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      :tag      => "v0.19.0",
      :revision => "8e28aca60994c5cb1aec0251b85f0116cc4c9427"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 "e2ed290dd01c18068bf0bb44ae4eb442bea434131d8674d2fb60273e795e0252" => :catalina
    sha256 "3ac96997fd98ba180d0da26c06cfd26a4b3bb7163043eb50a8c74f0e1affed93" => :mojave
    sha256 "e457bcb3b637b66c0e7ffbd07f232775faa58bdc50a6a7cfd6f099799b8745e0" => :high_sierra
    sha256 "8dae1325b2676efae81be8ac20f85901a0de4aaba7154dc1f9f5033c0e42dce6" => :x86_64_linux
  end

  depends_on "go"

  def install
    # TODO: Do not set GOROOT. This is a fix for failing tests when compiled with Go 1.13.
    # See https://github.com/Homebrew/homebrew-core/pull/43820.
    ENV["GOROOT"] = Formula["go"].opt_libexec

    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/operator-framework/operator-sdk"
    dir.install buildpath.children - [buildpath/".brew_home"]
    dir.cd do
      # Make binary
      system "make", "install"
      bin.install buildpath/"bin/operator-sdk"

      # Install bash completion
      output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "bash")
      (bash_completion/"operator-sdk").write output

      # Install zsh completion
      output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "zsh")
      (zsh_completion/"_operator-sdk").write output

      prefix.install_metafiles
    end
  end

  test do
    # Use the offical golang module cache to prevent network flakes and allow
    # this test to complete before timing out.
    ENV["GOPROXY"] = "https://proxy.golang.org"

    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      assert_match stable.specs[:revision], version_output
    end

    # Create an example AppService operator. This exercises most of the various pieces
    # of generation logic.
    args = ["--type=ansible", "--api-version=app.example.com/v1alpha1", "--kind=AppService"]
    system "#{bin}/operator-sdk", "new", "test", *args
    assert_predicate testpath/"test/requirements.yml", :exist?
  end
end
