require 'formula'

class FastAlign < Formula
  homepage 'https://github.com/clab/fast_align'
  head 'https://github.com/clab/fast_align.git'

  def install
    system 'make'
    bin.install 'fast_align'
  end

  test do
    system bin/'fast_align', '-i', '/dev/null'
  end
end
