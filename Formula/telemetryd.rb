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
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.4/telemetryd-0.20.4-aarch64-apple-darwin.tar.gz"
      sha256 "ad2df5494ea8db9b9c9f71d19f6246b0505d0ad49fd0a91dc5e4b13bf3792c12"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.4/telemetryd-0.20.4-x86_64-apple-darwin.tar.gz"
      sha256 "aa5f545a78cd1557355bfc83b4884bdf56b0e474bae0faad7d4e627965652ec7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.4/telemetryd-0.20.4-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3381a1533ba7d1becb353bf09cb66f1761f01da1875871cac0a07c9613f0c66c"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.4/telemetryd-0.20.4-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c679ce6775b706ba8db73cf11ae3b604abb89384660dc7ef3242ef19cd3d13db"
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
