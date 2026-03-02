class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "0a39a2644aa1bec84dd31491bdafc6f4b4f2d5c8187144ff3273ea7e69c382a7"
  license "GPL-3.0-or-later"
  head "https://github.com/martinellimarco/t2sz.git", branch: "master"

  bottle do
    root_url "https://github.com/martinellimarco/homebrew-t2sz/releases/download/t2sz-1.2.1"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "71864c508b6518d768663fd83063af3468b3d6a1def2d9caaedd9cb8243a5a6f"
    sha256 cellar: :any,                 sequoia:       "cddae95ecfbe37527e48264198f893da8c853051a917512ac4e5919980d028cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f2184a309ab6549ff6d6b9b04d521108eb71b8ad9703fc6b2f64a8a6d4e5b22"
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
