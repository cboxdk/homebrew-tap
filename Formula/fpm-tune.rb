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
  version "0.1.0-beta.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.6/fpm-tune-0.1.0-beta.6-darwin-arm64.tar.gz"
      sha256 "693249e043ca0bb114bf778525814a4ce68634cf60523623c2f78a996004bfe4"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.6/fpm-tune-0.1.0-beta.6-darwin-amd64.tar.gz"
      sha256 "d131b640de9d40ee1f9b928ce536d7b4bfad80c4f539d86c5ecbfb01375b48a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.6/fpm-tune-0.1.0-beta.6-linux-arm64.tar.gz"
      sha256 "3296ef257b597e6365d69a51d3ef48d68c1ec927830a533fb28eb19d46b9c9e3"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.6/fpm-tune-0.1.0-beta.6-linux-amd64.tar.gz"
      sha256 "faffcef73263c6c86d59d38c7e5652e210a8a0bba992cfc43562d69e99a68425"
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
