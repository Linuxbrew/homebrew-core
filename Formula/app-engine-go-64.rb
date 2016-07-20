class AppEngineGo64 < Formula
  desc "Google App Engine SDK for Go (AMD64)"
  homepage "https://cloud.google.com/appengine/docs/go/"
  if OS.mac?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.38.zip"
    sha256 "f24625214fa5e77d83b0af69e1f422c58a0b4a9842c4e30a265e572d3b91aecf"
  elsif OS.linux?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.38.zip"
    sha256 "40e922b88779beb91b8f7f16cacf87a435aed73de36a116089f3bd60addb0400"
  end

  bottle :unneeded

  conflicts_with "app-engine-go-32",
    :because => "both install the same binaries"
  conflicts_with "app-engine-python",
    :because => "both install the same binaries"

  def install
    pkgshare.install Dir["*"]
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py goapp
    ].each do |fn|
      bin.install_symlink pkgshare/fn
    end
    (pkgshare/"goroot/pkg").install_symlink pkgshare/"goroot/pkg/darwin_amd64_appengine" => "darwin_amd64"
  end

  test do
    assert_match(/^usage: goapp serve/, shell_output("#{bin}/goapp help serve").strip)
  end
end
