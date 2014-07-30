require 'formula'

class Moses < Formula
  homepage 'http://www.statmt.org/moses/'
  head 'https://github.com/moses-smt/mosesdecoder.git'

  depends_on 'boost'
  depends_on 'boost-build' => :build
  depends_on 'xz'  # for liblzma

  conflicts_with 'kenlm', :because => 'Moses provides KenLM'

  resource 'sample-models' do
    url 'http://www.statmt.org/moses/download/sample-models.tgz'
    sha1 '33e8641cc30cac6eec9bc3ee77c3c60409c2b47e'
  end

  def install
    args = ["--prefix=#{prefix}",
            '--install-scripts',
            "-j#{ENV.make_jobs}",
            'threading=multi']

    system './bjam', *args

    resource('sample-models').stage do
      sample_models_path.install Dir['*']
    end
  end

  def caveats
    <<-EOS.undent
      The following additional files have been installed:

      Helper scripts
        #{prefix}/scripts

      Sample models
        #{share}/moses/sample-models
    EOS
  end

  test do
    require 'open3'

    cd sample_models_path
    Open3.popen3(bin/'moses', '-f', 'phrase-model/moses.ini') do |stdin, stdout, stderr|
      stdin.write("das ist ein kleines haus\n")
      stdin.close
      assert_equal 'this is a small house', stdout.read.strip
    end
  end

  def sample_models_path
    share/'moses/sample-models'
  end
end
