class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "4bdc590a8a2085951cfbe83ef6ab22b5fd4723163662e1aae41260c0b5a49a01"
  license "GPL-3.0-or-later"
  head "https://github.com/martinellimarco/t2sz.git", branch: "master"

  bottle do
    root_url "https://github.com/martinellimarco/homebrew-t2sz/releases/download/t2sz-1.2.5"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d15de4330527bdf7116bd446185cc9818fbc7cc7107a24377a4de0ad81041372"
    sha256 cellar: :any,                 sequoia:       "a14b6fc4ae556daf01544591c8ff25ecd39deed674d66003b406c3cdb45488eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2899b4bf72bc780b5b4a31e68e6c4a1d0f96e7afd04213e9a429cb6f15bf48e"
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
