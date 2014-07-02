require 'formula'

class Kenlm < Formula
  homepage 'http://www.statmt.org/moses/'
  head 'http://kheafield.com/code/kenlm.tar.gz'

  depends_on 'boost'
  depends_on 'boost-build' => :build
  depends_on 'xz'  # for liblzma

  conflicts_with 'moses', :because => 'Moses provides KenLM'

  def install
    args = ["--prefix=#{prefix}",
            "-j#{ENV.make_jobs}"]

    system './bjam', *args
  end

  test do
    system bin/'lmplz'
  end
end
