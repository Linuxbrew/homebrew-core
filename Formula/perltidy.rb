class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/perltidy/20201202/Perl-Tidy-20201202.tar.gz"
  sha256 "20a5e4bd0bbb4a20f4d611eec08679bbac00c8b8ba03f4deda646f8ea1770b64"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0b04785db0c33390fe7fb5e3d3e2fd759fa3a7694003ea582651c65d7115ecec" => :big_sur
    sha256 "2c6fe606b20fcc2128d2472fe06aacb8f16fa10f11d071d4aa95c523634a4890" => :catalina
    sha256 "02a768bde62bdea9d498808379c317addabf22349e3191cadb21bb313058be66" => :mojave
    sha256 "9788eaccbae4c8c343ab31bd5f814e80b9110c1353b3adc2f731f7f076b1a89f" => :x86_64_linux
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath/"testfile.pl").write <<~EOS
      print "Help Desk -- What Editor do you use?";
      chomp($editor = <STDIN>);
      if ($editor =~ /emacs/i) {
        print "Why aren't you using vi?\n";
      } elsif ($editor =~ /vi/i) {
        print "Why aren't you using emacs?\n";
      } else {
        print "I think that's the problem\n";
      }
    EOS
    system bin/"perltidy", testpath/"testfile.pl"
    assert_predicate testpath/"testfile.pl.tdy", :exist?
  end
end
