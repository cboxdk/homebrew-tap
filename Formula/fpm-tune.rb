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
  version "0.1.0-beta.25"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.25/fpm-tune-0.1.0-beta.25-darwin-arm64.tar.gz"
      sha256 "fb2156c74f69eb5b8414ce2b6e41892100a6abdd9e584ce00198179d572860bf"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.25/fpm-tune-0.1.0-beta.25-darwin-amd64.tar.gz"
      sha256 "ccc408a67a1df1324f58f5606ce4a9647c1a997652303d07b7a2285035e877a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.25/fpm-tune-0.1.0-beta.25-linux-arm64.tar.gz"
      sha256 "d76edce645d17d88856f7ba17ff67fd12be7f4e50554a078b1d6e965b86474fb"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.25/fpm-tune-0.1.0-beta.25-linux-amd64.tar.gz"
      sha256 "34f7d8a1aa51789262f1468e64674be3316ccb065ea744ba208e55dde2e18c2e"
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
