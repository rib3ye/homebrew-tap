class Focus < Formula
  desc "Block distracting sites at the DNS level via a managed /etc/hosts blocklist"
  homepage "https://github.com/rib3ye/focus"
  url "https://github.com/rib3ye/focus/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3ede80bec209572520186d9d82496dd4e73ba5944cfea9fa47b9444af0669fd8"
  license "MIT"
  head "https://github.com/rib3ye/focus.git", branch: "main"

  depends_on :macos

  def install
    libexec.install "bin/focus", "bin/focus-hosts"
    bin.install_symlink libexec/"focus"
    pkgshare.install "blocklist.example"
    zsh_completion.install "completions/_focus" => "_focus"
  end

  def caveats
    <<~EOS
      focus edits /etc/hosts on `focus on`/`off`, which needs root, so those two
      commands prompt for your password. To make them password-free (a narrowly
      scoped sudoers rule plus a root-owned helper that only ever maps domains to
      127.0.0.1/::1), run once:

        focus install

      Your blocklist lives at ~/.config/focus/blocklist, seeded from the bundled
      example on first use and left untouched by upgrades.

      Before `brew uninstall`, run `focus remove` to clear any active block and
      undo the passwordless-sudo setup.
    EOS
  end

  test do
    assert_match "Usage: focus", shell_output("#{bin}/focus help")

    # Drive list/status against an isolated blocklist so the test never writes
    # /etc/hosts or needs root, whatever state the host machine is in.
    # FOCUS_BLOCKLIST overrides the real ~/.config location.
    blocklist = testpath/"blocklist"
    blocklist.write "youtube.com\nreddit.com\n"
    ENV["FOCUS_BLOCKLIST"] = blocklist
    assert_equal "youtube.com\nreddit.com\n", shell_output("#{bin}/focus list")
    assert_match "2 domains", shell_output("#{bin}/focus status")
  end
end
