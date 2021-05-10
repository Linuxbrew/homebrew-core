class DjangoCompletion < Formula
  desc "Bash completion for Django"
  homepage "https://www.djangoproject.com/"
  url "https://github.com/django/django/archive/3.2.2.tar.gz"
  sha256 "20723bbad6c7206d128894926e5d694f3a5041ae76c81949ce9b622c723730a9"
  license "BSD-3-Clause"
  head "https://github.com/django/django.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  def install
    bash_completion.install "extras/django_bash_completion" => "django"
  end

  test do
    assert_match "-F _django_completion",
      shell_output("source #{bash_completion}/django && complete -p django-admin.py")
  end
end
