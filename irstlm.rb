require 'formula'

class Irstlm < Formula
  homepage 'https://sourceforge.net/projects/irstlm/'
  url 'https://downloads.sourceforge.net/project/irstlm/irstlm/irstlm-5.80/irstlm-5.80.03.tgz'
  sha1 'd92d048b924fde228811c81c030bf99e0ae832a9'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  patch :DATA

  fails_with :clang do
    build 503
    cause 'Uses nonstandard variable-length arrays in mdiadapt.cpp.'
  end

  def install
    system './regenerate-makefiles.sh'
    system './configure', "--prefix=#{prefix}"
    system 'make'
    system 'make', 'install'
  end

  def caveats
    <<-EOS.undent
      This formula patches `build-lm.sh` to set the "IRSTLM" environment
      variable to the Homebrew prefix by default, so that it does not need to
      be specified on the command line unless it is being overridden.
    EOS
  end

  test do
    require 'open3'

    corpus = "<s> lorem ipsum dolor sit amet </s>\n"
    File.open('lipsum', 'w') { |f| f.write(corpus) }
    system bin/'build-lm.sh', '-i', 'lipsum', '-o', 'lipsum-lm'
    Open3.popen3(bin/'score-lm', '-lm', 'lipsum-lm') do |stdin, stdout, stderr|
      stdin.write(corpus)
      stdin.close
      assert_equal '-49', stdout.read.strip
    end
  end
end

__END__
diff --git a/scripts/build-lm.sh b/scripts/build-lm.sh
index 4ee4fcf..57080cf 100755
--- a/scripts/build-lm.sh
+++ b/scripts/build-lm.sh
@@ -29,10 +29,7 @@ OPTIONS:
 EOF
 }

-if [ ! $IRSTLM ]; then
-   echo "Set IRSTLM environment variable with path to irstlm"
-   exit 2
-fi
+IRSTLM=${IRSTLM:-HOMEBREW_PREFIX}

 #paths to scripts and commands in irstlm
 scr=$IRSTLM/bin
