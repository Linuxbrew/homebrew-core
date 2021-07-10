class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20210621.tar.xz"
  sha256 "2b94b0d92dc7aa43a20dc4ebf2460c7b303ee5fbaffbab9d9ed296ce99774219"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a66b32ea6bd90d92638c64e5a909eae512b04124e247c0e6bad501e3b5e00749" # linuxbrew-core
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", cached_download
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
