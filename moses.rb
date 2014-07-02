require 'formula'

class Moses < Formula
  homepage 'http://www.statmt.org/moses/'
  head 'https://github.com/moses-smt/mosesdecoder.git'

  depends_on 'boost'
  depends_on 'boost-build' => :build
  depends_on 'xz'  # for liblzma

  def install
    args = ["--prefix=#{prefix}",
            "-j#{ENV.make_jobs}",
            'threading=multi',
            'install']

    system './bjam', *args
  end

  test do
    require 'open3'

    system 'curl', '-O', 'http://www.statmt.org/moses/download/sample-models.tgz'
    system 'tar', 'zxf', 'sample-models.tgz'
    cd 'sample-models'
    Open3.popen3(bin/'moses', '-f', 'phrase-model/moses.ini') do |stdin, stdout, stderr|
      stdin.write("das ist ein kleines haus\n")
      stdin.close
      assert_equal 'this is a small house', stdout.read.strip
    end
  end
end
