class YtAudio < Formula
  desc "Download YouTube audio in the highest quality the macOS Music app plays"
  homepage "https://github.com/rib3ye/yt-audio"
  url "https://github.com/rib3ye/yt-audio/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b8256185e30165129ce5e2eb963eeccc99cf61f09c4cc0feab0447cb3ae77695"
  license "MIT"
  head "https://github.com/rib3ye/yt-audio.git", branch: "main"

  depends_on "atomicparsley"
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    bin.install "yt-audio"
  end

  test do
    assert_match "yt-audio", shell_output("#{bin}/yt-audio --help")
  end
end
