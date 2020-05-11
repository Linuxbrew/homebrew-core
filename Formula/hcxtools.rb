class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.0.2.tar.gz"
  sha256 "963029bf00d3a98f2caa934d5765a91e29f5d1b0e0036a4c53328b5cf9c3c003"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    cellar :any
    sha256 "2cc7082a49f45dcdbd368044a16cc569ec208fbd4efbf5a419e3adac9cd8c0ca" => :catalina
    sha256 "1d5c0d72c0780e8cde71e56b841ea6494f053f71f5dad5092f526868c5ae230c" => :mojave
    sha256 "d53de9bf0fdeb662804bf9bcdfdbd3d6fca89980e3454664acc7106212164fc1" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Create file with 22000 hash line
    testhash = testpath/"test.22000"
    (testpath/"test.22000").write <<~EOS
      WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***
    EOS

    # Convert hash to .cap file
    testcap = testpath/"test.cap"
    system "#{bin}/hcxhash2cap", "--pmkid-eapol=#{testhash}", "-c", testpath/"test.cap"

    # Convert .cap file back to hash file
    newhash = testpath/"new.22000"
    system "#{bin}/hcxpcapngtool", "-o", newhash, testcap

    # Diff old and new hash file to check if they are identical
    system "diff", newhash, testhash
  end
end
