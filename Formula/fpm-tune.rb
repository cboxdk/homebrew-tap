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
  version "0.1.0-beta.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.3/fpm-tune-0.1.0-beta.3-aarch64-apple-darwin.tar.gz"
      sha256 "bfd6f969b5d46e85f80079cf67e2ad77cd7cc69f19ce4f58b16948c365718dc8"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.3/fpm-tune-0.1.0-beta.3-x86_64-apple-darwin.tar.gz"
      sha256 "687f010a1fdce4ee46b5760eb1566a7d6774ee1cb8f735df144ff4a34d8f8f83"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.3/fpm-tune-0.1.0-beta.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "11182ed5d09425868162c44888f09217add4ea4d5c4cea334c52ccdb3288eeb5"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.3/fpm-tune-0.1.0-beta.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "49e65bd13c873bc59c00f4d7c668a0f9710040c7e77a456c76c2bbe952b86326"
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
