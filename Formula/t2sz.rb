class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "088b4cc1896f1c85c92db572f0ac170a9231492e244305754ca9bd5287faaa69"
  license "GPL-3.0-or-later"
  head "https://github.com/martinellimarco/t2sz.git", branch: "main"

  bottle do
    root_url "https://github.com/martinellimarco/homebrew-t2sz/releases/download/t2sz-1.3.0"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "e1f50a9ccbd19c478736b4e6182ba7c188f5b38a45a16e55a06810450ca25105"
    sha256 cellar: :any, sequoia:       "2e5922c1149ccc86ce4a42cac3f70c483f5c3365d6e587500d00fbf5d3dcaf12"
    sha256 cellar: :any, x86_64_linux:  "94466b2ad5fa0fc6db01a30daa2b6363558fa3218852eca345cca4720b718f8a"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.txt").write "Hello, Homebrew!"
    system "tar", "cf", "test.tar", "-C", testpath, "hello.txt"
    system bin/"t2sz", "-o", "test.tar.zst", "test.tar"
    assert_path_exists testpath/"test.tar.zst"
    system "zstd", "-d", "test.tar.zst", "-o", "test.restored.tar"
    assert_equal (testpath/"test.tar").read, (testpath/"test.restored.tar").read
  end
end
