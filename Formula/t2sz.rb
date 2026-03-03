class T2sz < Formula
  desc "Compress a file into a seekable zstd with per-file seeking for tar archives"
  homepage "https://github.com/martinellimarco/t2sz"
  url "https://github.com/martinellimarco/t2sz/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "06bcaee21dc37124ad3ce6f7a0dc3100a79fb0ea62d1692c6094929a78fd2598"
  license "GPL-3.0-or-later"
  head "https://github.com/martinellimarco/t2sz.git", branch: "master"

  bottle do
    root_url "https://github.com/martinellimarco/homebrew-t2sz/releases/download/t2sz-1.2.3"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c046c1288c545526dc95bef10ae30defdfd6fa1d187721b30312e877d5614db6"
    sha256 cellar: :any,                 sequoia:       "9ef22cb89d97410c33f12437c613c0673da3d6e83a9af492f4b71aea2536a771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "553fbcb6a4d9365557e1c3cc91b15db3e72ad811657b1579b005151964f01373"
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
