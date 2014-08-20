require 'formula'

class StanfordSegmenter < Formula
  homepage 'http://nlp.stanford.edu/software/segmenter.shtml'
  url 'http://nlp.stanford.edu/software/stanford-segmenter-2014-06-16.zip'
  sha1 '5cc5c30a238301d9648bf8ba329a6f73831bdb36'
  version '20140616'

  def install
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/*.sh"]
  end

  test do
    system "#{bin}/segment.sh", "ctb", "#{libexec}/test.simp.utf8", "UTF-8", "0"
  end
end
