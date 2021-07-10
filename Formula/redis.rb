class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-6.2.4.tar.gz"
  sha256 "ba32c406a10fc2c09426e2be2787d74ff204eb3a2e496d87cff76a476b6ae16e"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "097941b5d4c9845b3006820798b23a6599de86a6c837b57a8a723af5e448d346"
    sha256 cellar: :any,                 big_sur:       "358fa4d16ce86681ad8a738ea97bcae82528f410a2ae5867350358e03109a715"
    sha256 cellar: :any,                 catalina:      "37ae1b9a121da9058048d2d439d6bcf1854752126d0d9895e0b908e3505deed7"
    sha256 cellar: :any,                 mojave:        "ecea2980c852e3af9f5b82c1c96c5180ef32f04efaf9c428b25c4b2d6dbffe1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d7f5090873433e893f511365effcf100898ae2a6b6f4e82f027cda37d5e8cfd" # linuxbrew-core
  end

  depends_on "openssl@1.1"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf"]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
