# Homebrew formula for telemetryd.
#
# Lives here so it is versioned with the code it installs, which is what stops the
# formula describing a version that was never built.
#
# `scripts/publish-formula.py` fills in the checksums from a published release and
# pushes the result to cboxdk/homebrew-tap. The placeholders below are deliberate: a
# formula with real-looking checksums that nobody verified is worse than one that
# obviously is not ready.
class Telemetryd < Formula
  desc "Single-binary observability backend: OTLP in, Loki/Tempo/Prometheus APIs out"
  homepage "https://github.com/cboxdk/telemetryd"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.0/telemetryd-0.50.0-aarch64-apple-darwin.tar.gz"
      sha256 "5760c969a1041fa351e3b578c49a03b366e9cc62bb81f4476d03fca2e79b29ff"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.0/telemetryd-0.50.0-x86_64-apple-darwin.tar.gz"
      sha256 "bbcc0da43bdfdeff4cb09e7ad6a1e2b749a163b296059d1db7219a559a91c11c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.0/telemetryd-0.50.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "77de7c4f9b6eb9698bcbdf3bc2b034e7ffd9e457d28affa997d6012e51d59fd5"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.0/telemetryd-0.50.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f0182a87fd7e5b8edcdb5933da96bf9b6944a66c384567f44d8d1c3996353a8a"
    end
  end

  def install
    bin.install "telemetryd"
    doc.install "README.md", "COMPATIBILITY.md", "SECURITY.md"
    (etc/"telemetryd").install "telemetryd.toml.example"
  end

  service do
    run [opt_bin/"telemetryd", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/telemetryd.log"
    error_log_path var/"log/telemetryd.log"
  end

  test do
    # `version` proves the binary runs and reports its build target; `validate` proves
    # it can resolve a complete configuration from nothing, which is the product's
    # central claim.
    assert_match version.to_s, shell_output("#{bin}/telemetryd version")
    assert_match "Configuration is valid",
      shell_output("#{bin}/telemetryd validate --data-dir #{testpath}/data")
  end
end
