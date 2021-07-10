class Sbtenv < Formula
  desc "Command-line tool for managing sbt environments"
  homepage "https://github.com/sbtenv/sbtenv"
  url "https://github.com/sbtenv/sbtenv/archive/version/0.0.24.tar.gz"
  sha256 "f483769e5467c718c9de72baa4eb3c679315e4f4a9ac02bb636996a63c28e3d5"
  license "MIT"
  head "https://github.com/sbtenv/sbtenv.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64c22abd316bf9432dbe261087ea9bc89294441a3879501239759b3aec7abae1" # linuxbrew-core
  end

  def install
    inreplace "libexec/sbtenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    %w[sbtenv-install].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/sbt-install/bin/#{cmd}"
    end
  end

  def post_install
    var_lib = HOMEBREW_PREFIX/"var/lib/sbtenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    (var_lib/"plugins").install_symlink "#{prefix}/default-plugins/sbt-install"
  end

  test do
    shell_output("eval \"$(#{bin}/sbtenv init -)\" && sbtenv versions")
  end
end
