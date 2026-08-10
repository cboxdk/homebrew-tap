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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.0/telemetryd-0.24.0-aarch64-apple-darwin.tar.gz"
      sha256 "a905fd34e02d62585a9c6da353aed448740755d3d4203b328d977d3dc7436089"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.0/telemetryd-0.24.0-x86_64-apple-darwin.tar.gz"
      sha256 "19ccc3f36f90025f6a140ad44414da798f034196dec96693f7002c9f261dddb4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.0/telemetryd-0.24.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b5959b40fcdaf1a1c6f33b2cebcaa38c717a44b51969efccbf50a500c32d84dd"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.24.0/telemetryd-0.24.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ddaa6fe8f5bcaa4ea7f3ff770d1a0e185319e49257af4e3766663c42a257eabc"
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
