class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.0-615.tar.gz"
  version "1.5.0-615"
  sha256 "109d48b75e7ba34d5a0cb98346c098d9e0d29d58b6bc27b90014dbc558a491a4"
  head "https://github.com/axiomatic-systems/Bento4.git"

  depends_on :xcode => build
  conflicts_with "gpac", :because => "both install `mp42ts` binaries"

  def install
    cd "Build/Targets/universal-apple-macosx" do
      xcodebuild "-project", "Bento4.xcodeproj",
                 "-target", "Bento4",
                 "-target", "Bento4C",
                 "-target", "Apps",
                 "-configuration", "Release",
                 "clean",
                 "build"
      cd "build/Release" do
        bin.install "mp42aac", "mp42avc", "mp42hevc", "mp4dcfpackager", "mp4decrypt",
                    "mp4dump", "mp4edit", "mp4encrypt", "mp4extract", "mp4fragment",
                    "mp4split", "mp4compact", "mp4info", "mp4rtphintinfo",
                    "mp4tag", "mp4mux", "aac2mp4", "mp42ts", "mp42hls"
        lib.install "libBento4.a", "libBento4C.dylib"
      end
    end
    cd "Source/Python/wrappers" do
      bin.install "mp4dash", "mp4dashclone", "mp4hls"
    end
    include.install Dir["Source/C++/**/*.h"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
