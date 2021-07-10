class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.0.0/php-cs-fixer.phar"
  sha256 "993f3d300db32c4158891bc8a13a7f91f7dac85ce4eda209b3582f0e329b3990"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "91cf3e6eb54e66d87f295bcf2ad684af9540a2443477f415a3bc61ad2302f92a" # linuxbrew-core
  end

  uses_from_macos "php", since: :mojave

  def install
    bin.install "php-cs-fixer.phar" => "php-cs-fixer"
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
