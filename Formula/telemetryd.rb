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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.37.0/telemetryd-0.37.0-aarch64-apple-darwin.tar.gz"
      sha256 "ddf284bfff910d8aa43955ee314d0fa87fd08720a061185eea9b18fa2595c53d"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.37.0/telemetryd-0.37.0-x86_64-apple-darwin.tar.gz"
      sha256 "60b1069c11f137ab871bf7f28988bb20a6428f83b8554fee0e83eda29e68a236"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.37.0/telemetryd-0.37.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d3e38ee39b99e762a2096743ae7cd2ee4b88c05539e3a136003bb41d2a946e61"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.37.0/telemetryd-0.37.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7a8ce4322239a5cfe300fa375b13de53f59c0755fe6234c6e6d8cb4507505f03"
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
