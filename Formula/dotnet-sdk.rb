class DotnetSdk < Formula
  desc "Software Development Kit for .NET Core"
  homepage "https://dotnet.microsoft.com"
  url "https://download.visualstudio.microsoft.com/download/pr/5e92f45b-384e-41b9-bf8d-c949684e20a1/67a98aa2a4e441245d6afe194bd79b9b/dotnet-sdk-2.2.300-linux-x64.tar.gz"
  version "2.2.300"
  sha256 "d28e21bb63bdc3cd778a1ad2f376164bd87b9d734f542d77a033ac250339c45c"

  def install
    pkgshare.install "host"
    pkgshare.install "shared"
    pkgshare.install "sdk"
    pkgshare.install "dotnet"
    bin.install_symlink pkgshare/"dotnet"
  end

  test do
    assert_equal shell_output("#{bin}/dotnet --version"), version
  end
end
