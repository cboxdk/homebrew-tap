# Homebrew formula for fpm-tune — the SOURCE template.
#
# Versioned with the code so the formula can never describe a build that does not
# exist. The checksums are placeholders on purpose: they only exist once a release
# has been built, and `scripts/publish-formula.py` fills them in from the release's
# SHA256SUMS and pushes the result to cboxdk/homebrew-tap. A formula with
# real-looking digests nobody verified is worse than one that obviously is not ready.
#
# There is deliberately no `service` block: on a real host fpm-tune runs under
# systemd with --apply, managing a live PHP-FPM — not via `brew services`.
class FpmTune < Formula
  desc "Autotune PHP-FPM pools against a host's real memory; reload, never restart"
  homepage "https://github.com/cboxdk/fpm-tune"
  version "0.1.0-beta.12"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.12/fpm-tune-0.1.0-beta.12-darwin-arm64.tar.gz"
      sha256 "57c2a8f90fdd973cc356d3987f0cb117c7659eded0609da4ad9c341a5d5d22e4"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.12/fpm-tune-0.1.0-beta.12-darwin-amd64.tar.gz"
      sha256 "1d4a52419ae2d376d46470222c2e6351844ba969ac70a5850fe1dc52bdb83b1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.12/fpm-tune-0.1.0-beta.12-linux-arm64.tar.gz"
      sha256 "0c74331b73d93c6b07dcd4537d29e1423666b737bb9ffdef31436490b2b27dd2"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.12/fpm-tune-0.1.0-beta.12-linux-amd64.tar.gz"
      sha256 "0bc90958133825144f8cfa23b7ba7a93b1b7ef5a86e7f4ac90414ff3ed106cff"
    end
  end

  def install
    bin.install "fpm-tune"
    doc.install "README.md", "SECURITY.md", "LICENSE"
  end

  test do
    # The binary runs and reports the version it was built as. `plan` needs a live
    # PHP-FPM, which the sandbox has none of, so this is the honest limit here.
    assert_match version.to_s, shell_output("#{bin}/fpm-tune version")
  end
end
