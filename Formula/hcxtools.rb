class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.1.4.tar.gz"
  sha256 "9bd55014f8f535fa192c29b76c0fd3550210c7b6625dc73a06eecb52df1942a8"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git"

  bottle do
    cellar :any
    sha256 "4ac2701c280d72e1d47df83a5427d37fe4c616ff21d9df2e8ab5d88f30947404" => :big_sur
    sha256 "82513d7ab36ea35c5b9899630bba673f0017c36a2162614714cf8be505d0fea6" => :catalina
    sha256 "0f7a126b9cef14368f13a494ed1465668ba83f6050e0b5d778adea34fdc795ab" => :mojave
  end

  depends_on "openssl@1.1"

  def install
    bin.mkpath
    man1.mkpath
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
