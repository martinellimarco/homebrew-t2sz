class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "ee693f035a01e2c663afec81ab03e172a6b3ed48f0d3c26815cca03423b9825b"
  license "GPL-3.0-or-later"
  head "https://github.com/martinellimarco/t2sz.git", branch: "master"

  bottle do
    root_url "https://github.com/martinellimarco/homebrew-t2sz/releases/download/t2sz-1.2.2"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d16e08a2f72a5a2484cbde1bd2703a812b01797e9eb1afa9f2fd33f2eae2d611"
    sha256 cellar: :any,                 sequoia:       "34c01d0526d70c2b9cba2f3b1c56777adf664c35f8ca1ed6ed514a7599763655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "824a6ab693351dd4fdd4f4d6ecd21088009e2fce07a7e93bf0c47775656bb578"
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
