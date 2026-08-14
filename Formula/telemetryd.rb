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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.44.0/telemetryd-0.44.0-aarch64-apple-darwin.tar.gz"
      sha256 "37a0e88936d97e67d27f502b19388fae1b8586807c177b1e18da7982d0b2c1a7"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.44.0/telemetryd-0.44.0-x86_64-apple-darwin.tar.gz"
      sha256 "5e488c29ae5c91b6b5177f91b7415214412a8420f07b707175e3e4164f1d8ce3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.44.0/telemetryd-0.44.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5eb025977b9499cf8323ed84bda006ae1f021ee79d24b88391ee4c4b5d80c4ab"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.44.0/telemetryd-0.44.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e8ff5e66971db19e53b58dac1bda899ccbcf8920c5f3a599f68b624a0802f9a0"
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
