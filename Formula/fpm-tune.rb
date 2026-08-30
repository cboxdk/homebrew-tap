# Homebrew formula for fpm-tune.
#
# Lives in the fpm-tune repo so it is versioned with the code it installs, and is
# published to cboxdk/homebrew-tap by scripts/publish-formula.py from a release.
#
# fpm-tune manages a running PHP-FPM on a Linux server; on a Mac this is mainly for
# trying it and reading `fpm-tune plan`. There is deliberately no `service` block:
# on a real host it runs under systemd with --apply, not `brew services`.
class FpmTune < Formula
  desc "Autotune PHP-FPM pools against a host's real memory; reload, never restart"
  homepage "https://github.com/cboxdk/fpm-tune"
  version "0.1.0-beta.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.1/fpm-tune-0.1.0-beta.1-aarch64-apple-darwin.tar.gz"
      sha256 "97a778cdfb18fe41fc27109507b06feadb6ff7248c2dc5d0e2ed017a61f834f4"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.1/fpm-tune-0.1.0-beta.1-x86_64-apple-darwin.tar.gz"
      sha256 "59c08b48c9e6b8b4f61ea4c4f9f28a05f3d7f9c8cd3bf9f57ca3305be06c7d2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.1/fpm-tune-0.1.0-beta.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5970b497a4e53efaad66d0b271a70e87faf01d4bb740db49dbaa0145a77d5d0a"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.1/fpm-tune-0.1.0-beta.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "27fff14eb81f772300e33f9df5fddef9565d48935550898cb3e7a05d05642d6d"
    end
  end

  def install
    bin.install "fpm-tune"
    doc.install "README.md", "SECURITY.md", "LICENSE"
  end

  test do
    # The binary runs and reports the version it was built as. `plan` needs a live
    # PHP-FPM, which the sandbox has none of, so this is the honest limit of what
    # can be asserted here.
    assert_match version.to_s, shell_output("#{bin}/fpm-tune version")
  end
end
