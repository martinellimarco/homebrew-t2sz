class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "PLACEHOLDER"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Round-trip: create a tar, compress with t2sz, decompress with zstd, compare
    (testpath/"hello.txt").write "Hello, Homebrew!"
    system "tar", "cf", "test.tar", "-C", testpath, "hello.txt"

    system bin/"t2sz", "test.tar", "-o", "test.tar.zst"
    assert_predicate testpath/"test.tar.zst", :exist?

    system "zstd", "-d", "test.tar.zst", "-o", "test.restored.tar"
    assert_equal (testpath/"test.tar").read, (testpath/"test.restored.tar").read
  end
end
