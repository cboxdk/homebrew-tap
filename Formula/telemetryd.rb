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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.34.0/telemetryd-0.34.0-aarch64-apple-darwin.tar.gz"
      sha256 "a13d2107218c1436b8dae20996ebee8bf6f50d82fc0376e14a192f819f49c840"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.34.0/telemetryd-0.34.0-x86_64-apple-darwin.tar.gz"
      sha256 "f5ea6d424366def262005ccb0a6e7f885baa947a947f63cdff0b74ea05bfa3f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.34.0/telemetryd-0.34.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "dbaea8eea692e65abef61cde754fa3ef4b28d9bb787afc4aef83d570c8427996"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.34.0/telemetryd-0.34.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "58c2d003163223af4a399196a9359faba8a3d1839f53f4b385ad0ef3772c4c9c"
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
