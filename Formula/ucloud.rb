class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.36.tar.gz"
  sha256 "c2594b9d277d50857c9a2ca54d52985138f8672da2aa02c692790a3622a3bdf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4369a8339dfade60520aa14d54f228aa50eaa477131b0cb930d26d49fd1c6cab"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6501723daea0bcf02429ebbe424acbcd03b3e26529be6396cda2d31099f4607"
    sha256 cellar: :any_skip_relocation, catalina:      "a402128a3fba94e3c08cd67e716c3f33852d138af48897db5cdf883b0de59441"
    sha256 cellar: :any_skip_relocation, mojave:        "92bfe9c9fd15143c837bece7bc88296a4287977e156173248b6903dc4e6b817c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d06f78749df5a802fd63f3b6ea5c979eda6386fa4d76c93d39dbdcce3a16e7d" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
