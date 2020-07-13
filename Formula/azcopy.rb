class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.5.0.tar.gz"
  sha256 "88b550ee4d09fac1bec1edccb8fb52f4b7fcaae4909a97280af2baa3b179cb8e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eaf3f28362411b14204b93635bedfbd82dd7395a00c58b5e252722a5780088d" => :catalina
    sha256 "b95663369d98848d1731b46e7d52211f4b2ffa34091626aa896d9bb81cfaf1e4" => :mojave
    sha256 "55db871f3b5dd6d5f32e5f9614fefbd64dce550089904b64534443647c254cf7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
