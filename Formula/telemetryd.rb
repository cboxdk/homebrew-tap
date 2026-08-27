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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.47.2/telemetryd-0.47.2-aarch64-apple-darwin.tar.gz"
      sha256 "0bd6652dcfbf4cac4ecf537634f8ec52f17f212a12017442b904bce3e1bbac4e"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.47.2/telemetryd-0.47.2-x86_64-apple-darwin.tar.gz"
      sha256 "8044ebeb997fd53f82a0ceae00f74fb78cec0fbacf0e76d536b70a970859b714"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.47.2/telemetryd-0.47.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0da2049a81a9fe8c40e04b26bf670429c37d2a310dabb7a2ff77a5cdf6d07e40"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.47.2/telemetryd-0.47.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "94e39e4acd492565524a4921ba2ee00a9f12040c321ab4e09625ee5cc127b75c"
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
