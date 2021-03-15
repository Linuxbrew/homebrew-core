class OpenshiftCli < Formula
  desc "Red Hat OpenShift command-line interface tool"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.7.2/openshift-client-linux-4.7.2.tar.gz"
  sha256 "e52795752079527824f7deae88996045ac67e7078eb4331a0793deae7d6500b7"
  license "Apache-2.0"

  depends_on "kubernetes-cli"

  bottle :unneeded

  def install
    bin.install "oc"
  end

  test do
    run_output = shell_output("#{bin}/oc 2>&1")
    assert_match "OpenShift Client", run_output
  end
end
