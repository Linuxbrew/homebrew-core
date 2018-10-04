class Vagrant < Formula
  desc "Command-line utility for managing the lifecycle of virtual machines"
  homepage "https://www.vagrantup.com/"
  url "https://releases.hashicorp.com/vagrant/2.1.5/vagrant_2.1.5_linux_amd64.zip"
  version "2.1.5"
  sha256 "42e83e075d70045214f72448f514bef969b9a107a63eef7f39fc31e4e75dd10a"

  def install
    bin.install "vagrant"
  end
end
