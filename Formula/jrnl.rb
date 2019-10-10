# jrnl: Build a bottle for Linuxbrew
class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "https://jrnl.sh/"
  url "https://github.com/maebert/jrnl/archive/1.9.8.tar.gz"
  sha256 "ec9dcf01f67a2329218fcd090b56042379937b269ddbd8c0c64097636f012e63"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9e0a96ab3932c457b4fd476e3b7bdfd32956e31bb1b261c1fab34113834ec48a" => :catalina
    sha256 "e2535675419ec4769c229c7d468d9dd4139e14245286dd766a1eab8a650723a7" => :mojave
    sha256 "0325b924a82ce0153d3e9d683fc55190d154d45ee9279fc6d136f50506417af3" => :high_sierra
  end

  depends_on "python"

  unless OS.mac?
    depends_on "pkg-config"
    depends_on "expect" => :test

    resource "asn1crypto" do
      url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
      sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
    end

    resource "cffi" do
      url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
      sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
    end

    resource "cryptography" do
      url "https://files.pythonhosted.org/packages/07/ca/bc827c5e55918ad223d59d299fff92f3563476c3b00d0a9157d9c0217449/cryptography-2.6.1.tar.gz"
      sha256 "26c821cbeb683facb966045e2064303029d572a87ee69ca5a1bf54bf55f93ca6"
    end

    resource "jeepney" do
      url "https://files.pythonhosted.org/packages/16/1d/74adf3b164a8d19a60d0fcf706a751ffa2a1eaa8e5bbb1b6705c92a05263/jeepney-0.4.tar.gz"
      sha256 "6089412a5de162c04747f0220f6b2223b8ba660acd041e52a76426ca550e3c70"
    end

    resource "pycparser" do
      url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
      sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
    end

    resource "secretstorage" do
      url "https://files.pythonhosted.org/packages/a6/89/df343dbc2957a317127e7ff2983230dc5336273be34f2e1911519d85aeb5/SecretStorage-3.1.1.tar.gz"
      sha256 "20c797ae48a4419f66f8d28fc221623f11fc45b6828f96bdb1ad9990acb59f92"
    end
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/7c/c0/4f48b2b1ff9eec624624142e9be28a6c91b494fd1513df4ef7544da3886c/keyring-15.1.0.tar.gz"
    sha256 "6232b972dfbd44fd9bd649242dbf17f616988b152d4268f9ca1dcc704b467381"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/3d/94/5953839c03457054707cc72466af7728c0588ca0398d7cab3af40c624393/keyrings.alt-3.1.tar.gz"
    sha256 "b59c86b67b9027a86e841a49efc41025bcc3b1b0308629617b66b7011e52db5a"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/e3/b3/02385db13f1f25f04ad7895f35e9fe3960a4b9d53112775a6f7d63f264b6/parsedatetime-2.4.tar.gz"
    sha256 "3d817c58fb9570d1eec1dd46fa9448cd644eeed4fb612684b02dfda3a79cb84b"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/ca/a9/62f96decb1e309d6300ebe7eee9acfd7bccaeedd693794437005b9067b44/pytz-2018.5.tar.gz"
    sha256 "ffb9ef1de172603304d9d2819af6f5ece76f2e85ec10692a524dd876e72bf277"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/cb/89/e3687d3ed99bc882793f82634e9824e62499fdfdc4b1ae39e211c5b05017/tzlocal-1.5.1.tar.gz"
    sha256 "4ebeb848845ac898da6519b9b31879cf13b6626f7184c496037b818e238f2c4e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    expect = OS.mac? ? "#!/usr/bin/expect -f" : "#!/usr/bin/env expect"
    (testpath/"write_journal.sh").write <<~EOS
      #{expect}
      set timeout -1
      spawn #{bin}/jrnl today: Wrote this fancy test.
      expect -exact "Path to your journal file (leave blank for ~/journal.txt):"
      send -- "#{testpath}/journal\n"
      expect -exact "Enter password for journal (leave blank for no encryption): "
      send -- "Homebrew\n"
      expect "Do you want to store the password in your keychain?"
      send -- "N\n"
      expect -exact "Journal will be encrypted."
      expect "Entry added to default journal"
      expect eof
    EOS
    chmod 0755, testpath/"write_journal.sh"

    system "./write_journal.sh"
    assert_predicate testpath/"journal", :exist?
    assert_predicate testpath/".jrnl_config", :exist?
  end
end
