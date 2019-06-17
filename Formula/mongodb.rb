class Mongodb < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.com/"
  # do not upgrade to versions >4.0.3 as they are under the SSPL which is not
  # an open-source license.
  url "https://fastdl.mongodb.org/src/mongodb-src-r4.0.3.tar.gz"
  sha256 "fbbe840e62376fe850775e98eb10fdf40594a023ecf308abec6dcec44d2bce0c"
  revision 1

  bottle do
    cellar :any
    sha256 "ab08fc6748bc37d0e2ec209126db3236bd80a2ae4edee2f6fc34d96481fe34c7" => :mojave
    sha256 "482cafb558d39fd6cae4d5d1abe07c7329a94b961fca00dc3ae71dc3be34deb9" => :high_sierra
    sha256 "0b98be90831544f051d8244c253f61dd98a5d6f421663c3353b34feef562eae7" => :sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on :xcode => ["8.3.2", :build] if OS.mac?

  depends_on "openssl"
  depends_on "python@2"

  unless OS.mac?
    depends_on "curl"
    depends_on "pkg-config" => :build
    depends_on "libpcap"
  end

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/bf/9b/2bf84e841575b633d8d91ad923e198a415e3901f228715524689495b4317/typing-3.6.6.tar.gz"
    sha256 "4027c5f6127a6267a435201981ba156de91ad0d1d98e9ddc2aa173453453492d"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["HOMEBREW_MAKE_JOBS"] = "6" if ENV["CIRCLECI"]

    ENV.libcxx

    ["Cheetah", "PyYAML", "typing"].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(buildpath/"vendor")
      end
    end
    (buildpath/".brew_home/Library/Python/2.7/lib/python/site-packages/vendor.pth").write <<~EOS
      import site; site.addsitedir("#{buildpath}/vendor/lib/python2.7/site-packages")
    EOS

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    cd "src/mongo/gotools" do
      unless OS.mac?
        inreplace "vendor/src/github.com/google/gopacket/pcap/pcap.go", "_Ctype_struct_", "C.struct_"
      end

      inreplace "build.sh" do |s|
        s.gsub! "$(git describe)", version.to_s
        s.gsub! "$(git rev-parse HEAD)", "homebrew"
      end
      ENV["CPATH"] = Formula["openssl"].opt_include
      ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
      unless OS.mac?
        ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
        ENV["CPATH"] = Formula["openssl"].opt_include
        ENV["CGO_CPPFLAGS"] = "-I " + Formula["libpcap"].opt_include
        ENV["CGO_LDFLAGS"] = "-L " + Formula["libpcap"].opt_lib
      end
      ENV["GOROOT"] = Formula["go"].opt_libexec
      system "./build.sh", "ssl"
    end

    (buildpath/"src/mongo-tools").install Dir["src/mongo/gotools/bin/*"]

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      --build-mongoreplay=true
      --disable-warnings-as-errors
      --use-new-tools
      --ssl
      CCFLAGS=-I#{Formula["openssl"].opt_include}
      LINKFLAGS=-L#{Formula["openssl"].opt_lib}
    ]

    system "scons", "install", *args

    (buildpath/"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    # Reduce the size of the bottle.
    system "strip", *Dir[bin/"*"] unless OS.mac?
  end

  def post_install
    (var/"mongodb").mkpath
    (var/"log/mongodb").mkpath
  end

  def mongodb_conf; <<~EOS
    systemLog:
      destination: file
      path: #{var}/log/mongodb/mongo.log
      logAppend: true
    storage:
      dbPath: #{var}/mongodb
    net:
      bindIp: 127.0.0.1
  EOS
  end

  plist_options :manual => "mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mongod</string>
        <string>--config</string>
        <string>#{etc}/mongod.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end
