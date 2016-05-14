# bash-completion: Build a bottle for Linuxbrew
# NOTE: version 2.0 is out, but it requires Bash 4, and OS X ships
# with 3.2.48. See homebrew-versions for a 2.0 formula.
class BashCompletion < Formula
  desc "Programmable bash completion"
  homepage "https://bash-completion.alioth.debian.org/"
  url "https://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/bash-completion/bash-completion-1.3.tar.bz2/a1262659b4bbf44dc9e59d034de505ec/bash-completion-1.3.tar.bz2"
  sha256 "8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "aaa0801956062f69a0e1c2c5214c110ef86828474508a3b4925f5e1cf11b0ce5" => :el_capitan
    sha256 "aca381fd5650b1d0ef886d824f1846e4934b6dc7eaf062a6be4bc17251245af3" => :yosemite
    sha256 "a0d3a54b78334afcc9b5d1aed935a1b87b2398ef4c588f98d6a61dedc8c6fa32" => :mavericks
  end

  # Backports the following upstream patch from 2.x:
  # https://anonscm.debian.org/gitweb/?p=bash-completion/bash-completion.git;a=commitdiff_plain;h=50ae57927365a16c830899cc1714be73237bdcb2
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740971
  patch :DATA

  def compdir
    etc/"bash_completion.d"
  end

  def install
    inreplace "bash_completion" do |s|
      s.gsub! "/etc/bash_completion", etc/"bash_completion"
      s.gsub! "readlink -f", "readlink"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add the following lines to your ~/.bash_profile:
      if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
      fi

    Homebrew's own bash completion script has been installed to
      #{compdir}
    EOS
  end

  test do
    system "bash", "-c", ". #{etc}/profile.d/bash_completion.sh"
  end
end

__END__
diff --git a/bash_completion b/bash_completion
index 6601937..5184767 100644
--- a/bash_completion
+++ b/bash_completion
@@ -640,7 +640,7 @@

     _quote_readline_by_ref "$cur" quoted
     toks=( ${toks[@]-} $(
-        compgen -d -- "$quoted" | {
+        compgen -d -- "$cur" | {
             while read -r tmp; do
                 # TODO: I have removed a "[ -n $tmp ] &&" before 'printf ..',
                 #       and everything works again. If this bug suddenly
@@ -1334,7 +1334,7 @@ _known_hosts_real()
 
     # append any available aliases from config files
     if [[ ${#config[@]} -gt 0 && -n "$aliases" ]]; then
-        local hosts=$( sed -ne 's/^[ \t]*[Hh][Oo][Ss][Tt]\([Nn][Aa][Mm][Ee]\)\{0,1\}['"$'\t '"']\{1,\}\([^#*?]*\)\(#.*\)\{0,1\}$/\2/p' "${config[@]}" )
+        local hosts=$( sed -ne 's/^[[:blank:]]*[Hh][Oo][Ss][Tt]\([Nn][Aa][Mm][Ee]\)\{0,1\}[[:blank:]]\{1,\}\([^#*?]*\)\(#.*\)\{0,1\}$/\2/p' "${config[@]}" )
         COMPREPLY=( "${COMPREPLY[@]}" $( compgen  -P "$prefix$user" \
             -S "$suffix" -W "$hosts" -- "$cur" ) )
     fi
