class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.3.0.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.3.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.3.0.tar.gz"
  sha256 "7399e9a6708c32d678a72a63219e96f23be0be2336e50fd1348498d07041df90"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.7
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.3.0.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.3.0.tar.gz"
    sha256 "3dd51cd88d25133681106f68622ebedbf191ab25a21ea336ba409136591864b0"
    apply "patches/fileflags.diff"
  end

  # workaround for https://github.com/RsyncProject/rsync/issues/479
  patch do
    url "https://gist.githubusercontent.com/pmrowla/ca2d297227f3df72109e492d61994ad7/raw/d0569837ab8bc8b7eb568559d70337c7a1a7ba07/rsync-force-setattr.diff"
    sha256 "6783bf8319a9c63c83ca4ca6d76559a30c1b48d5b92c0160c50ac2830aa08c15"
    apply "rsync-force-setattr.diff"
  end

  def install
    args = %W[
      --with-rsyncd-conf=#{etc}/rsyncd.conf
      --with-included-popt=no
      --with-included-zlib=no
      --enable-ipv6
    ]

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "a"
    mkdir "b"

    ["foo\n", "bar\n", "baz\n"].map.with_index do |s, i|
      (testpath/"a/#{i + 1}.txt").write s
    end

    system bin/"rsync", "-artv", testpath/"a/", testpath/"b/"

    (1..3).each do |i|
      assert_equal (testpath/"a/#{i}.txt").read, (testpath/"b/#{i}.txt").read
    end
  end
end
