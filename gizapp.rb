require 'formula'

class Gizapp < Formula
  homepage 'https://code.google.com/p/giza-pp/'
  url 'https://giza-pp.googlecode.com/files/giza-pp-v1.0.7.tar.gz'
  sha1 'a808248127d91f12a8513bfd4b4e06c0d7ef1e48'

  def install
    system 'make'
    bin.install 'GIZA++-v2/GIZA++'
    bin.install 'GIZA++-v2/plain2snt.out'
    bin.install 'GIZA++-v2/snt2cooc.out'
    bin.install 'GIZA++-v2/snt2plain.out'
    bin.install 'GIZA++-v2/trainGIZA++.sh'
    bin.install 'mkcls-v2/mkcls'
  end

  fails_with :clang do
    build 503
    cause <<-EOS.undent
      Requires tr1 headers, which are not present in Clang's libc++.
    EOS
  end

  test do
    system bin/'GIZA++', '--help'
  end
end
